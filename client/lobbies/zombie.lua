--[[ ===================================================== ]] --
--[[                 MH Lobbies by MaDHouSe                ]] --
--[[ ===================================================== ]] --
local enable = false

-- Reset Relationship Between Groups
local function ResetRelationshipBetweenGroups()
    SetRelationshipBetweenGroups(1, GetHashKey('ZOMBIE'), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(1, GetHashKey('PLAYER'), GetHashKey('ZOMBIE'))
end

--- Set Zombies Relationship
local function SetZombiesRelationship()
    DecorRegister('RegisterZombie', 2)
    AddRelationshipGroup('ZOMBIE')
    SetRelationshipBetweenGroups(5, GetHashKey('ZOMBIE'), GetHashKey('PLAYER'))
    SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('ZOMBIE'))
end

--- Set All Peds Bloody
local function SetAllPedsBloody()
    local peds = GetGamePool('CPed')
    for i = 1, #peds, 1 do
        local ped = peds[i]
        if DoesEntityExist(ped) and ped ~= PlayerPedId() then
            ApplyPedDamagePack(ped, "TD_SHOTGUN_FRONT_KILL", 0, 10)
            ApplyPedDamagePack(ped, "BigRunOverByVehicle ", 0, 10)
            ApplyPedDamagePack(ped, "Dirt_Mud", 0, 10)
            ApplyPedDamagePack(ped, "Explosion_Large", 0, 10)
            ApplyPedDamagePack(ped, "RunOverByVehicle", 0, 10)
            ApplyPedDamagePack(ped, "Splashback_Face_0", 0, 10)
            ApplyPedDamagePack(ped, "Splashback_Face_1", 0, 10)
            ApplyPedDamagePack(ped, "SCR_Shark", 0, 10)
            ApplyPedDamagePack(ped, "SCR_Cougar", 0, 10)
            ApplyPedDamagePack(ped, "Car_Crash_Heavy", 0, 10)
            ApplyPedDamagePack(ped, "TD_SHOTGUN_REAR_KILL", 0, 10)
            ApplyPedDamagePack(ped, "SCR_Torture", 0, 10)
            ApplyPedDamagePack(ped, "TD_melee_face_l", 0, 10)
            ApplyPedDamagePack(ped, "MTD_melee_face_r", 0, 10)
            ApplyPedDamagePack(ped, "MTD_melee_face_jaw", 0, 10)
        end
    end
end

function EnableZombies()
    if not enable then
        enable = true
        SetAllPedsBloody()
        SetZombiesRelationship()
    end
end

function DisableZombies()
    if enable then
        enable = false
        DeleteAllPeds1()
        DeleteAllVehicles1()
        ResetRelationshipBetweenGroups()
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        if enable then
            sleep = 10
            local Zombie = -1
            local Success = false
            local Handler, Zombie = FindFirstPed()
            repeat
                Wait(100)
                if IsPedHuman(Zombie) and not IsPedAPlayer(Zombie) and not IsPedDeadOrDying(Zombie, true) then
                    if not DecorExistOn(Zombie, 'RegisterZombie') then
                        ClearPedTasks(Zombie)
                        ClearPedSecondaryTask(Zombie)
                        ClearPedTasksImmediately(Zombie)
                        TaskWanderStandard(Zombie, 10.0, 10)
                        SetPedRelationshipGroupHash(Zombie, 'ZOMBIE')
                        ApplyPedDamagePack(Zombie, 'BigHitByVehicle', 0.0, 1.0)
                        SetEntityHealth(Zombie, 200)
                        RequestAnimSet('move_m@drunk@verydrunk')
                        while not HasAnimSetLoaded('move_m@drunk@verydrunk') do
                            Wait(0)
                        end
                        SetPedMovementClipset(Zombie, 'move_m@drunk@verydrunk', 1.0)
                        SetPedConfigFlag(Zombie, 100, false)
                        DecorSetBool(Zombie, 'RegisterZombie', true)
                    end
                    SetPedRagdollBlockingFlags(Zombie, 1)
                    SetPedCanRagdollFromPlayerImpact(Zombie, false)
                    SetPedEnableWeaponBlocking(Zombie, true)
                    DisablePedPainAudio(Zombie, true)
                    StopPedSpeaking(Zombie, true)
                    StopPedRingtone(Zombie)
                    SetPedIsDrunk(Zombie, true)
                    SetPedConfigFlag(Zombie, 166, false)
                    SetPedConfigFlag(Zombie, 170, false)
                    SetBlockingOfNonTemporaryEvents(Zombie, true)
                    SetPedCanEvasiveDive(Zombie, false)
                    RemoveAllPedWeapons(Zombie, true)
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local PedCoords = GetEntityCoords(Zombie)
                    local Distance = #(PedCoords - PlayerCoords)
                    local DistanceTarget
                    if isShooting then
                        DistanceTarget = 250.0
                    elseif isRunning then
                        DistanceTarget = 150.0
                    else
                        DistanceTarget = 50.0
                    end
                    if Distance <= DistanceTarget and not IsPedInAnyVehicle(PlayerPedId(), false) then
                        TaskGoToEntity(Zombie, PlayerPedId(), -1, 0.0, 2.0, 1073741824, 0)
                    end
                    if Distance <= 1.3 then
                        if not IsPedRagdoll(Zombie) and not IsPedGettingUp(Zombie) then
                            local health = GetEntityHealth(PlayerPedId())
                            if health <= 0.0 then
                                health = 0.0
                            end
                            if health == 0.0 then
                                ClearPedTasks(Zombie)
                                TaskWanderStandard(Zombie, 10.0, 10)
                            elseif health >= 150.0 then
                                RequestAnimSet('melee@unarmed@streamed_core_fps')
                                while not HasAnimSetLoaded('melee@unarmed@streamed_core_fps') do
                                    Wait(10)
                                end
                                TaskPlayAnim(Zombie, 'melee@unarmed@streamed_core_fps', 'ground_attack_0_psycho', 8.0,
                                    1.0, -1, 48, 0.001, false, false, false)
                                ApplyDamageToPed(PlayerPedId(), 5, false)
                            end
                        end
                    end
                    if not NetworkGetEntityIsNetworked(Zombie) then
                        DeleteEntity(Zombie)
                    end
                end
                Success, Zombie = FindNextPed(Handler)
            until not (Success)
            EndFindPed(Handler)
        end
        Wait(sleep)
    end
end)
