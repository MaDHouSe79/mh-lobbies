local Functions = {}

if GetResourceState("ox_inventory") ~= 'missing' then
    Functions.Inventory = {

        OpenInventory = function(src, type)
            local inventory = MySQL.query.await('SELECT * FROM ox_inventory WHERE name = ?', {type})[1]
            local items = {}
            if inventory ~= nil then
                local data = json.decode(inventory.data)
                for k, v in pairs(data) do
                    items[#items + 1] = {v.name, v.count}
                end
            end
            local mystash = exports.ox_inventory:CreateTemporaryStash({
                label = 'Custom Stash',
                slots = 50,
                maxWeight = 500000,
                items = items
            })
            TriggerClientEvent('ox_inventory:openInventory', src, 'stash', mystash)
        end,

        GetInventory = function(src, name)
            local inventory = MySQL.query.await('SELECT * FROM ox_inventory WHERE name = ?', {name})[1]
            return {
                items = json.decode(inventory.data)
            }
        end,

        SetInventory = function(src, name, type)
            return exports.ox_inventory:RegisterStash(name, "Custom Stash", 50, 5000000, false, nil, nil)
        end,

        AddItem = function(src, item, amount, slot, info, reason)
            return exports.ox_inventory:AddItem(src, item, amount)
        end,

        RemoveItem = function(src, item, amount, slot)
            return exports.ox_inventory:RemoveItem(src, item, amount, slot, false)
        end,

        HasItem = function(src, items, amount)
            return exports.ox_inventory:HasItem(src, items, amount)
        end,

        GetItemByName = function(src, item)
            return exports.ox_inventory:GetItemByName(src, item)
        end,

        CountItem = function(src, item)
            local count = 0
            Player = QBCore.Functions.GetPlayer(src)
            if Player and type(Player.PlayerData.inventory) == "table" then
                for _, itemData in pairs(Player.PlayerData.inventory) do
                    if itemData.name:lower() == item:lower() then
                        count = count + itemData.amount
                    end
                end
            end
            return count
        end
    }

elseif GetResourceState("qb-inventory") ~= 'missing' then
    Functions.Inventory = {

        OpenInventory = function(src, type)
            return exports['qb-inventory']:OpenInventory(src, type, {
                label = 'Custom Stash',
                maxweight = 5000000,
                slots = 50
            })
        end,

        GetInventory = function(src, inventory)
            return exports['qb-inventory']:GetInventory(inventory)
        end,

        SetInventory = function(src, name, items)
            return exports['qb-inventory']:SetInventory(name, items)
        end,

        UpdateStash = function(identifier, items)
            exports['qb-inventory']:UpdateStash(identifier, items)
        end,

        AddItem = function(src, item, amount, slot, info, reason)
            local addReason = reason or 'No reason specified'
            exports['qb-inventory']:AddItem(src, item, amount, slot, info, addReason)
            if type(src) == 'number' then
                TriggerClientEvent('qb-inventory:client:ItemBox', src, Framework.Shared.Items[item], 'add', amount)
            end
        end,

        RemoveItem = function(src, item, amount, slot)
            exports['qb-inventory']:RemoveItem(src, item, amount, slot, false)
            if type(src) == 'number' then
                TriggerClientEvent('qb-inventory:client:ItemBox', src, Framework.Shared.Items[item], 'remove', amount)
            elseif type(src) == 'string' then
                local inventory = exports['qb-inventory']:GetInventory(src)
                SetInventory(src, src, inventory.items)
            end
        end,

        HasItem = function(src, items, amount)
            return exports['qb-inventory']:HasItem(src, items, amount)
        end,

        GetItemByName = function(src, item)
            return exports['qb-inventory']:GetItemByName(src, item)
        end,

        CountItem = function(src, item)
            local count = 0
            Player = GetPlayer(src)
            if Player and type(Player.PlayerData.items) == "table" then
                for _, itemData in pairs(Player.PlayerData.items) do
                    if itemData.name:lower() == item:lower() then
                        count = count + itemData.amount
                    end
                end
            end
            return count
        end
    }

end

-- Do not edit this below.
function OpenInventory(src, type)
    return Functions.Inventory.OpenInventory(src, type)
end

function GetInventory(src, inventory)
    return Functions.Inventory.GetInventory(src, inventory)
end

function SetInventory(src, name, items)
    return Functions.Inventory.SetInventory(src, name, items)
end

function UpdateStash(identifier, items)
    return Functions.Inventory.UpdateStash(identifier, items)
end

function AddItem(src, item, amount, slot, info, reason)
    return Functions.Inventory.AddItem(src, item, amount, slot, info, reason)
end

function RemoveItem(src, item, amount, slot)
    return Functions.Inventory.RemoveItem(src, item, amount, slot)
end

function AddItemToStash(stash, item, amount)
    return Functions.Inventory.AddItemToStash(stash, item, amount)
end

function HasItem(src, item, amount)
    return Functions.Inventory.HasItem(src, item, amount)
end

function GetItemByName(src, item)
    return Functions.Inventory.GetItemByName(src, item)
end

function CountItem(src, item)
    return Functions.Inventory.CountItem(src, item)
end
