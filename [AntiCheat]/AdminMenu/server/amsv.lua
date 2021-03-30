local savedCoords = {}

BanWebhookMenu = function(playerId,reason, duration)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local steamid  = ""
    local discord  = "Not Linked"

    if duration == 3600 then
        duration = "1 Hour"
    elseif duration == 10800 then
        duration = "3 Hours"
    elseif duration == 21600 then
        duration = "6 Hours"
    elseif duration == 43200 then
        duration = "12 Hours"
    elseif duration == 86400 then
        duration = "1 Day"
    elseif duration == 172800 then
        duration = "2 Days"
    elseif duration == 259200 then
        duration = "3 Days"
    elseif duration == 518400 then
        duration = "1 Week"
    elseif duration == 1123200 then
        duration = "2 Weeks"
    elseif duration == 2678400 then
        duration = "1 Month"
    elseif duration == 10444633200 then
        duration = "Permanent"
    end

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Banned",
        ["description"] = '**[Admin Menu]:** A Player has been banned. **Name: **'..name..' | **Details: **'..reason..' | **Ban Length: **'..duration..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.KickBanWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = "https://imgur.com/a/5KmFLZU", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

OfflineBanMenu = function(playerId, reason, duration, name, steam, discord)

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Offline Banned",
        ["description"] = '**[Admin Menu]:** A Player has been offline banned. **Name: **'..name..' | **Details: **'..reason..' | **Ban Length: **'..duration..' | **Identifiers:** Steam Hex: '..steam..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.KickBanWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

KickWebhookMenu = function(playerId,reason)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Kicked",
        ["description"] = '**[Admin Menu]:** A Player has been kicked. **Name: **'..name..' | **Details: **'..reason..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.KickBanWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

ScreenshotWebhook = function(playerId)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Screenshot Taken",
        ["description"] = '**[Admin Menu]:** A Player took a screenshot | **Details: **'..src..' took a screenshot of '..name..'\'s screen | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.ScreenshotLogsWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

ReviveWebhook = function(playerId)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Revived",
        ["description"] = '**[Admin Menu]:** A staff member revived another player | **Details: **'..src..' revived '..name..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.ReviveWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

ForceskinWebhook = function(playerId)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Force Skinned",
        ["description"] = '**[Admin Menu]:** A staff member force skinned another player | **Details: **'..src..' force skinned '..name..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.ForceskinWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

ClearloadoutWebhook = function(playerId)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Loadout Cleared",
        ["description"] = '**[Admin Menu]:** A staff member cleared another players loadout | **Details: **'..src..' cleared '..name..'\'s loadout | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.ClearloadoutWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

FreezeWebhook = function(playerId)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Frozen",
        ["description"] = '**[Admin Menu]:** A staff member froze another player | **Details: **'..src..' froze '..name..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.FreezeWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

