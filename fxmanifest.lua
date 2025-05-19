fx_version 'cerulean'
game 'gta5'

author 'KDV Dev'
description 'Vehicle Contracts'
version '1.0.0'

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

-- dependency 'ox_lib'

lua54 'yes'