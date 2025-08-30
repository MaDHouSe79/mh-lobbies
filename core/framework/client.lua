--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
Framework, TriggerCallback, OnPlayerLoaded, OnPlayerUnload, lobbie = nil, nil, nil, nil, nil
OnJobUpdate, OnGangUpdate, isLoggedIn, isCheater, PlayerData, config, blipData = nil, nil, false, false, {}, {}, {} 

if GetResourceState("es_extended") ~= 'missing' then
    Framework = exports['es_extended']:getSharedObject()
    TriggerCallback = Framework.TriggerServerCallback
    OnPlayerLoaded = 'esx:playerLoaded'
    OnPlayerUnload = 'esx:playerUnLoaded'
    OnJobUpdate = 'esx:setJob'
    OnGangUpdate = 'esx:setGang'
    function GetPlayerData() TriggerCallback('esx:getPlayerData', function(data) PlayerData = data end) return PlayerData end
    function IsDead() return (GetEntityHealth(PlayerPedId()) <= 0.0) end
    function SetJob(job) PlayerData.job = job end
    function GetJob() return PlayerData.job end

    function Notify(message, type, length)
        if GetResourceState("ox_lib") ~= 'missing' then
            lib.notify({ title = "MH Lobbies", description = message, type = type })
        else
            if type == nil then type = 'primary' end
            if length == nil then length = 5000 end
            Framework.ShowNotification("MH Lobbies\n"..message, type, length)
        end
    end

elseif GetResourceState("qb-core") ~= 'missing' then
    Framework = exports['qb-core']:GetCoreObject()
    TriggerCallback = Framework.Functions.TriggerCallback
    OnPlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
    OnPlayerUnload = 'QBCore:Client:OnPlayerUnload'
    OnJobUpdate = 'QBCore:Client:OnJobUpdate'
    OnGangUpdate = 'QBCore:Client:OnGangUpdate'
    function GetPlayerData() return Framework.Functions.GetPlayerData() end
    function IsDead() return Framework.Functions.GetPlayerData().metadata['isdead'] end
    function SetJob(job) PlayerData.job = job end
    function GetJob() return PlayerData.job end

    function Notify(message, type, length)
        if GetResourceState("ox_lib") ~= 'missing' then
            lib.notify({title = "MH Lobbies", description = message, type = type})
        else
            if type == nil then type = 'primary' end
            if length == nil then length = 5000 end
            Framework.Functions.Notify({ text = "MH Lobbies", caption = message }, type, length)
        end
    end

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(data) PlayerData = data end)

else
    OnPlayerLoaded = "playerSpawned"
    function IsDead() return (GetEntityHealth(PlayerPedId()) <= 0.0) end

    function Notify(message, type, length)
        if GetResourceState("ox_lib") ~= 'missing' then
            lib.notify({title = "MH Lobbies", description = message, type = type})
        end
    end
    
end

function GetClosestVehicle(coords)
    local closestDistance, closestVehicle, vehicles = -1, -1, GetGamePool('CVehicle')
    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
    end
    return closestVehicle, closestDistance
end

function DeleteAllVehicles()
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles, 1 do
        if DoesEntityExist(vehicles[i]) then
            SetEntityAsMissionEntity(vehicles[i], true , true)
            DeleteEntity(vehicles[i])
        end
    end
end

function DeleteAllPeds()
    local peds = GetGamePool('CPed')
    for i = 1, #peds, 1 do
        if DoesEntityExist(peds[i]) then
            SetEntityAsMissionEntity(peds[i], true , true)
            DeletePed(peds[i])
        end
    end
end

function SplitString(str, delimiter)
    local returnTable = {}
    for k, v in string.gmatch(str, "([^" .. delimiter .. "]+)")  do
        returnTable[#returnTable+1] = k
    end
    return returnTable
end

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(15) end
end

function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function Progressbar(name, label, duration, useWhileDead, canCancel, disableControls, animation, prop, propTwo, onFinish, onCancel)
    if GetResourceState('progressbar') ~= 'started' then error( 'progressbar needs to be installed and started in order to work.') end
    exports['progressbar']:Progress({
        name = name:lower(),
        duration = duration,
        label = label,
        useWhileDead = useWhileDead,
        canCancel = canCancel,
        controlDisables = disableControls,
        animation = animation,
        prop = prop,
        propTwo = propTwo,
    }, function(cancelled)
        if not cancelled then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end
    end)
end