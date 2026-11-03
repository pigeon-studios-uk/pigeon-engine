--[[
    Pigeon Engine: the rules.

    Whether an engine starts, and whether it keeps running when the driver gets out. Nothing here calls a
    native, so it can be tested outside the game: client/main.lua gathers the facts and asks.
]]

Engine = {}

--[[
    What happens when the driver turns the key, from the engine's health (GTA's 0 to 1000) and a random
    number from 0 to 1:
        'start'  it starts
        'fail'   it turns over but doesn't catch; they can try again
        'dead'   it's too badly damaged to start at all
]]
function Engine.startResult(config, health, roll)
    local damage = config.Damage or {}
    if damage.enabled == false then return 'start' end
    if health < (tonumber(damage.deadBelow) or 100) then return 'dead' end

    local unreliable = tonumber(damage.unreliableBelow) or 400
    if health >= unreliable then return 'start' end
    -- Below `unreliableBelow`, the chance of failing rises to `worstFailChance` just above `deadBelow`.
    local dead = tonumber(damage.deadBelow) or 100
    local worst = tonumber(damage.worstFailChance) or 0.6
    local share = (unreliable - health) / math.max(1, unreliable - dead)
    return roll < worst * share and 'fail' or 'start'
end

--- How long the driver turns the key for, in milliseconds: longer the more damaged the engine.
function Engine.crankTime(config, health)
    local base = (tonumber(config.StartSeconds) or 1.0) * 1000
    local damage = config.Damage or {}
    if damage.enabled == false then return base end
    local unreliable = tonumber(damage.unreliableBelow) or 400
    if health >= unreliable then return base end
    return base * (1 + (unreliable - health) / unreliable)
end

--[[
    Whether the engine keeps running when the driver gets out, from Config.KeepRunning:
        'always'  if it was running
        'hold'    if it was running and they held the exit key for `holdMs` or longer
        'never'   it's turned off
]]
function Engine.keepRunning(config, wasRunning, heldMs)
    if not wasRunning then return false end
    local mode = config.KeepRunning or 'always'
    if mode == 'never' then return false end
    if mode == 'hold' then return heldMs >= (tonumber(config.HoldMs) or 500) end
    return true
end

--- True if the resource handles this vehicle class. Bicycles have no engine; trains are driven by GTA.
function Engine.handles(config, class)
    for _, skipped in ipairs(config.SkipClasses or {}) do
        if skipped == class then return false end
    end
    return true
end