SlapWebhook = function(playerId)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end

    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Slapped",
        ["description"] = '**[Admin Menu]:** A staff member slapped another player | **Details: **'..src..' slapped '..name..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/789273126394789888/789989240451629056/TDRPS_1.gif'
        }
    }

    PerformHttpRequest(ConfigSV.SlapWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('venomadmin:kickplayer')
AddEventHandler('venomadmin:kickplayer', function(player, reason)
    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.kick") and not IsPlayerAceAllowed(player, "venomadmin.immune") then
            KickWebhookMenu(player, "Kicked by: " ..GetPlayerName(source).. " for Reason: " ..reason)
            DropPlayer(player, "You have been kicked from "..ConfigSV.ServerName..". \nKicked by: " ..GetPlayerName(source).. " \nReason: " ..reason.. " \n\nFor more information, join our discord: "..ConfigSV.Discord)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

local banned = false

RegisterServerEvent('venomadmin:banplayer')
AddEventHandler('venomadmin:banplayer', function(player, reason, duration)

    if duration == 3600 then
        penis = "1 Hour"
    elseif duration == 10800 then
        penis = "3 Hours"
    elseif duration == 21600 then
        penis = "6 Hours"
    elseif duration == 43200 then
        penis = "12 Hours"
    elseif duration == 86400 then
        penis = "1 Day"
    elseif duration == 172800 then
        penis = "2 Days"
    elseif duration == 259200 then
        penis = "3 Days"
    elseif duration == 518400 then
        penis = "1 Week"
    elseif duration == 1123200 then
        penis = "2 Weeks"
    elseif duration == 2678400 then
        penis = "1 Month"
    elseif duration == 10444633200 then
        penis = "Permanent"
    end

    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.ban") and not IsPlayerAceAllowed(player, "venomadmin.immune") then
            BanWebhookMenu(player, "Banned by: " ..GetPlayerName(source).. " for Reason: " ..reason, duration)
            TriggerEvent("venomadmin:filterban", "You have been banned from "..ConfigSV.ServerName..". \nBanned by: " ..GetPlayerName(source).. " \nReason: " ..reason.. "\nBan Length: " ..penis.. " \n\nFor more information, join our discord: "..ConfigSV.Discord, player, duration)
            banned = true
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

MoneyWebhook = function(playerId, money)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end


    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Set Money",
        ["description"] = '**[Admin Menu]:** A staff member set another player\'s money | **Details: **'..src..' set '..name..'\'s money to $'..money..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.png'
        }
    }

    PerformHttpRequest(ConfigSV.MoneyWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = " ", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

BankWebhook = function(playerId, bank)

    playerId = tonumber(playerId)
    local name = GetPlayerName(playerId)
    local src = GetPlayerName(source)
    local steamid  = ""
    local discord  = "Not Linked"

    for k,v in pairs(GetPlayerIdentifiers(playerId)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@"..discordid..">"
        end
    end


    local discordInfo = {
        ["color"] = "65793",
        ["type"] = "rich",
        ["title"] = "Player Set Bank",
        ["description"] = '**[Admin Menu]:** A staff member set another player\'s bank | **Details: **'..src..' set '..name..'\'s bank to $'..bank..' | **Identifiers:** Steam Hex: '..steamid..', Discord: '..discord..', In-Game ID: '..playerId..' \n',
        ["footer"] = {
            ["text"] = (os.date("%B %d, %Y at %I:%M %p"))
        },
        ["author"] = {
            ["name"] = 'MadLife RP',
            ["url"] = '',
            ["icon_url"] = 'https://cdn.discordapp.com/attachments/816847703987716096/817023820237242398/loglo.pngf'
        }
    }

    PerformHttpRequest(ConfigSV.MoneyWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Admin System', avatar_url = "", embeds = { discordInfo } }), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent("venomadmin:TookScreenshot")
	
RegisterServerEvent("venomadmin:TakeScreenshot")
AddEventHandler('venomadmin:TakeScreenshot', function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.screenshot") then
	        if scrinprogress then
		        TriggerClientEvent("chat:addMessage", source, { args = { "Admin Menu", 'Screenshot in progress' } })
		        return
	        end
	        scrinprogress = true
	        local src=source
            local playerId = playerId
    
            thistemporaryevent = AddEventHandler("venomadmin:TookScreenshot", function(result)
                res = tostring(result)
                scrinprogress = false
                RemoveEventHandler(thistemporaryevent)
            end)
    
            TriggerClientEvent("venomadmin:CaptureScreenshot", playerId, ConfigSV.ScreenshotsWebhook)
            ScreenshotWebhook(playerId)
            local timeoutwait = 0
            repeat
                timeoutwait=timeoutwait+1
                Wait(5000)
                if timeoutwait == 5 then
                    RemoveEventHandler(thistemporaryevent)
                    scrinprogress = false
                    TriggerClientEvent("chat:addMessage", src, { args = { "Admin Menu", "Screenshot Failed!" } })
                end
            until not scrinprogress
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

RegisterServerEvent("venomadmin:openmenucheck")
AddEventHandler("venomadmin:openmenucheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.openmenu") then
        TriggerClientEvent("venomadmin:openmenu", source, true)
    else
        TriggerClientEvent("venomadmin:openmenu", source, false)
    end
end)

RegisterServerEvent("venomadmin:banplayercheck")
AddEventHandler("venomadmin:banplayercheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.ban") then
        TriggerClientEvent("venomadmin:bandahomie", source, true)
    else
        TriggerClientEvent("venomadmin:bandahomie", source, false)
    end
end)

RegisterServerEvent("venomadmin:reviveplayercheck")
AddEventHandler("venomadmin:reviveplayercheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.revive") then
        TriggerClientEvent("venomadmin:revivedahomie", source, true)
    else
        TriggerClientEvent("venomadmin:revivedahomie", source, false)
    end
end)

RegisterServerEvent("venomadmin:manageplayercheck")
AddEventHandler("venomadmin:manageplayercheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.manage") then
        TriggerClientEvent("venomadmin:managedahomie", source, true)
    else
        TriggerClientEvent("venomadmin:managedahomie", source, false)
    end
end)

RegisterServerEvent("venomadmin:freezeplayercheck")
AddEventHandler("venomadmin:freezeplayercheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.freeze") then
        TriggerClientEvent("venomadmin:freezedahomie", source, true)
    else
        TriggerClientEvent("venomadmin:freezedahomie", source, false)
    end
end)

