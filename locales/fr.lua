--[[
    Pigeon Engine: French (Français).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'fr'
    to use it, or leave it on 'auto' and set ox_lib's language.
]]

Locales = Locales or {}

Locales.fr = {
    title = 'Moteur',

    -- GTA's Settings -> Key Bindings -> FiveM.
    key_description = 'Allumer / éteindre le moteur',

    on = 'Moteur allumé.',
    off = 'Moteur éteint.',
    fail = 'Le moteur tourne mais ne démarre pas. Réessayez.',
    dead = 'Le moteur est trop endommagé pour démarrer.',
    not_allowed = 'Vous ne pouvez pas démarrer ce véhicule.',
}
