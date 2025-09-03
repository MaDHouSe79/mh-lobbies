--[[ ===================================================== ]] --
--[[                 MH Lobbies by MaDHouSe                ]] --
--[[ ===================================================== ]] --
local planePedSeats = {}

local function GeneratePed(modelString, modelString2, playerId)
    RegisterEntityForCutscene(0, modelString, 3, GetEntityModel(playerId), 0)
    RegisterEntityForCutscene(playerId, modelString, 0, 0, 0)
    SetCutsceneEntityStreamingFlags(modelString, 0, 1)
    local ped = RegisterEntityForCutscene(0, modelString2, 3, 0, 64)
    NetworkSetEntityInvisibleToNetwork(ped, true)
end

local function RelocatePlayer(lobbieId)
    DisableGang()
    DisableZombies()
    DisableCheatMode()
    DisableDriftingMode()
    DeleteAllPeds()
    if config.Lobbies[lobbieId].spawnCoords ~= nil and config.Lobbies[lobbieId].spawnCoords ~= false then
        SetEntityCoords(PlayerPedId(), config.Lobbies[lobbieId].spawnCoords.xyz)
        SetEntityHeading(PlayerPedId(), config.Lobbies[lobbieId].spawnCoords.w)
    end
    Wait(1000)
    DeleteAllPeds()
    if config.Lobbies[lobbieId].isDrift then EnableDriftingMode() elseif not config.Lobbies[lobbieId].isDrift then DisableDriftingMode() end
    if config.Lobbies[lobbieId].isGang then EnableGang() elseif not config.Lobbies[lobbieId].isGang then DisableGang() end
    if config.Lobbies[lobbieId].isZombie then EnableZombies() elseif not config.Lobbies[lobbieId].isZombie then DisableZombies() end
    if config.Lobbies[lobbieId].isCheat then EnableCheatMode() elseif not config.Lobbies[lobbieId].isCheat then DisableCheatMode() end
    DoScreenFadeIn(100)
    Notify(Lang:t('now_in_lobbie', {lobbie = config.Lobbies[lobbieId].label}), "info", 5000)
end

local function CutsceneCheck(lobbieId)
    CreateThread(function()
        while true do
            local sleep = 1000
            if config.UseCutScene then
                if ((IsCutsceneActive()) and (IsCutscenePlaying()) and not (HasCutsceneFinished())) then
                    sleep = 0
                    if GetCutsceneSectionPlaying() == 4 then
                        StopCutsceneImmediately()
                        for i = 0, #planePedSeats, 1 do
                            DeleteEntity(planePedSeats[i])
                            planePedSeats[i] = nil
                        end
                        planePedSeats = {}
                        PrepareMusicEvent("AC_STOP")
                        TriggerMusicEvent("AC_STOP")
                        RelocatePlayer(lobbieId)
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

local function RunCutScene(lobbieId)
    PrepareMusicEvent("FM_INTRO_START")
    TriggerMusicEvent("FM_INTRO_START")
    local male, female = "mp_m_freemode_01", "mp_f_freemode_01"
    LoadModel(male)
    LoadModel(female)
    local playerId = PlayerPedId()
    if IsPedMale(playerId) then
        RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 31, 8)
    else
        RequestCutsceneWithPlaybackList("MP_INTRO_CONCAT", 103, 8)
    end
    while not HasCutsceneLoaded() do Wait(1) end
    if IsPedMale(playerId) then
        GeneratePed("MP_Male_Character", "MP_Female_Character", playerId)
    else
        GeneratePed("MP_Female_Character", "MP_Male_Character", playerId)
    end
    local PlanePedList = {
        [0] = "MP_Plane_Passenger_1",
        [1] = "MP_Plane_Passenger_2",
        [2] = "MP_Plane_Passenger_3",
        [3] = "MP_Plane_Passenger_4",
        [4] = "MP_Plane_Passenger_5",
        [5] = "MP_Plane_Passenger_6",
        [6] = "MP_Plane_Passenger_7"
    }
    for id = 1, #PlanePedList, 1 do
        if id == 1 or id == 2 or id == 4 or id == 6 then
            planePedSeats[id] = CreatePed(0, female, 0.0, 0.0, 0.0, 0.0, 0, 0)
        else
            planePedSeats[id] = CreatePed(0, male, 0.0, 0.0, 0.0, 0.0, 0, 0)
        end
        if not IsEntityDead(planePedSeats[id]) then
            ClearPedProp(planePedSeats[id], 0)
            SetPedRandomComponentVariation(planePedSeats[id], 0)
            FinalizeHeadBlend(planePedSeats[id])
            RegisterEntityForCutscene(planePedSeats[id], PlanePedList[id], 0, 0, 64)
        end
    end
    lobbie = lobbieId
    NewLoadSceneStartSphere(-1212.79, -1673.52, 7, 1000, 0)
    DoScreenFadeIn(550)
    CutsceneCheck(lobbieId)
    StartCutscene(4)
