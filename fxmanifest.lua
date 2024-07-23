fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Edward Lewis"
description "A FiveM Lua ORM"
version "1.0.0"

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua",
    "example.lua"
}

shared_scripts {
    "shared.lua"
}

dependencies {
    "oxmysql"
}