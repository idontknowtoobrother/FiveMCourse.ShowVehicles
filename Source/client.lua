ESX = nil
rotation = 360.0
rotationValue = 0.12
showingZone = nil
showingVehicles = {}

CreateThread(function()
    while ESX == nil do
        ESX = exports.es_extended:getSharedObject()
        Wait(100)
    end
end)




CreateThread(function()

    while showingZone == nil do
        Wait(1000)
    end

    local myPlayerId = GetPlayerServerId(PlayerId())

    while true do
        Wait(0)
        
        rotation = rotation > 0 and rotation - rotationValue or 360.0
        local playerCorrds = GetEntityCoords(PlayerPedId())
        for id --[[number]], location in ipairs(Config.location) do
            local strId = tostring(id)
            local showing = showingZone[strId]
            if not showing then
                Modules.drawMarker(28, location.coords, location.radius, location.markerColor)
                local distance = #(playerCorrds - location.coords)
                if distance < location.radius then
                    if IsControlJustPressed(0, Config.interacKeyControlId) then
                        local isDead = IsPedDeadOrDying(PlayerPedId(), 1)
                        if not isDead then
                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                            if vehicle then
                                local isDriver = GetPedInVehicleSeat(vehicle, -1)
                                if isDriver then
                                    local vehicleProps = Functions.copyVehicle(vehicle)
                                    TriggerServerEvent('showVehicle:serviceCharge', id, vehicleProps)
                                else
                                    print('not driver')
                                end
                            else
                                print('not In vehicle')
                            end
                        else
                            print('Dead')
                        end
                    end
                end
            else

                if showing.owner == myPlayerId then
                    local distance = #(playerCorrds - location.coords)
                    if distance < location.radius then
                        if IsControlJustPressed(0,  Config.interacKeyControlId) then
                            TriggerServerEvent('showVehicle:removeShowing', strId)
                        end
                    end
                end
                
                if not showingVehicles[strId] then
                    print('createVehicle, ' .. showing.properties.model .. ' ' .. showing.properties.plate )
                    showingVehicles[strId] = CreateVehicle(showing.properties.model, location.coords, 0.0, false, true)
                    Modules.SetVehicleProperties(showingVehicles[strId], showing.properties)
                    FreezeEntityPosition(showingVehicles[strId], true)
                    SetEntityCollision(showingVehicles[strId], false, true)
                else
                    SetEntityHeading(showingVehicles[strId], rotation)
                    local name = showing.playerName
                    local carLabel = showing.properties.label
                    local carPlate = showing.properties.plate
                    local vehicleAlpha = getAlphaVehicle(location.coords, playerCorrds)
                    Modules.draw3DText(name, carLabel, carPlate, location.coords)
                    SetEntityAlpha(showingVehicles[strId], vehicleAlpha, false)
                end
            end
        end
    end
end)

function getAlphaVehicle(myCoords, targetCoords)
    local distance = #(targetCoords - myCoords)
    local alphaNumber = (1 - (distance / 100)) * 255
    return math.max(0, math.min(255, math.floor(alphaNumber + 0.5))) -- Clamps the value between 0 and 255
end


RegisterNetEvent('showVehicle:updateShowingZone', function(recievedShowingZone)
    showingZone = recievedShowingZone
end)

RegisterNetEvent('showVehicle:removeZoneId', function(showingIdString)
    showingZone[showingIdString] = nil
    if DoesEntityExist(showingVehicles[showingIdString]) then
        DeleteEntity(showingVehicles[showingIdString])
        showingVehicles[showingIdString] = nil
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if NetworkIsPlayerActive(PlayerId()) then
            while showingZone == nil do
                TriggerServerEvent('showVehicle:requestData')
                Wait(1000)
            end
            break
        end
    end
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    for _, vehicle in pairs(showingVehicles) do
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
    end

end)