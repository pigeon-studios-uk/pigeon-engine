--[[
    Pigeon Engine: Finnish (Suomi).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'fi'
    to use it, or leave it on 'auto' and set ox_lib's language.
]]

Locales = Locales or {}

Locales.fi = {
    title = 'Moottori',

    -- GTA's Settings -> Key Bindings -> FiveM.
    key_description = 'Moottori päälle / pois',

    on = 'Moottori käynnissä.',
    off = 'Moottori sammutettu.',
    fail = 'Moottori pyörii, mutta ei käynnisty. Yritä uudelleen.',
    dead = 'Moottori on liian pahasti vaurioitunut käynnistyäkseen.',
    not_allowed = 'Et voi käynnistää tätä ajoneuvoa.',
}
