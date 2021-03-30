local currentMenuX = 1
local selectedMenuX = 1
local currentMenuY = 4
local selectedMenuY = 4
local menuX = { 0.015, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75 }
local menuY = { 0.015, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5 } 
local frozen = false
local godmode = false
local isSpectatingTarget = false
local spectatedPlayer = nil
local infoOn = false    
local coordsText = ""   
local headingText = ""  
local modelText = ""   
local currBanIndex = 1
local selBanIndex = 1
local currGroupIndex = 1
local selGroupIndex = 1
local currLevelIndex = 1
local selLevelIndex = 1
local allowedToUseMenu = false
local allowedToNoclip = false
local allowedToFreeze = false
local allowedToUseGodmode = false
local allowedToUseInvisibility = false
local allowedToUnban = false
local allowedToCustomPed = false
local allowedToPedWipe = false
local allowedToCarWipe = false
local allowedToObjectWipe = false
local allowedToMassWipe = false
local allowedToSpawnVehicle = false
local allowedToBan = false
local allowedToRevive = false

BanLength = {"1 Hour", "3 Hours", "6 Hours", "12 Hours", "1 Day", "2 Days", "3 Days", "1 Week", "2 Weeks", "1 Month", "Permanent"}
PlayerGroups = {"user", "mod", "admin", "superadmin"}
PermLevels = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local function tpm()
	local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

        for height = 1, 1000 do
            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

            local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)
		end
	else
		exports['mythic_notify']:SendAlert('error', 'You must place a waypoint first.', 5000)
	end
end

RegisterNetEvent("venomadmin:CaptureScreenshot")
AddEventHandler('venomadmin:CaptureScreenshot', function(url)
	exports['screenshot-basic']:requestScreenshotUpload(GetConvar("ea_screenshoturl", url), GetConvar("ea_screenshotfield", 'files[]'), function(data)
        TriggerServerEvent("venomadmin:TookScreenshot", data)
    end)
end)

local function DrawPlayerInfo(player)
	drawTarget = player
	drawspectate = true
end

local function StopDrawPlayerInfo()
	drawspectate = false
	drawTarget = 0
end

local function drawspectext(text)
	SetTextFont(4)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.45, 0.005)
end
				
local function spectate(id)
	spectating = not spectating
	local player = GetPlayerPed(id)
	if spectating then
		RequestCollisionAtCoord(GetEntityCoords(player))
		NetworkSetInSpectatorMode(true, player)
		DrawPlayerInfo(id)
	else
		RequestCollisionAtCoord(GetEntityCoords(player))
		NetworkSetInSpectatorMode(false, player)
		StopDrawPlayerInfo()
	end
end

local function customped()
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
    
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    
    local modelhash = GetOnscreenKeyboardResult()
	
	if modelhash == nil then 
		modelhash = ""
	end

	if modelhash == "" then 
		return
	end
    
	local model = GetHashKey(modelhash)

	if IsModelValid(model) and IsModelAPed(model) then
    	RequestModel(model)
    	while not HasModelLoaded(model) do
        	Wait(100)
		end
	else
		exports['mythic_notify']:SendAlert('error', 'Invalid Ped Model.', 5000) 
	end

    SetPlayerModel(PlayerId(), model)
	SetModelAsNoLongerNeeded(model)
end

RegisterNetEvent('venomadmin:slap')
AddEventHandler('venomadmin:slap', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('venomadmin:clearloadout')
AddEventHandler('venomadmin:clearloadout', function()
	RemoveAllPedWeapons(PlayerPedId(), true)
end)

RegisterNetEvent('venomadmin:freeze')
AddEventHandler('venomadmin:freeze', function(toggle)
	frozen = toggle
	FreezeEntityPosition(PlayerPedId(), frozen)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), frozen)
	end 
end)

RegisterNetEvent('venomadmin:gotobring')
AddEventHandler('venomadmin:gotobring', function(x, y, z)
	SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, false)
end)

local function freeze()
	frozen = not frozen
	if frozen then
		TriggerServerEvent("venomadmin:freeze", GetPlayerServerId(selectedPlayer), true)
	else
		TriggerServerEvent("venomadmin:freeze", GetPlayerServerId(selectedPlayer), false)
	end
end

