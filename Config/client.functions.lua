Functions = {}


Functions.copyVehicle = function(vehicle)

    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    return vehicleProps
end