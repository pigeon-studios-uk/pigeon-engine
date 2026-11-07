--[[
    Pigeon Engine: Simplified Chinese (简体中文).

    Translated from locales/en.lua, which has the notes on each line. If something reads
    wrong, please send a fix (see the README's Contributing section). Set Config.Locale = 'zh-cn'
    to use it, or leave it on 'auto' and set ox_lib's language.
]]

Locales = Locales or {}

Locales['zh-cn'] = {
    title = '引擎',

    -- GTA's Settings -> Key Bindings -> FiveM.
    key_description = '启动 / 关闭引擎',

    on = '引擎已启动。',
    off = '引擎已关闭。',
    fail = '引擎在转，但没有着火。再试一次。',
    dead = '引擎损坏太严重，无法启动。',
    not_allowed = '你无法启动这辆车。',
}
