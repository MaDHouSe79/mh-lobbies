--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--

-- Don't change this below.
SV_Config = {}
SV_Config.Lobbies = {}

-- this automatically detect money sign en type
SV_Config.MoneyType = nil
SV_Config.MoneySign = "€" -- $ of €
if GetResourceState("es_extended") ~= 'missing' then
    SV_Config.MoneyType = 'money'
elseif GetResourceState("qb-core") ~= 'missing' then
    SV_Config.MoneyType = 'cash'
else
    SV_Config.MoneyType = 'cash'
end


SV_Config.UseTarget = true -- if false it use 3D text on screen.
SV_Config.Target = 'ox_target' -- qb-target or ox_target
-- Don't change this above.

SV_Config.DebugMode = false
--
SV_Config.Menu = 'ox' -- qb or ox
--
SV_Config.TeleportModels = {
    "prop_train_ticket_02",
}
--
SV_Config.UseCutScene = false
SV_Config.PlanePedList = {
    [0] = "MP_Plane_Passenger_1",
    [1] = "MP_Plane_Passenger_2",
    [2] = "MP_Plane_Passenger_3",
    [3] = "MP_Plane_Passenger_4",
    [4] = "MP_Plane_Passenger_5",
    [5] = "MP_Plane_Passenger_6",
    [6] = "MP_Plane_Passenger_7"
}
--
SV_Config.UseProgressBar = false
SV_Config.ProgressBarTimer = 1000
--
SV_Config.CheatLobbie = 1000 -- cheater lobbie id
SV_Config.AdminLobbie = 2000 -- admin lobbie id
--
SV_Config.SpawnPoint = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916) -- The is the main spawnpoint when changeing lobbies.
--
SV_Config.SpawnPoints = {
    [SV_Config.CheatLobbie] = {
        id = SV_Config.CheatLobbie,
        label = "Cheater Lobbie",
        coords = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916),
    },

    [SV_Config.AdminLobbie] = {
        id = SV_Config.AdminLobbie,
        label = "Admin Lobbie",
        coords = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916),
    },
    [0] = {
        id = 0,
        label = "Main Lobbie",
        coords = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916),
    },
    [1] = {
        id = 1,
        label = "Zombie Lobbie",
        coords = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916),
    },
    [2] = {
        id = 2,
        label = "Gang Lobbie",
        coords = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916),
    },
    [3] = {
        id = 3,
        label = "Drifting Lobbie",
        coords = vector4(-1039.0568, -2739.4216, 13.8450, 330.6916),
    },
}
--
SV_Config.DriftVehicleList = {
    "adder",
}