--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
local menuOpen = false

RegisterNetEvent('mh-lobbies:client:setLobbieId', function(data)
    lobbie = data.id
    GoToLocation(lobbie)
    menuOpen = false
end)

local target = false
RegisterNetEvent('mh-lobbies:client:refreshData', function(data)
    config = data.config
    if not target then
        target = true
        CreateMenuTarget()
    end
end)

RegisterNetEvent('mh-lobbies:client:checkPlayerStatus', function(data)
    if data.id == GetPlayerServerId(PlayerId()) then isCheater = data.status end
    if isCheater then ToggleHat(true) else ToggleHat(false) end
end)

RegisterNetEvent('mh-lobbies:client:adminMenu', function(data)
    if data.id == GetPlayerServerId(PlayerId()) then
        AdminMenu(data)
    end
end)

AddEventHandler(OnPlayerLoaded, function()
    TriggerServerEvent('mh-lobbies:server:onjoin')
    target = false
    menuOpen = false
    zoneSet = false
    isLoggedIn = true
    isCheater = false
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        DoScreenFadeIn(100)
        TriggerServerEvent('mh-lobbies:server:onjoin')
        lobbie = 0
        isLoggedIn = true
        isCheater = false        
        target = false
        menuOpen = false
        zoneSet = false
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CloseNUI()
        isLoggedIn = false
        isCheater = false        
        target = false
        menuOpen = false
        zoneSet = false
    end
end)

RegisterCommand('newlobbie', function()
    OpenNUI()
end, true)

RegisterCommand('openmenu', function()
    OpenLobbieMenu()
end, true)

RegisterCommand("cut", function(source, args)
    local ped = PlayerPedId()
    StartCutscene(0)
end)

RegisterNUICallback('newData', function(data, cb)
    CloseNUI()
    cb('ok')
    local exsist = IsLobbieAlreadyExist(data.lobbiename)
    if not exsist then
        TriggerServerEvent('mh-lobbies:server:newLobbie', data)
    else
        Notify(Lang:t('lobbie_already_exsist', {lobbie=data.lobbiename}), "info", 5000)
    end
end)

RegisterNUICallback('close', function(data, cb)
    CloseNUI()
    cb('ok')
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if isLoggedIn and not config.UseTarget then
            if type(config.TeleportModels) == 'table' and not IsDead() then
                local mycoords = GetEntityCoords(PlayerPedId())
                for _, prop in pairs(config.TeleportModels) do
                    local entity = GetClosestObjectOfType(mycoords.x, mycoords.y, mycoords.z, 3.0, prop, false, true, true)
                    if DoesEntityExist(entity) then
                        local entityCoords = GetEntityCoords(entity)
                        if #(mycoords - entityCoords) < 2.0 then
                            if not menuOpen then
                                sleep = 5
                                DrawText3Ds(entityCoords.x, entityCoords.y, entityCoords.z + 1.2, Lang:t('open_lobbie_menu'))
                                if IsControlPressed(0, 38) then
                                    menuOpen = true
                                    OpenMenu(entity)
                                end
                            end
                        else
                            menuOpen = false
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)