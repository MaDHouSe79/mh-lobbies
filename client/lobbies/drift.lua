local enable = false
local driftMode = false

local isDriver = false
local isInVehicle = false
local isEnteringVehicle = false
local urrentVehicle = 0
local currentSeat = 0
local currentVehicle = 0

local handleMods = {
    {"fInitialDragCoeff", 90.22},
    {"fDriveInertia", .31},
    {"fSteeringLock", 22},
    {"fTractionCurveMax", -1.1},
    {"fTractionCurveMin", -.4},
    {"fTractionCurveLateral", 2.5},
    {"fLowSpeedTractionLossMult", -.57}
}

local performanceModIndices = { 11, 12, 13, 15, 16 }
local function PerformanceUpgradeVehicle(vehicle, customWheels)
    customWheels = customWheels or false
    local max
    if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
        SetVehicleModKit(vehicle, 0)
        for _, modType in ipairs(performanceModIndices) do
            max = GetNumVehicleMods(vehicle, tonumber(modType)) - 1
            SetVehicleMod(vehicle, modType, max, customWheels)
        end
        ToggleVehicleMod(vehicle, 18, true) -- Turbo
        SetVehicleFixed(vehicle)
    end
end

local function ToggleDrifting(vehicle)
    local modifier = 1
    if GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff") > 90 then driftMode = true else driftMode = false end
    if driftMode then modifier = -1 end

    for _, value in ipairs(handleMods) do
        SetVehicleHandlingFloat(vehicle, "CHandlingData", value[1], GetVehicleHandlingFloat(vehicle, "CHandlingData", value[1]) + value[2] * modifier)
    end
    
    if driftMode then PerformanceUpgradeVehicle(vehicle) end
    
    if GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff") < 90 then

        SetVehicleEnginePowerMultiplier(vehicle, 0.0)

    elseif GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff") > 90 then

        if GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront") == 0 then
            SetVehicleEnginePowerMultiplier(vehicle, 190.0)
        else
            SetVehicleEnginePowerMultiplier(vehicle, 100.0)
        end

    end

    
end

local spawnVehicleList = {
    "adder",
}

local function SpawnVeh()
    local model = spawnVehicleList[math.random(1, #spawnVehicleList)]
    LoadModel(model)
    local coords = vector3(-1003.4766, -2760.7207, 13.7569)
    local heading = 328.0185
	ClearAreaOfVehicles(coords.x, coords.y, coords.z, 10000, false, false, false, false, false)
    local entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
	while not DoesEntityExist(entity) do Wait(1) end
	SetEntityAsMissionEntity(entity, true, true)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	SetVehicleOnGroundProperly(entity)
    SetVehicleBodyHealth(entity, 1000.0)
    SetVehicleEngineHealth(entity, 1000.0)
    SetVehicleFuelLevel(entity, 100.0)
	SetVehRadioStation(entity, 'OFF')
	SetVehicleDirtLevel(entity, 0)
    SetModelAsNoLongerNeeded(model)
    local plate = GetPlate(entity)
    TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
end

local menuped = nil 

local function DeleteMenuPed()
    if DoesEntityExist(menuped) then
        DeleteEntity(menuped)
        menuped = nil
    end
end

local function CreateMenuPed()
    local coords = vector4(-1006.7597, -2767.5688, 14.3980, 332.8917)
    local model = "g_m_y_lost_01"
    local current = GetHashKey(model)
    LoadModel(current)
    menuped = CreatePed(0, current, coords.x, coords.y, coords.z - 1, coords.w, true, false)
    while not DoesEntityExist(menuped) do Wait(1) end
    TaskStartScenarioInPlace(menuped, "WORLD_HUMAN_STAND_MOBILE", true)
    FreezeEntityPosition(menuped, true)
    SetEntityInvincible(menuped, true)
    SetPedKeepTask(menuped, true)
    SetBlockingOfNonTemporaryEvents(menuped, true)
    exports['qb-target']:AddTargetModel(model, {
        options = {{
            name = "createpedmenu",
            type = "client",
            event = "",
            icon = "fas fa-car",
            label = "Spawn Vehicle",
            action = function(entity)
                SpawnVeh()
            end,
            canInteract = function(entity, distance, data)
                return true
            end
        }},
        distance = 1.0
    })
end

function EnableDriftingMode()
    if not enable then
        enable = true
        CreateMenuPed()
    end
end

function DisableDriftingMode()
    if enable then
        enable = false
        DeleteMenuPed()
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteMenuPed()
    end
end)

local isDriver = false
Citizen.CreateThread(function()
	while true do
        local sleep = 1000
        if enable then
            sleep = 100
            local ped = PlayerPedId()
            if not IsPlayerDead(PlayerId()) then
                isDriver = (GetPedInVehicleSeat(GetVehiclePedIsUsing(ped), -1) == ped)
                if not isInVehicle then
                    if isDriver then
                        isInVehicle = true
                        isEnteringVehicle = true
                        currentSeat = GetSeatPedIsTryingToEnter(ped)
                        currentVehicle = GetVehiclePedIsUsing(ped)
                        ToggleDrifting(currentVehicle)
                    end
                elseif isInVehicle then
                    if not isDriver then
                        ToggleDrifting(currentVehicle)
                        isInVehicle = false
                        isEnteringVehicle = false
                        currentSeat = 0
                        currentVehicle = 0
                    end
                end
            end
        end
        Citizen.Wait(sleep)
	end
end)