RegisterServerEvent("venomadmin:gotobringplayercheck")
AddEventHandler("venomadmin:gotobringplayercheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.revive") then
        TriggerClientEvent("venomadmin:gotobringdahomie", source, true)
    else
        TriggerClientEvent("venomadmin:gotobringdahomie", source, false)
    end
end)

RegisterServerEvent("venomadmin:spawnvehiclecheck")
AddEventHandler("venomadmin:spawnvehiclecheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.spawnvehicle") then
        TriggerClientEvent("venomadmin:spawnvehicle", source, true)
    else
        TriggerClientEvent("venomadmin:spawnvehicle", source, false)
    end
end)

RegisterServerEvent("venomadmin:gotobringcheck")
AddEventHandler("venomadmin:gotobringcheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.bring") then
        TriggerClientEvent("venomadmin:gotobring", source, true)
    else
        TriggerClientEvent("venomadmin:gotobring", source, false)
    end
end)

RegisterServerEvent("venomadmin:noclipcheck")
AddEventHandler("venomadmin:noclipcheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.noclip") then
        TriggerClientEvent("venomadmin:noclip", source, true)
    else
        TriggerClientEvent("venomadmin:noclip", source, false)
    end
end)

RegisterServerEvent("venomadmin:godmodecheck")
AddEventHandler("venomadmin:godmodecheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.godmode") then
        TriggerClientEvent("venomadmin:godmode", source, true)
    else
        TriggerClientEvent("venomadmin:godmode", source, false)
    end
end)

RegisterServerEvent("venomadmin:invisibilitycheck")
AddEventHandler("venomadmin:invisibilitycheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.invisibility") then
        TriggerClientEvent("venomadmin:invisibility", source, true)
    else
        TriggerClientEvent("venomadmin:invisibility", source, false)
    end
end)

RegisterServerEvent("venomadmin:unbancheck")
AddEventHandler("venomadmin:unbancheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.unban") then
        TriggerClientEvent("venomadmin:unbanplayer", source, true)
    else
        TriggerClientEvent("venomadmin:unbanplayer", source, false)
    end
end)

RegisterServerEvent("venomadmin:custompedcheck")
AddEventHandler("venomadmin:custompedcheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.customped") then
        TriggerClientEvent("venomadmin:customped", source, true)
    else
        TriggerClientEvent("venomadmin:customped", source, false)
    end
end)

RegisterServerEvent("venomadmin:pedwipecheck")
AddEventHandler("venomadmin:pedwipecheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.pedwipe") then
        TriggerClientEvent("venomadmin:pedwipe", source, true)
    else
        TriggerClientEvent("venomadmin:pedwipe", source, false)
    end
end)

