--[[
    Pigeon Engine: Traditional Chinese (繁體中文).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'zh-tw'
    to use it, or leave it on 'auto' and set ox_lib's language.
]]

Locales = Locales or {}

Locales['zh-tw'] = {
    title = '引擎',

    -- GTA's Settings -> Key Bindings -> FiveM.
    key_description = '啟動 / 關閉引擎',

    on = '引擎已啟動。',
    off = '引擎已關閉。',
    fail = '引擎在轉，但沒有發動。再試一次。',
    dead = '引擎損壞太嚴重，無法啟動。',
    not_allowed = '你無法啟動這輛車。',
}
