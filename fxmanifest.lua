fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Kinetic Dev'
version '2.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'bridge/framework.lua',
    'locale.lua',
	'locales/*.lua',
    'config/*.lua'
}

client_scripts {
    'bridge/**/client.lua',
    'utils/client.lua',
    'client/modules/*.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/**/server.lua',
    'utils/server.lua',
    'server/modules/*.lua',
    'server/*.lua'
}

files {
    'html/index.html',
    'html/logo.png',
    'html/style.css',
    'html/script.js'
}