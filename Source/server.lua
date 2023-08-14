
local showingZone = {}

RegisterNetEvent('showVehicle:requestData', function()

    local source = source

    TriggerClientEvent('showVehicle:updateShowingZone', source, showingZone)

end)

RegisterNetEvent('showVehicle:removeShowing', function(showingIdString)
    
    local source = source
    local showing = showingZone[showingIdString]
    if not showing then return end

    if showing.owner ~= source then 
        print('not owner')
        return 
    end


    showingZone[showingIdString] = nil
    TriggerClientEvent('showVehicle:removeZoneId', -1, showingIdString)


end)


RegisterNetEvent('showVehicle:serviceCharge', function(id, vehicleProps)
    local source = source
    local config = Config.serviceCharge[id]
    if not config.total or not config.coords then 
        print('not found config')
        return
    end



    local found = findVehicleExistShow(vehicleProps.model, vehicleProps.plate)
    if found then
        print('vehicle Showing...')
        return
    end

    print('charged: ^2'..config.total..' ^3$^0')


    local show = {}
    show.owner = source
    show.properties = vehicleProps
    show.playerName = GetPlayerName(source)
    showingZone[tostring(id)] = show
    TriggerClientEvent('showVehicle:updateShowingZone', -1, showingZone)
end)

function findAndRemoveByOwner(source)
    for id, show in pairs(showingZone) do
        if show.owner == source then
            table.remove(serverCached, id)
            return
        end
    end
end

function findVehicleExistShow(model, plate)
    for _, show in pairs(showingZone) do
        if show.properties.model == model and show.properties.plate == plate then
            return true
        end
    end
    return false
end



AddEventHandler('playerDropped', function (reason)
    local source = source
    findAndRemoveByOwner(source)
end)