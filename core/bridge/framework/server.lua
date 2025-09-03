--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
Framework, CreateCallback, PlayersTable = nil, nil, "players"
if GetResourceState("es_extended") ~= 'missing' then

    Framework = exports['es_extended']:getSharedObject()
    PlayersTable = "users"
    CreateCallback = Framework.RegisterServerCallback

    function GetPlayer(src) return Framework.GetPlayerFromId(src) end

    function GetMoney(src, account)
        local xPlayer = GetPlayer(src)
        return xPlayer.getAccount(account).money
    end

    function RemoveMoney(src, account, amount, reason)
        local xPlayer = GetPlayer(src)
        local last = GetMoney(src, account)
        xPlayer.removeAccountMoney(account, amount, reason)
        local current = GetMoney(src, account)
        if current < last then
            return true
        else
            return false
        end
    end

    function Notify(src, message, type, length)
        if GetResourceState("ox_lib") ~= 'missing' then
            lib.notify(src, { title = "MH Lobbies", description = message, type = type })
        else
            if type == nil then type = 'primary' end
            if length == nil then length = 5000 end
            Framework.ShowNotification(src, "MH Lobbies\n"..message, type, length)
        end
    end

elseif GetResourceState("qb-core") ~= 'missing' then

    Framework = exports['qb-core']:GetCoreObject()
    PlayersTable = "players"
    CreateCallback = Framework.Functions.CreateCallback

    function GetPlayer(src) return Framework.Functions.GetPlayer(src) end

    function GetMoney(src, account)
        local Player = GetPlayer(src)
        if account == 'bank' then
            return Player.PlayerData.money.bank
        elseif account == 'cash' then
            return Player.PlayerData.money.cash
        end
    end

    function RemoveMoney(src, account, amount, reason)
        local Player = GetPlayer(src)
        if account == 'bank' then
            return Player.Functions.RemoveMoney('bank', amount, reason)
        elseif account == 'cash' then
            return Player.Functions.RemoveMoney('cash', amount, reason)
        end
    end

    function Notify(src, message, type, length)
        if GetResourceState("ox_lib") ~= 'missing' then
            lib.notify(src, { title = "MH Lobbies", description = message, type = type })
        else
            if type == nil then type = 'primary' end
            if length == nil then length = 5000 end
            Framework.Functions.Notify(src, { text = "MH Lobbies", caption = message }, type, length)
        end
    end

else

    function RemoveMoney(src, account, amount, reason)
        return true
    end

    function GetMoney(src, account)
        return -1
    end

    function Notify(src, message, type, length)
        if GetResourceState("ox_lib") ~= 'missing' then
            lib.notify(src, { title = "MH Lobbies", description = message, type = type })
        end
    end

end