local function spawnvehicle(dawhip)
    RequestModel(GetHashKey(dawhip))
    Citizen.CreateThread(
        function()
            local cartimer = 0
            while not HasModelLoaded(GetHashKey(dawhip)) do
                cartimer = cartimer + 100.0
                Citizen.Wait(100.0)
                if cartimer > 5000 then
                    exports['mythic_notify']:SendAlert('error', 'Vehicle was unable to be spawned.', 5000) 
                    break
                end
            end
            SpawnedCar = CreateVehicle(GetHashKey(dawhip), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, true)
            SetVehicleEngineOn(SpawnedCar, true, true, false)
			SetPedIntoVehicle(PlayerPedId(), SpawnedCar, -1)
			SetVehicleNumberPlateText(SpawnedCar, "Spawn")
        end
    )
end

local function fixvehicle()
	local player = PlayerPedId()
	local carrito = GetVehiclePedIsIn(player, false)
	if IsPedInAnyVehicle(player, true) then
		SetVehicleEngineHealth(carrito, 1000)
		SetVehicleEngineOn(carrito, true, true)
		SetVehicleFixed(carrito)
		exports['mythic_notify']:SendAlert('inform', 'Vehicle Fixed.', 5000)
	else
		exports['mythic_notify']:SendAlert('error', 'You are not in a vehicle.', 5000)
	end
end

local function cleanvehicle()
	local player = PlayerPedId()
	local carrito = GetVehiclePedIsIn(player, false)
	if IsPedInAnyVehicle(player, true) then
		SetVehicleDirtLevel(carrito, 0)
		exports['mythic_notify']:SendAlert('inform', 'Vehicle Cleaned.', 5000)
	else
		exports['mythic_notify']:SendAlert('error', 'You are not in a vehicle.', 5000)
	end
end

local function flipvehicle()
	local ppd = PlayerPedId()
	local dacar = GetVehiclePedIsIn(ppd)
	if IsPedInAnyVehicle(ppd, true) then
		if not IsVehicleOnAllWheels(dacar) then
			SetVehicleOnGroundProperly(dacar)
			exports['mythic_notify']:SendAlert('inform', 'Vehicle Flipped.', 5000)
		else
			exports['mythic_notify']:SendAlert('error', 'Your vehicle is not upside down.', 5000)
		end
	else
		exports['mythic_notify']:SendAlert('error', 'You are not in a vehicle.', 5000)
	end
end

local function deletevehicle()
	local ped = PlayerPedId()
	local vehs = GetVehiclePedIsIn(ped)
	if IsPedInAnyVehicle(ped, true) then
		DeleteVehicle(vehs)
	else
		exports['mythic_notify']:SendAlert('error', 'You are not in a vehicle.', 5000)
	end
end

local function selfheal()
	local ped = PlayerPedId()
	SetEntityHealth(ped, 200)  
	exports['mythic_notify']:SendAlert('inform', 'Healed.', 5000)
end

local function selfarmor()
	SetPedArmour(PlayerPedId(), 100)
	exports['mythic_notify']:SendAlert('inform', 'Armor Applied.', 5000)
end

local function selfinvis()
	invis = not invis
	if not invis then
		SetEntityVisible(PlayerPedId(), true)
	end
end

local function selfgodmode()
	godmode = not godmode
end

local function getEntity(player)                                      
    local result, entity = GetEntityPlayerIsFreeAimingAt(player)    
    return entity                                                  
end                                                               

local function DrawInfos(text)
    SetTextColour(255, 255, 255, 255) 
    SetTextFont(1)                     
    SetTextScale(0.4, 0.4)            
    SetTextWrap(0.0, 1.0)             
    SetTextCentre(false)              
    SetTextDropshadow(0, 0, 0, 0, 255)  
    SetTextEdge(50, 0, 0, 0, 255)      
    SetTextOutline()                    
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.015, 0.71)               
end

local function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

local function DrawGenericText(text)
	SetTextColour(255, 5, 255, 255)
	SetTextFont(7)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.40, 0.0)
end

FormatCoord = function(coord)
	if coord == nil then
		return "unknown"
	end

	return tonumber(string.format("%.2f", coord))
end