RegisterServerEvent("venomadmin:objectwipecheck")
AddEventHandler("venomadmin:objectwipecheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.objectwipe") then
        TriggerClientEvent("venomadmin:objectwipe", source, true)
    else
        TriggerClientEvent("venomadmin:objectwipe", source, false)
    end
end)

RegisterServerEvent("venomadmin:masswipecheck")
AddEventHandler("venomadmin:masswipecheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.masswipe") then
        TriggerClientEvent("venomadmin:masswipe", source, true)
    else
        TriggerClientEvent("venomadmin:masswipe", source, false)
    end
end)

RegisterServerEvent("venomadmin:carwipecheck")
AddEventHandler("venomadmin:carwipecheck", function()
    if IsPlayerAceAllowed(source, "venomadmin.carwipe") then
        TriggerClientEvent("venomadmin:carwipe", source, true)
    else
        TriggerClientEvent("venomadmin:carwipe", source, false)
    end
end)

TriggerEvent('es:addCommand', 'report', function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, {
		args = {"^1Incoming Report", " from ^3" .. GetPlayerName(source) .." (ID - "..source..") ^0Message: " .. table.concat(args, " ")}
	})

	TriggerEvent("es:getPlayers", function(pl)
		for k,v in pairs(pl) do
			TriggerEvent("es:getPlayerFromId", k, function(user)
				if(user.getPermissions() > 0 and k ~= source)then
					TriggerClientEvent('chat:addMessage', k, {
						args = {"^1Incoming Report", " from ^3" .. GetPlayerName(source) .." (ID - "..source..") ^0Message: " .. table.concat(args, " ")}
					})
				end
			end)
		end
	end)
end, {help = "Report a player or an issue", params = {{name = "report", help = "What you want to report"}}})

RegisterServerEvent('venomadmin:setmoney')
AddEventHandler('venomadmin:setmoney', function(player, money)
    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.setmoney") then
            if (player) then
                if money then
                    TriggerEvent("es:getPlayerFromId", player, function(user)
                        if(user)then
                            user.setMoney(money)
                            MoneyWebhook(player, money)
                            TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = GetPlayerName(tonumber(player)) .. " 's cash has been set to " .. money, length = 5000})
                        end
                    end)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Incorrect Amount.', length = 5000})
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

RegisterServerEvent('venomadmin:setbank')
AddEventHandler('venomadmin:setbank', function(player, bank)
    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.setbank") then
            if (player) then
                if bank then
                    TriggerEvent("es:getPlayerFromId", player, function(user)
                        if(user)then
                            user.setBankBalance(bank)
                            BankWebhook(player, bank)
                            TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = GetPlayerName(tonumber(player)) .. " 's bank has been set to " .. bank, length = 5000})
                        end
                    end)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Incorrect Amount.', length = 5000})
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

RegisterServerEvent('venomadmin:setgroup')
AddEventHandler('venomadmin:setgroup', function(player, group)
    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.setgroup") then
            if (player) then
                TriggerEvent("es:getAllGroups", function(groups)
    
                    if(group)then
                        TriggerEvent("es:getPlayerFromId", player, function(user)
                            ExecuteCommand('remove_principal identifier.' .. user.getIdentifier() .. " group." .. user.getGroup())
    
                            TriggerEvent("es:setPlayerData", player, "group", group, function(response, success)
                                TriggerClientEvent('es:setPlayerDecorator', player, 'group', tonumber(group), true)
                                TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = GetPlayerName(player) .. " has been set as " .. group, length = 5000})
    
                                ExecuteCommand('add_principal identifier.' .. user.getIdentifier() .. " group." .. user.getGroup())
                            end)
                        end)
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Incorrect Group.', length = 5000})
                    end
                end)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