end
exports('RunCutScene', RunCutScene)

function DoesLobbieIdExsist(id, label)
    if config.Lobbies[id] ~= nil and config.Lobbies[id].label == label then return true end
    return false
end

function GoToLocation(lobbieId)
    if not IsDead() then
        DeleteAllPeds()
        DoScreenFadeOut(100)
        Wait(1000)
        if config.UseCutScene then
            RunCutScene(lobbieId)
        else
            RelocatePlayer(lobbieId)
        end
    end
end

function OpenLobbieMenu()
    local menu = {}
    if config.Menu == 'qb' then
        menu = {{header = "MH "..Lang:t('lobbie_menu', {id = lobbie}), isMenuHeader = true}}
        for _, data in pairs(config.Lobbies) do
            local txt = Lang:t('players')
            if data.players == 1 then txt = Lang:t('players') end
            menu[#menu + 1] = {
                id = data.id,
                header = "#" .. data.id .. " " .. data.label .. " " .. Lang:t('price') .. " " .. config.MoneySign .. data.price .. " (" .. data.players .. " " .. txt .. ")",
                txt = "",
                params = {
                    isServer = true,
                    event = "mh-lobbies:server:setLobbieId",
                    args = {id = data.id, label = data.label, population = data.population, lockdown = data.lockdown}
                }
            }        
        end
        table.sort(menu, function(a, b) if a.id and b.id then return a.id < b.id end end)
        menu[#menu + 1] = {header = Lang:t('close'), txt = "", params = { event = "qb-menu:closeMenu" } }
        exports['qb-menu']:openMenu(menu)
    elseif config.Menu == 'ox' then
        menu = {}
        for _, data in pairs(config.Lobbies) do
            local txt = Lang:t('players')
            if data.players == 1 then txt = Lang:t('player') end
            menu[#menu + 1] = {
                id = data.id,
                title = data.label,
                description = "",
                arrow = true,
                onSelect = function()
                    TriggerServerEvent('mh-lobbies:server:setLobbieId', {id = data.id, label = data.label, population = data.population, lockdown = data.lockdown})
                end,
                metadata = {
                    {label = Lang:t('travel_price'), value = config.MoneySign .. data.price}, 
                    {label = Lang:t('total_players'), value = data.players .. " " .. txt}
                }
            }
        end
        table.sort(menu, function(a, b) if a.id and b.id then return a.id < b.id end end)
        lib.registerContext({id = 'ServerLobbieMenu', title = "MH "..Lang:t('lobbie_menu', {id = lobbie}), options = menu})
        lib.showContext('ServerLobbieMenu')
    end
end

function OpenMenu(entity)
    TaskTurnPedToFaceEntity(PlayerPedId(), entity, 1000)
    Wait(1500)
    if config.UseProgressBar then
        Progressbar('openLobbieMenu', "MH "..Lang:t('load_lobbie_menu'), config.ProgressBarTimer, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {
            animDict = 'amb@prop_human_atm@male@enter',
            anim = 'enter'
        }, {
            model = 'prop_cs_credit_card',
            bone = 28422,
            coords = vector3(0.1, 0.03, -0.05),
            rotation = vector3(0.0, 0.0, 180.0)
        }, {}, function()
            OpenLobbieMenu()
        end, function()
            ClearPedTasks(PlayerPedId())
        end)
    elseif not config.UseProgressBar then
        OpenLobbieMenu()
    end
end

function AdminMenu(data)
    local menu = {{header = "MH Admin Lobbie Menu", isMenuHeader = true}}
    for k, player in pairs(data.players) do
        menu[#menu + 1] = {
            id = player.id,
            header = "#ID: "..player.id .. " Player: "..player.username,
            txt = "Click if you want to mark this player as cheater",
            params = {
                isServer = true,
                event = "mh-lobbies:server:changePlayerState",
                args = {id = player.id, isCheater = true}
            }
        }        
    end
    table.sort(menu, function(a, b) if a.id and b.id then return a.id < b.id end end)
    menu[#menu + 1] = {header = Lang:t('close'), txt = "", params = { event = "qb-menu:closeMenu" } }
    exports['qb-menu']:openMenu(menu)
end

function CreateMenuTarget()
    if config.UseTarget then
        if config.Target == 'qb-target' then
            exports['qb-target']:AddTargetModel(config.TeleportModels, {
                options = {{
                    name = "lobbies",
                    type = "client",
                    event = "",
                    icon = "fas fa-ticket",
                    label = "MH "..Lang:t('lobbie_menu'),
                    action = function(entity)
                        OpenMenu(entity)
                    end,
                    canInteract = function(entity, distance, data)
                        if IsPedInAnyVehicle(PlayerPedId(), false) then return false end
                        if IsDead() then return false end
                        return true
                    end
                }},
                distance = 1.0
            })
        elseif config.Target == 'ox_target' then
            exports.ox_target:removeModel(config.TeleportModels, 'lobbies')
            exports.ox_target:addModel(config.TeleportModels, {{
                name = 'lobbies',
                icon = "fas fa-ticket",
                label = "MH "..Lang:t('lobbie_menu'),
                onSelect = function(data)
                    OpenMenu(data.entity)
                end,
                canInteract = function(entity, distance, data)
                    if IsPedInAnyVehicle(PlayerPedId(), false) then return false end
                    if IsDead() then return false end
                    return true
                end,
                distance = 1.0
            }})
        end
    end
end

function DoesLobbieExist(lobbieId, label)
    local exist = false
    if config.Lobbies ~= nil and config.Lobbies[lobbieId] ~= nil and config.Lobbies[lobbieId].label ~= nil and
        config.Lobbies[lobbieId].label == label then
        exist = true
    end
    return exist
end

function IsLobbieAlreadyExist(label)
    for k, lobbie in pairs(config.Lobbies) do
        if lobbie.label == label then
            return true
        end
    end
    return false
end

function CloseNUI()
    SetNuiFocus(false, false)
    SendNUIMessage({type = "newSetup", enable = false})
    Wait(10)
end

function OpenNUI()
    SetNuiFocus(true, true)
    SendNUIMessage({type = "newSetup", enable = true})
    Wait(1)
end

local added = false
function ToggleHat(state)
    if state then
        if GetPedPropIndex(PlayerPedId(), 0) <= 0 and not added then
            added = true
            SetPedPropIndex(PlayerPedId(), 0, 1, 0, true) 
        end
    elseif not state then
        if GetPedPropIndex(PlayerPedId(), 0) >= 1 and added then
            added = false
            SetPedPropIndex(PlayerPedId(), 0, 0, 0, false) 
            ClearPedProp(PlayerPedId(), 0)
        end
    end
end

function DeleteAllPeds1()
    local peds = GetGamePool('CPed')
    for i = 1, #peds, 1 do
        if DoesEntityExist(peds[i]) then
            SetEntityAsMissionEntity(peds[i], true, true)
            DeletePed(peds[i])
        end
    end
end

function DeleteAllVehicles1()
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles, 1 do
        if DoesEntityExist(vehicles[i]) then
            SetEntityAsMissionEntity(vehicles[i], true, true)
            DeleteEntity(vehicles[i])
        end
    end
end