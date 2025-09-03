local Functions = {}
Functions.Inventory = {}

if GetResourceState("ox_inventory") ~= 'missing' then
    Functions.Inventory = {

        HasItem = function(item, amount)
            if PlayerData and type(PlayerData.inventory) == "table" then
                for _, itemData in pairs(PlayerData.inventory) do
                    if itemData.name:lower() == item:lower() then
                        return true
                    end
                end
            end
            return false
        end,

        CountItem = function(item)
            local count = 0
            if PlayerData and type(PlayerData.inventory) == "table" then
                for _, itemData in pairs(PlayerData.inventory) do
                    if itemData.name:lower() == item:lower() then
                        count = count + itemData.amount
                    end
                end
            end
            return count
        end,

        LockInventory = function(state)
            if state then
                LocalPlayer.state:set("inv_busy", true, true) -- lock
            else
                LocalPlayer.state:set("inv_busy", false, true) -- unlock
            end
        end,

        RequiredItems = function(items)
            Notify("You don't have a " .. items .. "...", "error", 5000)
        end

    }
elseif GetResourceState("qb-inventory") ~= 'missing' then
    Functions.Inventory = {

        HasItem = function(item, amount)
            return exports['qb-inventory']:HasItem(item, amount)
        end,

        CountItem = function(item)
            local count = 0
            if PlayerData and type(PlayerData.items) == "table" then
                for _, itemData in pairs(PlayerData.items) do
                    if itemData.name:lower() == item:lower() then
                        count = count + itemData.amount
                    end
                end
            end
            return count
        end,

        LockInventory = function(state)
            if state then
                LocalPlayer.state:set("inv_busy", true, true) -- lock
            else
                LocalPlayer.state:set("inv_busy", false, true) -- unlock
            end
        end,

        RequiredItems = function(items, bool)
            TriggerEvent('qb-inventory:client:requiredItems', items, bool)
        end
        
    }
end

-- Do not edit this below
function HasItem(item, amount)
    return Functions.Inventory.HasItem(item, amount)
end

function CountItem(item)
    return Functions.Inventory.CountItem(item)
end

function LockInventory(state)
    return Functions.Inventory.LockInventory(state)
end

function RequiredItems(items, bool)
    return Functions.Inventory.RequiredItems(items, bool)
end