Citizen.CreateThread(function()
  TriggerServerEvent("venomadmin:openmenucheck")
  TriggerServerEvent("venomadmin:godmodecheck")
  TriggerServerEvent("venomadmin:freezeplayercheck")
  TriggerServerEvent("venomadmin:manageplayercheck")
  TriggerServerEvent("venomadmin:invisibilitycheck")
  TriggerServerEvent("venomadmin:unbancheck")
  TriggerServerEvent("venomadmin:custompedcheck")
  TriggerServerEvent("venomadmin:pedwipecheck")
  TriggerServerEvent("venomadmin:objectwipecheck")
  TriggerServerEvent("venomadmin:masswipecheck")
  TriggerServerEvent("venomadmin:noclipcheck")
  TriggerServerEvent("venomadmin:spawnvehiclecheck")
  TriggerServerEvent("venomadmin:carwipecheck")
  TriggerServerEvent("venomadmin:banplayercheck")
  TriggerServerEvent("venomadmin:reviveplayercheck")
  TriggerServerEvent("venomadmin:gotobringplayercheck")
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		TriggerServerEvent("venomadmin:requestCachedPlayers") 
	end
end)

RegisterNetEvent("venomadmin:openmenu")
AddEventHandler("venomadmin:openmenu", function(isAllowedtoOpenMenu)
    allowedToUseMenu = isAllowedtoOpenMenu
end)

RegisterNetEvent("venomadmin:bandahomie")
AddEventHandler("venomadmin:bandahomie", function(isAllowedtoBan)
    allowedToBan = isAllowedtoBan
end)

RegisterNetEvent("venomadmin:managedahomie")
AddEventHandler("venomadmin:managedahomie", function(isAllowedtoManage)
    allowedToManage = isAllowedtoManage
end)

RegisterNetEvent("venomadmin:freezedahomie")
AddEventHandler("venomadmin:freezedahomie", function(isAllowedtoFreeze)
    allowedToFreeze = isAllowedtoFreeze
end)

RegisterNetEvent("venomadmin:gotobringdahomie")
AddEventHandler("venomadmin:gotobringdahomie", function(isAllowedtoGotoBring)
    allowedToGotoBring = isAllowedtoGotoBring
end)

RegisterNetEvent("venomadmin:revivedahomie")
AddEventHandler("venomadmin:revivedahomie", function(isAllowedtoRevive)
    allowedToRevive = isAllowedtoRevive
end)

RegisterNetEvent("venomadmin:noclip")
AddEventHandler("venomadmin:noclip", function(isAllowedtoNoclip)
    allowedToNoclip = isAllowedtoNoclip
end)

RegisterNetEvent("venomadmin:godmode")
AddEventHandler("venomadmin:godmode", function(isAllowedtoUseGodmode)
    allowedToUseGodmode = isAllowedtoUseGodmode
end)

RegisterNetEvent("venomadmin:invisibility")
AddEventHandler("venomadmin:invisibility", function(isAllowedtoUseInvisibility)
    allowedToUseInvisibility = isAllowedtoUseInvisibility
end)

RegisterNetEvent("venomadmin:unbanplayer")
AddEventHandler("venomadmin:unbanplayer", function(isAllowedtoUnban)
    allowedToUnban = isAllowedtoUnban
end)

RegisterNetEvent("venomadmin:customped")
AddEventHandler("venomadmin:customped", function(isAllowedtoCustomPed)
    allowedToCustomPed = isAllowedtoCustomPed
end)

RegisterNetEvent("venomadmin:pedwipe")
AddEventHandler("venomadmin:pedwipe", function(isAllowedtoPedWipe)
    allowedToPedWipe = isAllowedtoPedWipe
end)

RegisterNetEvent("venomadmin:objectwipe")
AddEventHandler("venomadmin:objectwipe", function(isAllowedtoObjectWipe)
    allowedToObjectWipe = isAllowedtoObjectWipe
end)

RegisterNetEvent("venomadmin:masswipe")
AddEventHandler("venomadmin:masswipe", function(isAllowedtoMassWipe)
    allowedToMassWipe = isAllowedtoMassWipe
end)

RegisterNetEvent("venomadmin:carwipe")
AddEventHandler("venomadmin:carwipe", function(isAllowedtoCarWipe)
    allowedToCarWipe = isAllowedtoCarWipe
end)

RegisterNetEvent("venomadmin:spawnvehicle")
AddEventHandler("venomadmin:spawnvehicle", function(isAllowedtoSpawnVehicle)
    allowedToSpawnVehicle = isAllowedtoSpawnVehicle
end)

cachedplayers = {}

RegisterNetEvent("venomadmin:fillCachedPlayers")
AddEventHandler("venomadmin:fillCachedPlayers", function(thecached)
	cachedplayers = thecached
end)

