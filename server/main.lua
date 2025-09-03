--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
RegisterCommand("setcheater", function(source, args, rawCommand)
    local playerId = nil
    if type(args[1]) == 'string' then playerId = tonumber(args[1]) end
    if playerId ~= nil then UpdatePlayerData(playerId, 'add') end
end, true)

RegisterCommand("removecheater", function(source, args, rawCommand)
    local playerId = nil
    if type(args[1]) == 'string' then playerId = tonumber(args[1]) end
    if playerId ~= nil then UpdatePlayerData(playerId, 'remove') end
end, true)

RegisterCommand("lobbie", function(source, args, rawCommand)
    local src = source
    local lobbieId = GetPlayerRoutingBucket(src)
    if SV_Config.Lobbies[lobbieId] then
        local lobbieData = SV_Config.Lobbies[lobbieId]
        Notify(src, Lang:t('you_are_in_lobbie', {id = lobbieData.id, label = lobbieData.label}), "info", 5000)
    end
end)

RegisterCommand("lobbieadminmenu", function(source, args, rawCommand)
    local src = source
    local players = {}
    for k , player in pairs(GetPlayers()) do
        if tonumber(player) ~= tonumber(src) then
            local info = {id = player, username = GetPlayerName(player) }
            local Player = GetPlayer(player)
            if GetResourceState("es_extended") ~= 'missing' then
                info.username = Player.firstname .. " ".. Player.lastname
            elseif GetResourceState("qb-core") ~= 'missing' then
                info.username = Player.PlayerData.charinfo.firstname .. " ".. Player.PlayerData.charinfo.lastname
            end
            players[#players + 1] = info
        end
    end
    TriggerClientEvent('mh-lobbies:client:adminMenu', src, {id = src, players = players})
end, true)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        MySQL.Async.execute('ALTER TABLE '..PlayersTable..' ADD COLUMN IF NOT EXISTS cheater INT NULL DEFAULT 0')
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
end)

RegisterNetEvent('mh-lobbies:server:changePlayerState', function(data)
    local src = source
    if IsAdmin(src) then ChangePlayerState(data) end
end)

RegisterNetEvent('mh-lobbies:server:setLobbieId', function(data)
    local src = source
    local lobbieData = Lobbies:getLobbie(data.id)
    if lobbieData.id == data.id then
        if lobbieData.isAdmin then
            if IsAdmin(src) then
                Lobbies:change(src, SV_Config.AdminLobbie, data.population, data.lockdown)
            else
                Notify(src, Lang:t('can_not_join_lobbie', {lobby = lobbieData.label}), "info", 5000)
            end
        else
            if IsPlayerACheater(src) then
                Lobbies:change(src, SV_Config.CheatLobbie, false, "strict")
            elseif not IsPlayerACheater(src) then
                Lobbies:change(src, data.id, data.population, data.lockdown)
            end
        end
    end
    TriggerClientEvent('mh-lobbies:client:checkPlayerStatus', src, {id = src, status = IsPlayerACheater(src)})
end)

RegisterNetEvent('mh-lobbies:server:onjoin', function()
    local src = source
    if IsPlayerACheater(src) then 
        Lobbies:change(src, SV_Config.CheatLobbie, false, "strict") 
    else
        Lobbies:addPlayer(src, 0) 
    end
    Lobbies:refresh(src)
    TriggerClientEvent('mh-lobbies:client:checkPlayerStatus', src, {id = src, status = IsPlayerACheater(src)})
end)

RegisterNetEvent('mh-lobbies:server:newLobbie', function(data)
    local src = source
    if IsAdmin(src) then
        local isAdmin, isDrift, isJob, isGang, isZombie, isCheat = false, false, false, false, false, false
        if data.lobbietype == 'cheat' then
            isCheat = true
        elseif data.lobbietype == 'drift' then
            isDrift = true
        elseif data.lobbietype == 'job' then
            isJob = true
        elseif data.lobbietype == 'gang' then
            isGang = true
        elseif data.lobbietype == 'zombie' then
            isZombie = true
        elseif data.lobbietype == 'admin' then
            isAdmin = true
        end

        local population = false    
        if data.population == "true" then population = true end

        local tmpData = {
            lobbieid = tonumber(data.lobbieid),
            lobbiename = tostring(data.lobbiename),
            price = tonumber(data.price),
            lockdown = tostring(data.lockdown),
            filename = tostring(data.filename),
            spawnCoords = SV_Config.SpawnPoint,
            population = population,
            isAdmin = isAdmin,
            isDrift = isDrift,
            isJob = isJob,
            isGang = isGang,
            isZombie = isZombie,
            isCheat = isCheat,
        }
        Lobbies:newLobbie(src, tmpData)
    end
end)