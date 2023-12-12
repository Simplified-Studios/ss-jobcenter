fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Simplified Studios Jobcenter'
version '1.2.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/cl_main.lua',
}

server_scripts {
    'config.lua',
    'server/sv_main.lua',
}

files {
    'html/img/*.png',
    'html/img/*.jpg',
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

dependencies {
    'ox_lib'
}