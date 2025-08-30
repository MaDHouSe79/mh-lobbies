--[[ ===================================================== ]]--
--[[                 MH Lobbies by MaDHouSe                ]]--
--[[ ===================================================== ]]--
local enable = false

local function ChangeRelationship(num)
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_HILLBILLY', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_BALLAS', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_MEXICAN', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_FAMILY', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_MARABUNTE', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_SALVA', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'AMBIENT_GANG_LOST', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'GANG_1', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'GANG_2', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'GANG_9', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'GANG_10', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'PRISONER', 'PLAYER')
    SetRelationshipBetweenGroups(num, 'ZOMBIE', 'PLAYER')
end

function EnableJob()
    if not enable then enable = false end
    ChangeRelationship(1)
end

function DisableJob()
    if enable then enable = false end
end