Citizen.CreateThread(function()

	WarMenu.CreateMenu('venom', 'WarMenu')
	WarMenu.SetSubTitle('venom', 'MadLife RP- Admin Menu')
	WarMenu.CreateSubMenu('vehicle', 'venom', 'Vehicle')
	WarMenu.CreateSubMenu('player', 'venom', 'Player List')
	WarMenu.CreateSubMenu('self', 'venom', 'Self')
    WarMenu.CreateSubMenu('util', 'venom', 'Utilities')
    WarMenu.CreateSubMenu('dev', 'venom', 'Dev Tools')
    WarMenu.CreateSubMenu('set', 'venom', 'Settings')

	WarMenu.CreateSubMenu('displayers', 'player', 'Disconnected Players')
	WarMenu.CreateSubMenu('unban', 'player', 'Unban Player')
	WarMenu.CreateSubMenu('steam', 'unban', 'Enter Player Steam Name')
	WarMenu.CreateSubMenu('selectedPlayerOptionsdisc', 'displayers', 'Selected Player Options') 
	WarMenu.CreateSubMenu('selectedPlayerOptions', 'player', 'Selected Player Options')
	WarMenu.CreateSubMenu('selectedPlayerInfo', 'selectedPlayerOptions', 'Selected Player Info')
	WarMenu.CreateSubMenu('setgroup', 'selectedPlayerInfo', 'Set Player Group')
	WarMenu.CreateSubMenu('setperms', 'selectedPlayerInfo', 'Set Player Permission Level')
    WarMenu.CreateSubMenu('kick', 'selectedPlayerOptions', 'Are You Sure?')
	WarMenu.CreateSubMenu('ban', 'selectedPlayerOptions', 'Are You Sure?')
	WarMenu.CreateSubMenu('offlineban', 'selectedPlayerOptionsdisc', 'Are You Sure?')

	while true do

		playerhealth = GetEntityHealth(GetPlayerPed(selectedPlayer))
		playerarmor = GetPedArmour(GetPlayerPed(selectedPlayer))
		if WarMenu.IsMenuOpened('venom') then
			if WarMenu.MenuButton('Player List', 'player') then 
			elseif WarMenu.MenuButton('Vehicle Options', 'vehicle') then
			elseif WarMenu.MenuButton('Self Options', 'self') then
			elseif WarMenu.MenuButton('Dev Tools', 'dev') then
			elseif WarMenu.MenuButton('Utilities', 'util') then
            elseif WarMenu.MenuButton('Settings', 'set') then
			elseif WarMenu.Button('Exit') then WarMenu.CloseMenu()
            end
			
		elseif WarMenu.IsMenuOpened('player') then
			WarMenu.SetSubTitle('player', 'Players Online - ' ..#GetActivePlayers())
			local hom = GetHomies()
			for k, v in pairs(hom) do
				local currentPlayer = v
				if WarMenu.MenuButton(GetPlayerName(currentPlayer).." (ID - "..GetPlayerServerId(currentPlayer)..")", 'selectedPlayerOptions') then
					selectedPlayer = currentPlayer 
				end
			end
			if WarMenu.MenuButton('Disconnected Players', 'displayers') then
			end
			if allowedToUnban then
				if WarMenu.MenuButton('Unban Player', 'unban') then
				end
			end
			if WarMenu.Button('Back') then
				WarMenu.OpenMenu('venom')
			end

		elseif WarMenu.IsMenuOpened('displayers') then
			for _, cps in pairs(cachedplayers) do
				if cps.name ~= nil and cps.id ~= nil and cps.id < 1000 then
					if WarMenu.MenuButton(cps.name.." (ID - "..cps.id..")", 'selectedPlayerOptionsdisc') then
						seldiscplayer = cps 
					end
				end
			end
			if WarMenu.Button('Back') then
				WarMenu.OpenMenu('player')
			end
		elseif WarMenu.IsMenuOpened('unban') then
			if WarMenu.MenuButton('Enter Player Steam Hex', 'steam') then
				WarMenu.SetSubTitle('unban', 'ex: steam:110000106142c6f')
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
				
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end
					
				local result = GetOnscreenKeyboardResult()

				if result == nil then 
					WarMenu.OpenMenu('unban')
					result = "a"
				elseif result == "" then
					WarMenu.OpenMenu('unban')
					result = "a"
				end

				local length = string.len(result)

				if not string.match(result, "steam") then
					exports['mythic_notify']:SendAlert('error', 'Invalid Steam Hex.', 5000) 
					WarMenu.OpenMenu('unban')
				elseif length < 21 then
					exports['mythic_notify']:SendAlert('error', 'Invalid Steam Hex.', 5000) 
					WarMenu.OpenMenu('unban')
				elseif length > 21 then
					exports['mythic_notify']:SendAlert('error', 'Invalid Steam Hex.', 5000) 
					WarMenu.OpenMenu('unban')
				end
				
				targetU = result
			end
			if WarMenu.Button('Back') then
				WarMenu.OpenMenu('player')
			end
		
		elseif WarMenu.IsMenuOpened('steam') then
			WarMenu.SetSubTitle('steam', 'Are You Sure?')
			if WarMenu.Button('Yes') then
				TriggerServerEvent('venomadmin:unban', targetU)
				exports['mythic_notify']:SendAlert('inform', 'Player Unbanned.', 5000) 
				WarMenu.OpenMenu('player')
			elseif WarMenu.Button('No') then
				WarMenu.OpenMenu('player')
			end

		elseif WarMenu.IsMenuOpened('selectedPlayerOptionsdisc') then
			WarMenu.SetSubTitle('selectedPlayerOptionsDisc', ''..seldiscplayer.name..' (ID - '..seldiscplayer.id..')')
			if WarMenu.MenuButton('Offline Ban Player', 'offlineban') then
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('player')
			end

		elseif WarMenu.IsMenuOpened('selectedPlayerOptions') then
			WarMenu.SetSubTitle('selectedPlayerOptions', ''..GetPlayerName(selectedPlayer)..' (ID - '..GetPlayerServerId(selectedPlayer)..')')
			if WarMenu.MenuButton('Kick Player', 'kick') then	
			end
			if allowedToBan then	
				if WarMenu.MenuButton('Ban Player', 'ban') then
				end
			end
			if WarMenu.Button("Spectate Player", isSpectatingTarget and '~w~Spectating: ~s~['..GetPlayerServerId(spectatedPlayer)..']') then
				spectatedPlayer = selectedPlayer
				spectate(spectatedPlayer)
			end
			if allowedToGotoBring then
            	if WarMenu.Button("Goto Player") then
					TriggerServerEvent("venomadmin:gotobutton", GetPlayerServerId(selectedPlayer))
				elseif WarMenu.Button("Bring Player") then
					TriggerServerEvent("venomadmin:bringbutton", GetPlayerServerId(selectedPlayer))
				end
			end
			if WarMenu.Button("Clear Loadout") then
				TriggerServerEvent("venomadmin:clearloadout", GetPlayerServerId(selectedPlayer))
			end
			if allowedToRevive then
            	if WarMenu.Button("Revive") then 
					TriggerServerEvent("venomadmin:revive", GetPlayerServerId(selectedPlayer))
				end
			end
            if WarMenu.Button("Force Skin") then
                TriggerServerEvent("venomadmin:forceskin", GetPlayerServerId(selectedPlayer))
			elseif WarMenu.Button("Slap Player") then
				TriggerServerEvent("venomadmin:slap", GetPlayerServerId(selectedPlayer))
			end
			if allowedToFreeze then
				if WarMenu.CheckBox("Freeze Player", frozen) then
					freeze()
				end
			end
			if WarMenu.Button('Take Screenshot', 'DO NOT SPAM') then
				TriggerServerEvent("venomadmin:TakeScreenshot", GetPlayerServerId(selectedPlayer))
			end
			if allowedToManage then
				if WarMenu.MenuButton('Manage Player', 'selectedPlayerInfo') then
				end
			end
			if WarMenu.Button('Health: '..playerhealth) then
			elseif WarMenu.Button('Armor: '..playerarmor) then
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('player')
			end

		elseif WarMenu.IsMenuOpened('selectedPlayerInfo') then
			WarMenu.SetSubTitle('selectedPlayerInfo', ''..GetPlayerName(selectedPlayer)..' (ID - '..GetPlayerServerId(selectedPlayer)..')')
			if WarMenu.Button('Set Player Money') then
				local player = GetPlayerServerId(selectedPlayer)
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end
				local result = GetOnscreenKeyboardResult()
				local money = tonumber(result)
				TriggerServerEvent('venomadmin:setmoney', player, money)
			elseif WarMenu.Button('Set Player Bank') then
				local player = GetPlayerServerId(selectedPlayer)
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end
				local result = GetOnscreenKeyboardResult()
				local bank = tonumber(result)
				TriggerServerEvent('venomadmin:setbank', player, bank)
			elseif WarMenu.MenuButton('Set Player Group', 'setgroup') then
			elseif WarMenu.MenuButton('Set Player Permission Level', 'setperms') then
			end

		elseif WarMenu.IsMenuOpened('setgroup') then
			if WarMenu.ComboBox("Group", PlayerGroups, currGroupIndex, selGroupIndex, function(currentIndex, selectedIndex)
                currGroupIndex = currentIndex
                selGroupIndex = currentIndex
                chosengroup = PlayerGroups[currentIndex]
            end) then 
            elseif WarMenu.Button('Confirm') then
				local player = GetPlayerServerId(selectedPlayer)
				local group = chosengroup
				
				TriggerServerEvent('venomadmin:setgroup', player, group)
				WarMenu.OpenMenu('selectedPlayerInfo')
			end
		
		elseif WarMenu.IsMenuOpened('setperms') then
			if WarMenu.ComboBox("Level", PermLevels, currLevelIndex, selLevelIndex, function(currentIndex, selectedIndex)
                currLevelIndex = currentIndex
                selLevelIndex = currentIndex
                chosenlevel = PermLevels[currentIndex]
            end) then 
            elseif WarMenu.Button('Confirm') then
				local player = GetPlayerServerId(selectedPlayer)
				local level = chosenlevel
				
				TriggerServerEvent('venomadmin:setpermissionlevel', player, level)
				WarMenu.OpenMenu('selectedPlayerInfo')
			end

		elseif WarMenu.IsMenuOpened('kick') then
			if WarMenu.Button('Reason:', KickReason) then
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)				
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end					
				local result = GetOnscreenKeyboardResult()
				KickReason = result
				if KickReason == "" then 
					KickReason = "No Reason Specified."
				end
			elseif WarMenu.Button('Confirm') then
				if KickReason == nil then 
					KickReason = "No Reason Specified."
				end
				TriggerServerEvent('venomadmin:kickplayer', GetPlayerServerId(selectedPlayer), KickReason)
				WarMenu.OpenMenu('player')
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('selectedPlayerOptions')
			end
		elseif WarMenu.IsMenuOpened('ban') then
			if WarMenu.Button('Reason:', BanReason) then
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end
				local result = GetOnscreenKeyboardResult()
				BanReason = result
				if BanReason == "" then
					BanReason = "No Reason Specified."
				end
			elseif WarMenu.ComboBox("Ban Length", BanLength, currBanIndex, selBanIndex, function(currentIndex, selectedIndex)
				currBanIndex = currentIndex
				selBanIndex = currentIndex
				duration = BanLength[currentIndex]
				if duration == "1 Hour" then
					duration = 3600
				elseif duration == "3 Hours" then
					duration = 10800
				elseif duration == "6 Hours" then
					duration = 21600
				elseif duration == "12 Hours" then
					duration = 43200
				elseif duration == "1 Day" then
					duration = 86400
				elseif duration == "2 Days" then
					duration = 172800
				elseif duration == "3 Days" then
					duration = 259200
				elseif duration == "1 Week" then
					duration = 518400
				elseif duration == "2 Weeks" then
						duration = 1123200
				elseif duration == "1 Month" then
					duration = 2678400
				elseif duration == "Permanent" then
					duration = 10444633200
				end
			end) then 
			elseif WarMenu.Button('Confirm') then
				if BanReason == nil then
					BanReason = "No Reason Specified."
				end
				local duration = duration
				TriggerServerEvent('venomadmin:banplayer', GetPlayerServerId(selectedPlayer), BanReason, duration)
				WarMenu.OpenMenu('player')
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('selectedPlayerOptions')
			end
		elseif WarMenu.IsMenuOpened('offlineban') then
			if WarMenu.Button('Reason:', offlinebanreason) then
				DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
				while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
					Citizen.Wait(0)
				end
				local result = GetOnscreenKeyboardResult()
				offlinebanreason = result
				if offlinebanreason == "" then
					offlinebanreason = "No Reason Specified."
				end
			elseif WarMenu.ComboBox("Ban Length", BanLength, currBanIndex, selBanIndex, function(currentIndex, selectedIndex)
				currBanIndex = currentIndex
				selBanIndex = currentIndex
				dursoo = BanLength[currentIndex]
				if dursoo == "1 Hour" then
					dursoo = 3600
				elseif dursoo == "3 Hours" then
					dursoo = 10800
				elseif dursoo == "6 Hours" then
					dursoo = 21600
				elseif dursoo == "12 Hours" then
					dursoo = 43200
				elseif dursoo == "1 Day" then
					dursoo = 86400
				elseif dursoo == "2 Days" then
					dursoo = 172800
				elseif dursoo == "3 Days" then
					dursoo = 259200
				elseif dursoo == "1 Week" then
					dursoo = 518400
				elseif dursoo == "2 Weeks" then
					dursoo = 1123200
				elseif dursoo == "1 Month" then
					dursoo = 2678400
				elseif dursoo == "Permanent" then
					dursoo = 10444633200
				end
			end) then 
			elseif WarMenu.Button('Confirm') then
				if offlinebanreason == nil then
					offlinebanreason = "No Reason Specified."
				end
				local dursio = dursoo
				TriggerServerEvent('venomadmin:offlinebanplayer', seldiscplayer.id, seldiscplayer.license, seldiscplayer.steam, seldiscplayer.live, seldiscplayer.xbl, seldiscplayer.discord, seldiscplayer.ip, seldiscplayer.name, dursio, offlinebanreason)
				WarMenu.OpenMenu('player')
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('selectedPlayerOptionsDisc')
			end
		elseif WarMenu.IsMenuOpened('vehicle') then
			WarMenu.SetSubTitle('vehicle', 'Vehicle Options')
			if allowedToSpawnVehicle then
				if WarMenu.Button("Spawn Vehicle") then
					DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 64 + 1)
		
					while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
						Citizen.Wait(0)
					end
					
					local spawndawhip = GetOnscreenKeyboardResult()
					if spawndawhip and IsModelValid(spawndawhip) and IsModelAVehicle(spawndawhip) then
						if spawndawhip == "adder" then
							exports['mythic_notify']:SendAlert('error', 'This vehicle is blacklisted.', 5000)
						else
							spawnvehicle(spawndawhip)
						end
					else
						exports['mythic_notify']:SendAlert('error', 'Invalid Vehicle Model.', 5000)
					end
				end
			end
            if WarMenu.Button("Fix Vehicle") then
                fixvehicle()
			elseif WarMenu.Button('Clean Vehicle') then
				cleanvehicle()
			elseif WarMenu.Button("Flip Vehicle") then
				flipvehicle()
			elseif WarMenu.Button("Delete Vehicle") then
				deletevehicle()
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('venom')
            end

		elseif WarMenu.IsMenuOpened('self') then
			WarMenu.SetSubTitle('self', 'Self Options')
			if WarMenu.Button("Heal") then
				selfheal()
			elseif WarMenu.Button("Full Armor") then
				selfarmor()
			elseif WarMenu.Button("Force Skin") then
				TriggerEvent("asd_skin:openSaveableMenu")
			end
			if allowedToUseInvisibility then
				if WarMenu.CheckBox('Invisibility', invis) then
					selfinvis()
				end
			end
			if allowedToUseGodmode then
				if WarMenu.CheckBox('Godmode', godmode) then
					selfgodmode()
				end
			end
			if allowedToNoclip then
				if WarMenu.CheckBox('Noclip', noclip) then
					noclip = not noclip
					if noclip then
						SetEntityVisible(PlayerPedId(), false, false)
					else
						SetEntityRotation(GetVehiclePedIsIn(PlayerPedId(), 0), GetGameplayCamRot(2), 2, 1)
						SetEntityVisible(GetVehiclePedIsIn(PlayerPedId(), 0), true, false)
						SetEntityVisible(PlayerPedId(), true, false)
					end
				end
			end
			if WarMenu.Button('Back') then
				WarMenu.OpenMenu('venom')
			end
		
		elseif WarMenu.IsMenuOpened('dev') then
			if WarMenu.CheckBox('ID Gun', infoOn) then
				infoOn = not infoOn
			elseif WarMenu.CheckBox('Coords', coordsVisible) then
				coordsVisible = not coordsVisible
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('venom')
            end    
            
        elseif WarMenu.IsMenuOpened('set') then
            if WarMenu.ComboBox('Menu X', menuX, currentMenuX, selectedMenuX, 
                function(currentIndex, selectedIndex)
                    currentMenuX = currentIndex
                    selectedMenuX = selectedIndex
                    for i = 1, #menus_list do
                        WarMenu.SetMenuX(menus_list[i], menuX[currentMenuX])
                    end
                end) 
                then
            elseif WarMenu.ComboBox('Menu Y', menuY, currentMenuY, selectedMenuY, 
                function(currentIndex, selectedIndex)
                    currentMenuY = currentIndex
                    selectedMenuY = selectedIndex
                    for i = 1, #menus_list do
                        WarMenu.SetMenuY(menus_list[i], menuY[currentMenuY])
                    end
                end)
				then
			elseif WarMenu.Button(ConfigCL.ServerName) then
			elseif WarMenu.Button('discord.gg/SzuGkZ2gJ8') then
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('venom')
            end    

		elseif WarMenu.IsMenuOpened('util') then
			if WarMenu.Button("Teleport to Waypoint") then
				tpm()
			end
			if allowedToCustomPed then
				if WarMenu.Button("Custom Ped") then
					customped()
				end
			end
			if allowedToCarWipe then
				if WarMenu.Button("Car Wipe", "Instant") then
					TriggerEvent('venomadmin:utilone')
				end
			end
			if allowedToMassWipe then
				if WarMenu.Button("Entity Wipe", "Instant") then
					TriggerEvent('venomadmin:untilthree')
					TriggerEvent('venomadmin:utiltwo')
					TriggerEvent('venomadmin:utilone')
				end
			end
			if WarMenu.Button('Refresh Disconnected Players') then
				TriggerServerEvent("venomadmin:requestCachedPlayers")
			elseif WarMenu.Button('Back') then
				WarMenu.OpenMenu('venom')
			end

		elseif IsControlJustReleased(0, ConfigCL.OpenMenu) then 
			if allowedToUseMenu then
				WarMenu.OpenMenu('venom')
			end
		end

        WarMenu.Display()

		SetPlayerInvincible(PlayerId(), godmode)
	
		if coordsVisible then
			local playerPed = PlayerPedId()
			local playerX, playerY, playerZ = table.unpack(GetEntityCoords(playerPed))
			local playerH = GetEntityHeading(playerPed)
			DrawGenericText(("~g~X~w~: %s ~g~Y~w~: %s ~g~Z~w~: %s ~g~H~w~: %s"):format(FormatCoord(playerX), FormatCoord(playerY), FormatCoord(playerZ), FormatCoord(playerH)))
		end

		if noclip then
			local NoclipSpeed = 1
            local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), 0)
            local k = nil
            local x, y, z = nil
            
            if not isInVehicle then
                k = PlayerPedId()
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 2))
            else
                k = GetVehiclePedIsIn(PlayerPedId(), 0)
                x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), 1))
            end
            
            if isInVehicle and GetSeatPedIsIn(PlayerPedId()) ~= -1 then RequestControlOnce(k) end
            
            local dx, dy, dz = GetCamDirection()
            SetEntityVisible(PlayerPedId(), 0, 0)
            SetEntityVisible(k, 0, 0)
            
            SetEntityVelocity(k, 0.0001, 0.0001, 0.0001)
            
            if IsDisabledControlPressed(0, 32) then -- MOVE FORWARD
                x = x + NoclipSpeed * dx
                y = y + NoclipSpeed * dy
                z = z + NoclipSpeed * dz
            end
            
            if IsDisabledControlPressed(0, 269) then -- MOVE BACK
                x = x - NoclipSpeed * dx
                y = y - NoclipSpeed * dy
                z = z - NoclipSpeed * dz
            end
			
			if IsDisabledControlPressed(0, 22) then -- MOVE UP
                z = z + NoclipSpeed
            end
            
			if IsDisabledControlPressed(0, 36) then -- MOVE DOWN
                z = z - NoclipSpeed
            end
            
            SetEntityCoordsNoOffset(k, x, y, z, true, true, true)
        end
		
		if infoOn then                                     
            pause = 5                                       
            local player = GetPlayerPed(-1)               
            if IsPlayerFreeAiming(PlayerId()) then          
                local entity = getEntity(PlayerId())       
                local coords = GetEntityCoords(entity)     
                local heading = GetEntityHeading(entity)   
                local model = GetEntityModel(entity)        
                coordsText = coords                        
                headingText = heading                      
                modelText = model                           
            end                                           
            DrawInfos("Coordinates: " .. coordsText .. "\nHeading: " .. headingText .. "\nHash: " .. modelText)    
        end     

		if invis then
            SetEntityVisible(PlayerPedId(), 0, 0)
        end

		if drawspectate then
			local targetPed = GetPlayerPed(drawTarget)
			local thaname = GetPlayerName(selectedPlayer)
			drawspectext("Spectating: "..thaname.."\nPress [E] to Stop Spectating")
			
			if IsControlJustPressed(0, 103) then
				spectate(targetPed)
				StopDrawPlayerInfo()
			end
			
		end

		Citizen.Wait(1)
	end
end)

RegisterCommand("die", function()
	SetEntityHealth(PlayerPedId(), 0)
end, false)
