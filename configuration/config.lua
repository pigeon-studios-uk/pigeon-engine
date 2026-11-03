Config = {}

-- Language file from locales/ to use, such as 'en'.
Config.Locale = 'en'

---------------------------------------------------------------------------
-- The engine key

-- The key the driver presses to start and stop the engine. Players can change it in GTA's Settings ->
-- Key Bindings -> FiveM. Codes: https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
-- The command (/engine) works too.
Config.Key = 'M'
Config.Command = 'engine'

-- Seconds the driver turns the key for before a healthy engine starts. Damaged engines take longer.
Config.StartSeconds = 1.0

---------------------------------------------------------------------------
-- Getting in and out

-- true: GTA starts the engine when someone gets in to drive, as normal.
-- false: an engine that's off stays off until the driver starts it with the key. One that's running
-- stays running.
Config.StartOnEnter = false

-- Whether the engine keeps running when the driver gets out:
--   'always'  it keeps running, if it was
--   'hold'    it keeps running if they hold the exit key (F) for Config.HoldMs; a tap turns it off
--   'never'   it's turned off when they get out
Config.KeepRunning = 'always'
Config.HoldMs = 500

-- Keep the front wheels turned the way they were when the driver got out, instead of straightening.
Config.KeepWheelsTurned = true

---------------------------------------------------------------------------
-- Damage

-- GTA's engine health runs from 1000 (perfect) down. Below `unreliableBelow` the engine sometimes turns
-- over without starting, more often the worse it gets, up to `worstFailChance` (0.6 = 60% of tries).
-- Below `deadBelow` it won't start at all.
Config.Damage = {
    enabled = true,
    unreliableBelow = 400,
    worstFailChance = 0.6,
    deadBelow = 100,
}

---------------------------------------------------------------------------
-- Who can start what

-- Called in the driver's game before the engine starts, with the vehicle. Return false (and a message,
-- if you like) to stop it. Use it to ask your vehicle keys resource whether they have the keys:
--     Config.CanStart = function(vehicle)
--         local plate = GetVehicleNumberPlateText(vehicle)
--         if not exports['your-keys-resource']:HasKey(plate) then return false, 'You don\'t have the keys.' end
--         return true
--     end
-- Check your keys resource's own documentation for its export's name.
Config.CanStart = function(vehicle)
    return true
end

-- Vehicle classes left to GTA: 13 cycles (no engine) and 21 trains.
Config.SkipClasses = { 13, 21 }

---------------------------------------------------------------------------
-- Messages

-- Short messages: engine on, off, won't start.
Config.ShowMessages = true

-- How messages are shown.
-- 'auto' uses ox_lib notifications if ox_lib is running, otherwise GTA's notification feed.
-- 'ox_lib' or 'gta' to force one.
Config.Notifications = 'auto'

-- Update checks are controlled in server.cfg for every Pigeon Studios resource at once:
--     set pigeon_update_check "on"      (default)  |  "quiet"  |  "off"
