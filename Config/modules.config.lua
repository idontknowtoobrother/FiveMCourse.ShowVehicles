Modules = {}

Modules.drawMarker = function(id, location, radius, color)
    DrawMarker(
        id, 
        location.x, 
        location.y, 
        location.z-0.98, 
        0, 
        0, 
        0, 
        0, 
        0, 
        0, 
        radius, 
        radius, 
        0.15, 
        color.r, 
        color.g, 
        color.b,
        color.a,
        false, 
        false, -- faceCamera --[[ boolean ]], 
        0, 
        false, -- rotate --[[ boolean ]], 
        nil, 
        nil, 
        nil
    )
end

Modules.SetVehicleProperties = function(vehicle, properties)
    ESX.Game.SetVehicleProperties(vehicle, properties)
end

Modules.draw3DText = function(name, label, plate, coords)
    -- RegisterFontFile(Config.fontName)
    -- local fontId     = RegisterFontId(Config.fontName) or 1

    local fontId = 2
    local myCoords = GetEntityCoords(PlayerPedId())
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist       = GetDistanceBetweenCoords(px, py, pz, coords.x, coords.y, coords.z, 1)
    local scale      = (1 / dist) * 20
    local fov        = (1 / GetGameplayCamFov()) * 100
    scale            = scale * fov
    SetTextScale(0.075 * scale, 0.075 * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    local opc = math.floor(255 / #(coords - myCoords) * 4)
    SetTextColour(255, 255, 255, opc > 255 and 255 or opc)
    SetTextDropshadow(15, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(("~w~%s~n~~y~%s~n~~w~%s"):format(name, label, plate))
    SetDrawOrigin(coords.x, coords.y, coords.z + 0.7, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()

end