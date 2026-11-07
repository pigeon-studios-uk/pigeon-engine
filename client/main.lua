--[[
    Pigeon Engine: client.

    The driver starts and stops the engine with a key. With Config.StartOnEnter off, an engine that's off
    stays off when someone gets in to drive. When the driver gets out, the engine keeps running (or not,
    as Config.KeepRunning says) and the front wheels stay turned.

    Engine state is the game's own, so every player sees and hears it.
]]

local RESOURCE = GetCurrentResourceName()
local EXIT_CONTROL = 75                    -- INPUT_VEH_EXIT (F)
local WHEEL_HOLD_MS = 1500                 -- how long the wheels are held turned after getting out
local IDLE_MS = 200

-- 'auto' follows ox_lib's language (the ox:locale convar), and English when that isn't set.
local locale = Config.Locale == 'auto' and GetConvar('ox:locale', 'en') or Config.Locale
local strings = Locales[locale] or Locales.en

local driving = 0                          -- the vehicle the player is driving, or 0
local entering, enteringWasRunning = 0, false
local wasRunning = false                   -- the engine, the last time the player was driving
local steering = 0.0
local exitPressedAt, exitHeldUntil = nil, nil
local wheels                               -- { vehicle, angle, untilTime } after getting out
local starting = false

local function notify(key)
    if not Config.ShowMessages then return end
    local text = strings[key] or Locales.en[key] or key
    local mode = Config.Notifications
    if mode == 'ox_lib' or (mode == 'auto' and GetResourceState('ox_lib') == 'started') then
        TriggerEvent('ox_lib:notify', { title = strings.title, description = text, type = 'inform' })
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

local function isDriver(ped, vehicle)
    return GetPedInVehicleSeat(vehicle, -1) == ped
end

local function handled(vehicle)
    return Engine.handles(Config, GetVehicleClass(vehicle))
end

---------------------------------------------------------------------------
-- Starting and stopping

local function stop(vehicle)
    SetVehicleEngineOn(vehicle, false, false, true)
    notify('off')
end

--- Turns the key. Returns straight away; the engine starts (or doesn't) after the crank time.
local function start(vehicle)
    if starting then return end
    local ok, allowed, message = pcall(Config.CanStart, vehicle)
    if ok and allowed == false then
        notify(type(message) == 'string' and message or 'not_allowed')   -- their own message, or ours
        return
    end

    local health = GetVehicleEngineHealth(vehicle)
    local result = Engine.startResult(Config, health, math.random())
    if result == 'dead' then
        notify('dead')
        return
    end

    starting = true
    CreateThread(function()
        Wait(math.floor(Engine.crankTime(Config, health)))
        local ped = PlayerPedId()
        if DoesEntityExist(vehicle) and GetVehiclePedIsIn(ped, false) == vehicle and isDriver(ped, vehicle) then
            if result == 'start' then
                SetVehicleEngineOn(vehicle, true, false, true)
                notify('on')
            else
                notify('fail')
            end
        end
        starting = false
    end)
end

local function toggle()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if not isDriver(ped, vehicle) or not handled(vehicle) then return end
    if GetIsVehicleEngineRunning(vehicle) then stop(vehicle) else start(vehicle) end
end

---------------------------------------------------------------------------
-- Getting in, driving and getting out

local function gotOut()
    local vehicle = driving
    driving = 0
    if not DoesEntityExist(vehicle) then return end

    local held = exitPressedAt and ((exitHeldUntil or exitPressedAt) - exitPressedAt) or 0
    local keep = Engine.keepRunning(Config, wasRunning, held)
    SetVehicleKeepEngineOnWhenAbandoned(vehicle, keep)
    SetVehicleEngineOn(vehicle, keep, true, true)

    if Config.KeepWheelsTurned and math.abs(steering) > 1.0 then
        wheels = { vehicle = vehicle, angle = steering, untilTime = GetGameTimer() + WHEEL_HOLD_MS }
    end
    exitPressedAt, exitHeldUntil = nil, nil
end

local function whileDriving(ped, vehicle)
    local now = GetGameTimer()

    if vehicle ~= driving then
        driving = vehicle
        -- Getting in to drive: GTA would start the engine. Keep it as it was.
        if not Config.StartOnEnter and entering == vehicle and not enteringWasRunning then
            SetVehicleEngineOn(vehicle, false, true, true)
        end
        entering = 0
        exitPressedAt, exitHeldUntil = nil, nil
    end

    if exitPressedAt then
        -- Getting out: the wheels are straightening and the engine may be switching off, so the state
        -- from before they pressed the key is what counts.
        if IsControlPressed(0, EXIT_CONTROL) then exitHeldUntil = now end
    else
        wasRunning = GetIsVehicleEngineRunning(vehicle)
        steering = GetVehicleSteeringAngle(vehicle)
        if IsControlJustPressed(0, EXIT_CONTROL) then
            exitPressedAt, exitHeldUntil = now, now
            -- Tell GTA now, so it doesn't switch the engine off as they climb out.
            if Engine.keepRunning(Config, wasRunning, math.huge) then SetVehicleKeepEngineOnWhenAbandoned(vehicle, true) end
        end
    end
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) or 0

        if vehicle ~= 0 and isDriver(ped, vehicle) and handled(vehicle) then
            whileDriving(ped, vehicle)
            Wait(0)
        else
            if driving ~= 0 then gotOut() end

            -- Remember whether the engine was running before they got in.
            local target = GetVehiclePedIsTryingToEnter(ped)
            if target ~= 0 and target ~= entering then
                entering, enteringWasRunning = target, GetIsVehicleEngineRunning(target)
            elseif target == 0 and vehicle == 0 then
                entering = 0
            end

            if wheels then
                if GetGameTimer() > wheels.untilTime or not DoesEntityExist(wheels.vehicle) then
                    wheels = nil
                elseif NetworkHasControlOfEntity(wheels.vehicle) then
                    SetVehicleSteeringAngle(wheels.vehicle, wheels.angle)
                end
            end

            Wait((wheels or target ~= 0) and 0 or IDLE_MS)
        end
    end
end)

---------------------------------------------------------------------------
-- Key, command and exports

RegisterCommand(Config.Command, toggle, false)
RegisterKeyMapping(Config.Command, strings.key_description, 'keyboard', Config.Key)

--- Starts or stops the engine of the vehicle the player is driving, as the key does.
exports('ToggleEngine', toggle)

--- True if the vehicle the player is in has its engine running.
exports('IsEngineRunning', function()
    local ped = PlayerPedId()
    return IsPedInAnyVehicle(ped, false) and GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, false)) or false
end)

--- Starts (true) or stops (false) the engine of the vehicle the player is driving straight away, skipping
--- Config.CanStart and damage: for example after a keys resource's hotwiring succeeds.
exports('SetEngine', function(on)
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end
    local vehicle = GetVehiclePedIsIn(ped, false)
    if isDriver(ped, vehicle) then SetVehicleEngineOn(vehicle, on == true, false, true) end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == RESOURCE then wheels = nil end
end)
