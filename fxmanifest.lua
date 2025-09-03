--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'MaDHouSe'
description 'MH Lobbies'
version '1.0.0'

ui_page 'core/html/index.html'

files {'core/html/*.html', 'core/html/*.js', 'core/html/*.css'}

shared_scripts {
    '@ox_lib/init.lua',
    'core/locale.lua',
    'locales/en.lua',
    'core/functions/shared.lua',
}

client_scripts {
    'core/framework/client.lua',
    'core/functions/client.lua',
    'client/main.lua',
    'client/lobbies/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'core/sv_config.lua',
    'server/configs/*.lua',
    'core/framework/server.lua',
    'core/functions/server.lua',
    'server/modules/lobbies.lua',
    'server/main.lua',
    'server/modules/update.lua',
}

dependencies {
    'oxmysql',
    'qb-core',
}