RegisterServerEvent('venomadmin:setpermissionlevel')
AddEventHandler('venomadmin:setpermissionlevel', function(player, level)
    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.setpermlevel") then
            if (player) then
                if level then
                    TriggerEvent("es:setPlayerData", tonumber(player), "permission_level", tonumber(level), function(response, success)
            
                        TriggerClientEvent('es:setPlayerDecorator', tonumber(player), 'rank', tonumber(level), true)
                        TriggerClientEvent('mythic_notify:client:SendAlert', player, { type = 'error', text = GetPlayerName(tonumber(player)) .. " has been set to " .. level, length = 5000})
                    end)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Incorrect Level.', length = 5000})
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

TriggerEvent('es:addCommand', 'admin', function(source, args, user)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "Level: " .. tostring(user.get('permission_level')), length = 5000})
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "Group: " .. user.getGroup(), length = 5000})
end, {help = "Shows what admin level you are and what group you're in"})

TriggerEvent('es:addGroupCommand', 'announce', "admin", function(source, args, user)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255, 0, 0, 1); border-radius: 3px;"><i class="fas fa-cog"></i> SYSTEM:<br> {1}<br></div>',
        args = { "ANNOUNCEMENT", table.concat(args, " ") }
    })
end, function(source, args, user)
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
end, {help = "Announce a message to the entire server", params = {{name = "announcement", help = "The message to announce"}}})

