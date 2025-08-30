--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
local enable = false

function EnableCheatMode()
    if not enable then enable = true end
end

function DisableCheatMode()
    if enable then enable = false end
end

CreateThread(function()
    while true do
        Wait(2000)
        if isCheater then
            ToggleHat(true)
        elseif not isCheater then
            ToggleHat(false)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(10000)
        if isLoggedIn and isCheater and lobbie ~= config.CheatLobbie then
            lobbie = config.CheatLobbie
            local label, population, lockdown = config.Lobbies[lobbie].label, config.Lobbies[lobbie].population, config.Lobbies[lobbie].lockdown
            TriggerServerEvent('mh-lobbies:server:setLobbieId', {id = config.CheatLobbie, label = label, population = population, lockdown = lockdown})
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if enable and isCheater then
            sleep = 0
            if GetResourceState(config.Target) ~= 'missing' then
                exports[config.Target]:DisableTarget(true)
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if enable and isCheater then
            sleep = 500
            local vehicle, _ = GetClosestVehicle(GetEntityCoords(PlayerPedId()))
            if vehicle ~= nil then
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteVehicle(vehicle)
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if enable and isCheater then
            sleep = 1
            SetPlayerCanDoDriveBy(PlayerPedId(), false)
            if IsPauseMenuActive() then SetFrontendActive(false) end
            DisableControlAction(2, 37, true)        -- Disable Weaponwheel
            DisablePlayerFiring(PlayerPedId(), true) -- Disable firing
            --
            DisableControlAction(0, 21, true)        -- Disable Sprint
            DisableControlAction(0, 22, true)        -- Disable Jump
            DisableControlAction(0, 23, true)        -- Disable Enter
            DisableControlAction(0, 24, true)        -- Disable attacking
            DisableControlAction(0, 25, true)        -- Disable Aim            
            DisableControlAction(0, 37, true)        -- Disable Tab
            DisableControlAction(0, 38, true)        -- Disable E press     
            DisableControlAction(0, 45, true)        -- Disable reloading                   
            DisableControlAction(0, 48, true)        -- Disable HUD_SPECIAL
            --
            DisableControlAction(0, 140, true)       -- Disable light melee attack (r)
            DisableControlAction(0, 141, true)       -- Disable melee            
            DisableControlAction(0, 142, true)       -- Disable left mouse button (pistol whack etc)
            DisableControlAction(0, 143, true)       -- Disable melee            
            DisableControlAction(0, 257, true)       -- Disable melee
            DisableControlAction(0, 257, true)       -- Disable Attack 2  
            DisableControlAction(0, 263, true)       -- Disable melee attack 1        
            DisableControlAction(0, 264, true)       -- Disable melee

        end
        Wait(sleep)
    end
end)