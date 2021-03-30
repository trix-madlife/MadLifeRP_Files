fx_version 'adamant'
game 'gta5'

client_script {
  'client/amcl.lua',
  'config/cfgcl.lua',
  'client/WarMenu.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server/amsv.lua',
  'config/cfgsv.lua'
}