RegisterServerEvent("venomadmin:revive")
AddEventHandler('venomadmin:revive', function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.revive") then
            ReviveWebhook(playerId)
            TriggerClientEvent("asd_ambulancejob:7774831", playerId)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

RegisterServerEvent("venomadmin:forceskin")
AddEventHandler('venomadmin:forceskin', function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.forceskin") then
            ForceskinWebhook(playerId)
            TriggerClientEvent("asd_skin:openSaveableMenu", playerId)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

RegisterServerEvent("venomadmin:slap")
AddEventHandler('venomadmin:slap', function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.slap") then
            SlapWebhook(playerId)
            TriggerClientEvent('venomadmin:slap', playerId)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

RegisterServerEvent("venomadmin:clearloadout")
AddEventHandler('venomadmin:clearloadout', function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.clearloadout") then
            ClearloadoutWebhook(playerId)
            TriggerClientEvent('venomadmin:clearloadout', playerId)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)


RegisterServerEvent("venomadmin:freeze")
AddEventHandler('venomadmin:freeze', function(playerId, toggle)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.freeze") then
            FreezeWebhook(playerId)
            TriggerClientEvent("venomadmin:freeze", playerId, toggle)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
    end
end)

RegisterCommand("goto", function(source, args)
    if IsPlayerAceAllowed(source, "venomadmin.bring") then
        if args[1] then
            local ped = GetPlayerPed(tonumber(args[1]))
            local target = GetEntityCoords(ped)
            local myself = GetEntityCoords(GetPlayerPed(tonumber(source)))
            savedCoords[source] = myself
            TriggerClientEvent('venomadmin:gotobring', source, target.x, target.y, target.z)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Incorrect Player ID. Usage: /goto id', length = 5000})
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
    end
end, false)

RegisterServerEvent("venomadmin:gotobutton")
AddEventHandler("venomadmin:gotobutton", function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.bring") then
            if playerId then
                local ped = GetPlayerPed(tonumber(playerId))
                local target = GetEntityCoords(ped)
                local myself = GetEntityCoords(GetPlayerPed(tonumber(source)))
                savedCoords[source] = myself
                TriggerClientEvent('venomadmin:gotobring', source, target.x, target.y, target.z)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player not found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

RegisterCommand("goback", function(source, args)
    if IsPlayerAceAllowed(source, "venomadmin.bring") then
        local myselfCoords = savedCoords[source]
        TriggerClientEvent('venomadmin:gotobring', source, myselfCoords.x, myselfCoords.y, myselfCoords.z)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
    end
end, false)

RegisterCommand("bring", function(source, args)
	if source ~= 0 then
	  	if IsPlayerAceAllowed(source, "venomadmin.bring") then
	    	if args[1] then
                local targetId = tonumber(args[1])
                local xtarget = GetPlayerPed(targetId)
                if xtarget then
                    local ped = GetPlayerPed(tonumber(source))
	        		local targetCoords = GetEntityCoords(xtarget)
	        		local playerCoords = GetEntityCoords(ped)
                    savedCoords[targetId] = targetCoords
                    TriggerClientEvent("venomadmin:gotobring", targetId, playerCoords.x, playerCoords.y, playerCoords.z)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player not found.', length = 5000})
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player not found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
	  	end
	end
end, false)

RegisterServerEvent("venomadmin:bringbutton")
AddEventHandler("venomadmin:bringbutton", function(playerId)
    if playerId ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.bring") then
            if playerId then
                local targetId = tonumber(playerId)
                local target = GetPlayerPed(targetId)
                if target then
                    local ped = GetPlayerPed(tonumber(source))
                    local targetCoords = GetEntityCoords(target)
                    local playerCoords = GetEntityCoords(ped)
                    savedCoords[targetId] = targetCoords
                    TriggerClientEvent("venomadmin:gotobring", targetId, playerCoords.x, playerCoords.y, playerCoords.z)
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player not found.', length = 5000})
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player not found.', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

RegisterCommand("sendback", function(source, args)
	if source ~= 0 then
        if IsPlayerAceAllowed(source, "venomadmin.bring") then
            if args[1] then
      			local targetId = tonumber(args[1])
      			local xtarget = GetPlayerPed(targetId)
      			if xtarget then
        			local playerCoords = savedCoords[targetId]
        			if playerCoords then
                        TriggerClientEvent("venomadmin:gotobring", targetId, playerCoords.x, playerCoords.y, playerCoords.z)
                        savedCoords[targetId] = nil
                    else
                        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'No previous location found.', length = 5000})
                    end
                else
                    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Player Not Found.', length = 5000})
                end
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Incorrect Usage. /sendback [id]', length = 5000})
            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
	end
end, false)

RegisterCommand("carwipe", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "venomadmin.carwipe") then
        TriggerClientEvent("venomadmin:utilone", -1)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
    end
end, false)

RegisterCommand("entitywipe", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "venomadmin.masswipe") then
        TriggerClientEvent("venomadmin:utilthree", -1)
        TriggerClientEvent("venomadmin:utiltwo", -1)
        TriggerClientEvent("venomadmin:utilone", -1)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
    end
end, false)

CachedPlayers = {}

AddEventHandler('playerDropped', function(reason)
    if savedCoords[playerId] then
    	savedCoords[playerId] = nil
    end

    local steamid  = ""
    local license  = ""
    local discord  = ""
    local xbl      = ""
    local liveid   = ""
    local ip       = ""

    local src = source

    for k,v in pairs(GetPlayerIdentifiers(src))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        end 
    end

    local discplayer = {
        id = src, 
        license = license, 
        steam = steamid, 
        live = liveid, 
        xbl = xbl, 
        discord = discord, 
        ip = ip, 
        name = GetPlayerName(src), 
        timegone = 180000
    }
    table.insert(CachedPlayers, discplayer)
end)

local BanList            = {}
local BanListLoad        = false
local joined = false

RegisterServerEvent('venomadmin:offlinebanplayer')
AddEventHandler('venomadmin:offlinebanplayer', function(player, license, steam, live, xbl, discord, ip, name, duration, reason)
    local durtext = ""
    local disc = ""
    if discord ~= "" then
        disc = "<@"..discord..">"
    else
        disc = "Not Linked"
    end

    if duration == 3600 then
        durtext = "1 Hour"
    elseif duration == 10800 then
        durtext = "3 Hours"
    elseif duration == 21600 then
        durtext = "6 Hours"
    elseif duration == 43200 then
        durtext = "12 Hours"
    elseif duration == 86400 then
        durtext = "1 Day"
    elseif duration == 172800 then
        durtext = "2 Days"
    elseif duration == 259200 then
        durtext = "3 Days"
    elseif duration == 518400 then
        durtext = "1 Week"
    elseif duration == 1123200 then
        durtext = "2 Weeks"
    elseif duration == 2678400 then
        durtext = "1 Month"
    elseif duration == 10444633200 then
        durtext = "Permanent"
    end

    if player ~= nil then
        if IsPlayerAceAllowed(source, "venomadmin.ban") and not IsPlayerAceAllowed(player, "venomadmin.immune") then
            menuban(player, license, steam, live, xbl, discord, ip, name, duration, "You have been banned from "..ConfigSV.ServerName..". \nBanned by: " ..GetPlayerName(source).. " \nReason: " ..reason.. "\nBan Length: " ..durtext.. " \n\nFor more information, join our discord: "..ConfigSV.Discord, 0)
            OfflineBanMenu(player, "Banned by: " ..GetPlayerName(source).. " for Reason: " ..reason, durtext, name, steam, disc)
            banned = true
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
        end
    end
end)

RegisterServerEvent("venomadmin:requestCachedPlayers")
AddEventHandler('venomadmin:requestCachedPlayers', function()
	local src = source
	if IsPlayerAceAllowed(source,"venomadmin.ban") then
	    TriggerClientEvent("venomadmin:fillCachedPlayers", src, CachedPlayers)
    end
end)

CreateThread(function()
	while true do
		Wait(1000)
		if BanListLoad == false then
			loadBanListMenu()
			if BanList ~= {} then
				print("Ban List Successfully Loaded.")
				BanListLoad = true
			else
				print("ERROR: Ban List did not load.")
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(600000)
		if BanListLoad == true then
			loadBanListMenu()
		end
	end
end)

RegisterServerEvent('venomadmin:filterban')
AddEventHandler('venomadmin:filterban', function(reason,servertarget,duration)
	local license,identifier,liveid,xblid,discord,playerip,target
	local duree     = duration
	local reason    = reason

	if tostring(source) == "" then
		target = tonumber(servertarget)
	else
		target = source
	end

	if target and target > 0 then
		local ping = GetPlayerPing(target)

		if ping and ping > 0 then
			if duree and duree then
				local playername = GetPlayerName(target)

				for k,v in ipairs(GetPlayerIdentifiers(target))do
					if string.sub(v, 1, string.len("license:")) == "license:" then
						license = v
					elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
						identifier = v
					elseif string.sub(v, 1, string.len("live:")) == "live:" then
						liveid = v
					elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
						xblid  = v
					elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
						discord = v
					elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
						playerip = v
					end
				end

				if duree then
					menuban(target,license,identifier,liveid,xblid,discord,playerip,playername,duree,reason,0)
					DropPlayer(target, reason, duration)
				end
			else
				print("Error: Invalid Time")
			end
		else
			print("Error: Player not online.")
		end
	else
		print("Error: Invalid ID.")
	end
end)

AddEventHandler('playerConnecting', function(playerName,setKickReason)
	local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

	if (Banlist == {}) then
		Citizen.Wait(1000)
    end
    
    for _, dudes in pairs(CachedPlayers) do 
        if steamID == dudes.steam then
            table.remove(CachedPlayers, _)
            joined = true
        elseif license == dudes.license then
            table.remove(CachedPlayers, _)
            joined = true
        elseif xblid == dudes.xbl then
            table.remove(CachedPlayers, _)
            joined = true
        elseif playerip == dudes.ip then
            table.remove(CachedPlayers, _)
            joined = true
        elseif discord == dudes.discord then
            table.remove(CachedPlayers, _)
            joined = true
        elseif liveid == dudes.live then
            table.remove(CachedPlayers, _)
            joined = true
        end
    end

	for i = 1, #BanList, 1 do
		if 
			  ((tostring(BanList[i].license)) == tostring(license) 
			or (tostring(BanList[i].identifier)) == tostring(steamID) 
			or (tostring(BanList[i].liveid)) == tostring(liveid) 
			or (tostring(BanList[i].xblid)) == tostring(xblid) 
			or (tostring(BanList[i].discord)) == tostring(discord) 
			or (tostring(BanList[i].playerip)) == tostring(playerip)) 
		then

			if (tonumber(BanList[i].permanent)) == 1 then

				setKickReason("" .. BanList[i].reason .. " \nTime Remaining: " .. txtday .. " days, " .. txthrs .. " hours, & " .. txtminutes .. " minute(s).")
				CancelEvent()
				break

			elseif (tonumber(BanList[i].expires)) > os.time() then

				local tempsrestant     = (((tonumber(BanList[i].expires)) - os.time())/60)
				if tempsrestant >= 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = (day - math.floor(day)) * 24
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("" .. BanList[i].reason .. " \nTime Remaining: " .. txtday .. " days, " .. txthrs .. " hours, & " .. txtminutes .. " minute(s).")					
						CancelEvent()
						break
				elseif tempsrestant >= 60 and tempsrestant < 1440 then
					local day        = (tempsrestant / 60) / 24
					local hrs        = tempsrestant / 60
					local minutes    = (hrs - math.floor(hrs)) * 60
					local txtday     = math.floor(day)
					local txthrs     = math.floor(hrs)
					local txtminutes = math.ceil(minutes)
						setKickReason("" .. BanList[i].reason .. " \nTime Remaining: " .. txtday .. " days, " .. txthrs .. " hours, & " .. txtminutes .. " minute(s).")
						CancelEvent()
						break
				elseif tempsrestant < 60 then
					local txtday     = 0
					local txthrs     = 0
					local txtminutes = math.ceil(tempsrestant)
						setKickReason("" .. BanList[i].reason .. " \nTime Remaining: " .. txtday .. " days, " .. txthrs .. " hours, & " .. txtminutes .. " minute(s).")
						CancelEvent()
						break
				end

			elseif (tonumber(BanList[i].expires)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

				deletebanned(license)
				break
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, dplys in pairs(CachedPlayers) do 
            local timer = dplys.timegone
            while timer ~= 0 do
                Citizen.Wait(100)
                timer = timer - 1
                if joined then
                    break
                end
                if banned then 
                    table.remove(CachedPlayers, _)
                    banned = false
                    break
                end
            end
            if timer == 0 then
                table.remove(CachedPlayers, _)
            end
        end
    end
end)

function menuban(player,license,identifier,liveid,xblid,discord,playerip,playername,duree,reason,permanent)
	local expires = duree
	local dateandtime = os.time()

	if expires < os.time() then
		expires = os.time()+expires
	end

	table.insert(BanList, {
		license    = license,
		identifier = identifier,
		liveid     = liveid,
		xblid      = xblid,
        discord    = discord,
        playername = playername,
		playerip   = playerip,
		reason     = reason,
		expires = expires,
		permanent  = permanent
	})

	MySQL.Async.execute('INSERT INTO admin_bans (license,identifier,liveid,xblid,discord,playerip,playername,reason,expires,dateandtime,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@playername,@reason,@expires,@dateandtime,@permanent)', {
		['@license']          = license,
		['@identifier']       = identifier,
		['@liveid']           = liveid,
		['@xblid']            = xblid,
		['@discord']          = discord,
		['@playerip']         = playerip,
		['@playername'] = playername,
		['@reason']           = reason,
		['@expires']       = expires,
		['@dateandtime']           = dateandtime,
		['@permanent']        = permanent,
	}, function()
	end)

	BanListHistoryLoad = false
end

function loadBanListMenu()
	MySQL.Async.fetchAll('SELECT * FROM admin_bans', {}, function(data)
		BanList = {}

		for i=1, #data, 1 do
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expires = data[i].expires,
				permanent  = data[i].permanent
			})
		end
	end)
end

RegisterServerEvent('venomadmin:unban')
AddEventHandler('venomadmin:unban', function(targetU)
	if IsPlayerAceAllowed(source, "venomadmin.unban") then
		MySQL.Async.fetchAll('SELECT * FROM admin_bans WHERE identifier like @identifier', 
		{
			['@identifier'] = ("%"..targetU.."%")
		}, function(data)
			MySQL.Async.execute(
			'DELETE FROM admin_bans WHERE identifier = @identifier',
			{
				['@identifier']  = data[1].identifier
			},
				function()
				loadBanListMenu()
			end)
		end)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You do not have permission to do this.', length = 5000})
	end
end)

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM admin_bans WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
			loadBanListMenu()
	end)
end

