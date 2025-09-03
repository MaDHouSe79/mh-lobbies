--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--

function FileExists(name)
   local f= io.open(name,"r")
   if f ~= nil then io.close(f) return true else return false end
end

function IsAdmin(src)
    if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'command') then return true end
    return false
end

function Pay(src, lobbieId)
    if SV_Config.MoneyType == nil then
        return true
    elseif SV_Config.MoneyType ~= nil then
        local amount = GetMoney(src, SV_Config.MoneyType)
        if amount == -1 then
            return true
        elseif amount >= 0 then
            local price = SV_Config.Lobbies[lobbieId].price
            if price >= 1 then
                if amount >= price then
                    if RemoveMoney(src, SV_Config.MoneyType, price, 'mh-lobbies-change') then
                        return true
                    end
                elseif amount < price then
                    return false
                end
            elseif price <= 0 then
                return true
            end
        end
        return false
    end
end

function UpdatePlayerData(playerId, mode)
    local license = GetPlayerIdentifierByType(playerId, 'license')
    local player = MySQL.Sync.fetchAll("SELECT * FROM "..PlayersTable.." WHERE license = ?", {license})[1]
    if player ~= nil then
        if mode == 'add' then
            if tonumber(player.cheater) == 0 then
                MySQL.Async.execute('UPDATE '..PlayersTable..' SET cheater = 1 WHERE license = ?', {license})
                TriggerClientEvent('mh-lobbies:client:checkPlayerStatus', playerId, {id = playerId, status = true})
                return true
            elseif tonumber(player.cheater) == 1 then
                TriggerClientEvent('mh-lobbies:client:checkPlayerStatus', playerId, {id = playerId, status = true})
                return false
            end
        elseif mode == 'remove' then
            if tonumber(player.cheater) == 1 then
                MySQL.Async.execute('UPDATE '..PlayersTable..' SET cheater = 0 WHERE license = ?', {license})
                TriggerClientEvent('mh-lobbies:client:checkPlayerStatus', playerId, {id = playerId, status = false})
                return true
            elseif tonumber(player.cheater) == 0 then
                TriggerClientEvent('mh-lobbies:client:checkPlayerStatus', playerId, {id = playerId, status = false})
                return false
            end
        end
    else
        return false
    end
end

function IsPlayerACheater(playerId)
    local license = GetPlayerIdentifierByType(playerId, 'license')
    local player = MySQL.Sync.fetchAll("SELECT * FROM "..PlayersTable.." WHERE license = ?", {license})[1]
    if player == nil then
        local license2 = GetPlayerIdentifierByType(playerId, 'license2')
        player = MySQL.Sync.fetchAll("SELECT * FROM "..PlayersTable.." WHERE license = ?", {license2})[1]
    end
    if tonumber(player.cheater) == 1 then return true else return false end
end

function ChangePlayerState(data)
    local src = source
    if data.isCheater then 
        UpdatePlayerData(tonumber(data.id), 'add')
    elseif not data.isCheater then 
        UpdatePlayerData(tonumber(data.id), 'remove')
    end
end
exports('ToggleCheater', ChangePlayerState)