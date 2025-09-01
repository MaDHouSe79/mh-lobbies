function Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function GetPlate(vehicle)
    if vehicle == nil then return nil end
    if not DoesEntityExist(vehicle) then return nil end
    return Trim(GetVehicleNumberPlateText(vehicle))
end