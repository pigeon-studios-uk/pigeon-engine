fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pigeon-engine'
author 'Pigeon Studios'
description 'Start and stop engines with a key, keep them running when you get out, and leave the wheels turned.'
version '1.0.0'
repository 'https://github.com/pigeon-studios-uk/pigeon-engine'

-- Pigeon Studios version registry entry, read by server/version_check.lua.
pigeon_slug 'pigeon-engine'

-- The config runs only in players' games: Config.CanStart is a function that runs there.
client_scripts {
    'configuration/config.lua',
    'locales/*.lua',
    'shared/rules.lua',
    'client/main.lua',
}

server_scripts {
    'server/version_check.lua',
}
