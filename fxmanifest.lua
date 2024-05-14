fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Simplified Studios Jobcenter'
version '1.2.0'

ui_page 'html/index.html'

client_scripts {
    'client/cl_main.lua',
}

server_scripts {
    'shared/config.lua',
    'server/*.lua',
}

files {
    'html/img/*.png',
    'html/img/*.jpg',
    'html/index.html',
    'html/style.css',
    'html/script.js',
}
