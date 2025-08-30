SV_Config.Lobbies[0] = {
    id = 0,
    label = "Main Lobbie",
    lockdown = "inactive",
    population = true,
    isAdmin = false,
    isCheat = false,
    isZombie = false,
    isGang = false,
    players = 0,
    price = 1000,
    spawnCoords = SV_Config.SpawnPoints[0].coords,
}

SV_Config.Lobbies[1] = {
    id = 1,
    label = "Gang Lobbie",
    lockdown = "inactive",
    population = true,
    isAdmin = false,
    isCheat = false,
    isZombie = false,
    isGang = true,
    players = 0,
    price = 1000,
    spawnCoords = SV_Config.SpawnPoints[1].coords,
}

SV_Config.Lobbies[2] = {
    id = 2,
    label = "Zombie Lobbie",
    lockdown = "inactive",
    population = true,
    isAdmin = false,
    isCheat = false,
    isZombie = true,
    isGang = false,
    players = 0,
    price = 1000,
    spawnCoords = SV_Config.SpawnPoints[2].coords,
}

SV_Config.Lobbies[SV_Config.CheatLobbie] = {
    id = SV_Config.CheatLobbie,
    label = "Cheater Lobbie",
    lockdown = "strict",
    population = false,
    isAdmin = false,
    isCheat = true,
    isZombie = false,
    isGang = false,
    players = 0,
    price = 0,
    spawnCoords = false,
}

SV_Config.Lobbies[SV_Config.AdminLobbie] = {
    id = SV_Config.AdminLobbie,
    label = "Admin Lobbie",
    lockdown = "inactive",
    population = true,
    isAdmin = true,
    isCheat = false,
    isZombie = false,
    isGang = false,
    players = 0,
    price = 0,
    spawnCoords = false,
}