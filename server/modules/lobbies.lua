--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
Lobbies = {}
Lobbies.Channels = {}

function Lobbies:refresh()
    TriggerClientEvent('mh-lobbies:client:refreshData', -1, {config = SV_Config})
end

function Lobbies:addPlayer(playerId, lobbieId)
    if not SV_Config.Lobbies[lobbieId] then return end
    if not self.Channels[lobbieId] then self.Channels[lobbieId] = {} end
    if self.Channels[lobbieId][playerId] then return end
    if not self.Channels[lobbieId][playerId] then
        self.Channels[lobbieId][playerId] = {id = playerId, username = GetPlayerName(playerId)}
        SV_Config.Lobbies[lobbieId].players = SV_Config.Lobbies[lobbieId].players + 1
    end
end

function Lobbies:removePlayer(playerId, lobbieId)
    if not SV_Config.Lobbies[lobbieId] then return end
    if not self.Channels[lobbieId] then return end
    if not self.Channels[lobbieId][playerId] then return end
    table.remove(self.Channels[lobbieId], playerId)
    SV_Config.Lobbies[lobbieId].players = SV_Config.Lobbies[lobbieId].players - 1
end

function Lobbies:getPlayer(playerId, lobbieId)
    if not SV_Config.Lobbies[lobbieId] then return end
    if not self.Channels[lobbieId] then return end
    if not self.Channels[lobbieId][playerId] then return end
    return self.Channels[lobbieId][playerId]
end

function Lobbies:getLobbie(lobbieId)
    if not SV_Config.Lobbies[lobbieId] then return false end
    return SV_Config.Lobbies[lobbieId]
end

function Lobbies:change(playerId, lobbieId, population, lockdown)
    if not SV_Config.Lobbies[tonumber(lobbieId)] then return end
    local lastLobbieId = GetPlayerRoutingBucket(playerId)
    if lastLobbieId ~= tonumber(lobbieId) then
        local hasPaid = Pay(playerId, tonumber(lobbieId))
        if hasPaid then
            local changeLobbie = false
            Lobbies:removePlayer(playerId, lastLobbieId)
            if tonumber(lobbieId) == 0 then
                Lobbies:addPlayer(playerId, 0)
                SetPlayerRoutingBucket(playerId, 0)
                changeLobbie = true
            elseif tonumber(lobbieId) >= 1 then
                Lobbies:addPlayer(playerId, tonumber(lobbieId))
                SetRoutingBucketPopulationEnabled(tonumber(lobbieId), population)
                SetRoutingBucketEntityLockdownMode(tonumber(lobbieId), lockdown)
                SetPlayerRoutingBucket(playerId, tonumber(lobbieId))
                changeLobbie = true
            end
            if changeLobbie then
                TriggerClientEvent('mh-lobbies:client:setLobbieId', playerId, {id = tonumber(lobbieId)})
                Lobbies:refresh()
                print(("Player %s id(%s) is moved from %s to %s"):format(GetPlayerName(playerId), playerId, SV_Config.Lobbies[lastLobbieId].label, SV_Config.Lobbies[lobbieId].label))
                return true
            else
                return false
            end
        else
            Notify(playerId, Lang:t('not_enough_money', {moneysign = SV_Config.MoneySign, price = SV_Config.Lobbies[lobbieId].price}) , "info", 5000)
            return false
        end
    else
        Notify(playerId, Lang:t('already_in_lobbie', {lobbie = SV_Config.Lobbies[lobbieId].label}), "info", 5000)
        return false
    end
end

function Lobbies:newLobbie(src, data)
    if type(data) == 'table' then
        local path = GetResourcePath(GetCurrentResourceName())
        if data.filename ~= nil then
            if data.filename == 'main' then
                Notify(src, Lang:t('file_already_exist', {filename = data.filename}), "info", 5000)
                return
            else
                path = path:gsub('//', '/') .. '/server/configs/' .. string.gsub(data.filename:lower(), ".lua", "") .. '.lua'
                if path ~= nil then
                    local file = io.open(path, 'a+')
                    local config = 'SV_Config.Lobbies['..data.lobbieid..'] = {\n    id = ' .. data.lobbieid .. ',\n    label = "' .. data.lobbiename .. '",\n    lockdown = "' .. data.lockdown .. '",\n    population = ' .. tostring(data.population) .. ',\n    isAdmin = ' .. tostring(data.isAdmin) .. ',\n    isGang = ' .. tostring(data.isGang) .. ',\n    isZombie = ' .. tostring(data.isZombie) .. ',\n    isCheat = ' .. tostring(data.isCheat) .. ',\n    players = 0,\n    price = ' .. data.price.. ',\n    spawnCoords = ' .. data.spawnCoords ..'\n}'
                    file:write(config)
                    file:close()
                    Notify(src, Lang:t('file_created', {filename = "(server/configs/"..data.filename:lower()..".lua)"}), "info", 5000)
                    local newdata = {id = data.lobbieid, label = data.lobbiename, lockdown = data.lockdown, population = data.population, isAdmin = data.isAdmin, isGang = data.isGang, isZombie = data.isZombie, isCheat = data.isCheat, players = 0, price = data.price, coords = data.spawnCoords}
                    SV_Config.Lobbies[newdata.id] = newdata
                    Notify(src, "New "..SV_Config.Lobbies[newdata.id].label.." is created!", "info", 5000)
                    Lobbies:refresh()
                end                
            end
        elseif data.filename == nil then
            Notify(src, Lang:t('not_enter_a_filename'), "info", 5000)
            return
        end
    elseif type(data) ~= 'table' then
        print(Lang:t('create_new_lobbie_error'))
        return
    end
end

function Lobbies:deleteFile(src, filename)
    local path = GetResourcePath(GetCurrentResourceName())
    if data.filename == 'main' then
        Notify(src, Lanf:t('delete_default_file_error', {filename = filename}) , "info", 5000)
        return
    else
        path = path:gsub('//', '/') .. '/server/configs/' .. string.gsub(filename, ".lua", "") .. '.lua'
        if path then 
            local remove, error = os.remove(path)
            if remove then
                Notify(src, Lanf:t('file_deleted', {filename = "(server/configs/"..filename..".lua)"}) , "info", 5000)
                return
            else
                print(error)
                return
            end
        end        
    end
end

-- Commands
RegisterCommand("changelobbie", function(source, args, rawCommand)
    local playerId, lobbieId = nil, 0
    if type(args[1]) == 'string' then playerId = tonumber(args[1]) end
    if type(args[2]) == 'string' then lobbieId = tonumber(args[2]) or 0 end
    if playerId ~= nil then
        if IsPlayerACheater(playerId) then
            Lobbies:change(playerId, SV_Config.CheatLobbie, false, "strict")
        elseif not IsPlayerACheater(playerId) then
            Lobbies:change(playerId, lobbieId, true, "inactive")
        end
    end
end, true)

RegisterCommand("deletelobbie", function(source, args, rawCommand)
    local src = source
    local filename = nil
    if type(args[1]) == 'string' then filename = tostring(args[1]) end
    if filename ~= nil then Lobbies:deleteFile(src, filename) end
end, true)