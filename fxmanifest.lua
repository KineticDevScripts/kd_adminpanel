fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Kinetic Dev'
version '1.0.1'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'locale.lua',
	'locales/*.lua',
    'config/*.lua'
}

client_scripts {
    'utils/client.lua',
    'client/*.lua',
    'client/modules/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'utils/server.lua',
    'server/*.lua',
    'server/modules/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}