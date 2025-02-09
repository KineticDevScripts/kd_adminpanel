local serverUptime = 0

Citizen.CreateThread(function()
	local uptimeMinute, uptimeHour, uptime = 0, 0, ''

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		uptimeMinute = uptimeMinute + 1

		if uptimeMinute == 60 then
			uptimeMinute = 0
			uptimeHour = uptimeHour + 1
		end

		uptime = string.format("%02dh %02dm", uptimeHour, uptimeMinute)
        serverUptime = uptime
	end
end)

RegisterNUICallback('getServerData', function(data, cb)
    local serverData = {
      resourceCount = GetNumResources(),  
      playerCount = GetNumberOfPlayers(), 
      uptime = serverUptime, 
      version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)  
    }
  
    cb(serverData)
end)

RegisterNUICallback('requestPlayers', function(data, cb)
    TriggerServerEvent('kd_adminpanel:getOnlinePlayers') 
end)

RegisterNUICallback('requestResources', function(data, cb)
    TriggerServerEvent('kd_adminpanel:getResources')
end)

RegisterNUICallback("selfRevive", function(data, cb)
    if canUseAction('selfRevive') then 
        Utils.revive()
        TriggerServerEvent('kd_adminpanel:selfRevive')
    end
end)

RegisterNUICallback("selfHeal", function(data, cb)
    if canUseAction('selfHeal') then 
        Utils.heal()
        TriggerServerEvent('kd_adminpanel:selfHeal')
    end
end)

RegisterNUICallback("giveSelfMoney", function(data, cb)
    if canUseAction('selfMoney') then 
        TriggerServerEvent('kd_adminpanel:giveSelfMoney', data.account, data.amount)
    end
end)

RegisterNUICallback("giveSelfItem", function(data, cb)
    if canUseAction('selfItem') then 
        TriggerServerEvent('kd_adminpanel:giveSelfItem', data.item, data.amount)
    end
end)

RegisterNUICallback("toggleNoClip", function(data, cb)
    if canUseAction('noClip') then 
        toggleNoClip()
        TriggerServerEvent('kd_adminpanel:toggleNoClip')
    end
end)

RegisterNUICallback("toggleInvisibility", function(data, cb)
    if canUseAction('invisibility') and not LocalPlayer.state.invisible then
        toggleInvisibility(true)
    else
        toggleInvisibility(false)
    end
    TriggerServerEvent('kd_adminpanel:toggleInvisibility')
    cb("ok")
end)

RegisterNUICallback("toggleGodMode", function(data, cb)
    if canUseAction('godMode') then 
        godMode()
        TriggerServerEvent('kd_adminpanel:toggleGodMode')
    end
end)

RegisterNUICallback("spawnCar", function(data, cb)
    if canUseAction('spawnCar') then 
        local ply = cache.ped
        local coords = GetEntityCoords(ply)
    
        lib.requestModel(data.model, 3000)
    
        local vehicle = CreateVehicle(GetHashKey(data.model), coords.x, coords.y, coords.z, 300.0, 1, 0)
    
        TaskWarpPedIntoVehicle(ply, vehicle, -1)
        TriggerServerEvent('kd_adminpanel:spawnCar', data.model)
    end
end)

RegisterNUICallback("deleteVehicle", function(data, cb)
    if canUseAction('deleteVehicle') then 
        local coords = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    
        if not vehicle or not DoesEntityExist(vehicle) then
            return print('vehicle does not exist')
        end
    
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteEntity(vehicle)
        TriggerServerEvent('kd_adminpanel:deleteVehicle')
    end
end)

RegisterNUICallback("repairVehicle", function(data, cb)
    if canUseAction('repairVehicle') then 
        local coords = GetEntityCoords(cache.ped)
        local vehicle = lib.getClosestVehicle(coords, 5.0, true)
    
        if not vehicle or not DoesEntityExist(vehicle) then
            return print('vehicle does not exist')
        end
    
        SetVehicleUndriveable(vehicle, false)
        SetVehicleFixed(vehicle)
        SetVehicleEngineOn(vehicle, true, true, false)
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleFuelLevel(vehicle, GetVehicleFuelLevel(vehicle))
        TriggerServerEvent('kd_adminpanel:repairVehicle')
    end
end)

RegisterNUICallback("unbanPlayer", function(data, cb)
    if canUseAction('unbanPlayer') then 
        local unban = lib.callback.await('kni_adminmenu:unban', 2000, license)
        TriggerServerEvent('kd_adminpanel:unbanPlayer', data.license)
    end
end)

RegisterNUICallback("announcement", function(data, cb)
    if canUseAction('announcement') then 
        TriggerServerEvent('kd_adminpanel:announcement', data.msg)
    end
end)

RegisterNUICallback("deleteVehicles", function(data, cb)
    if canUseAction('carWipe') then 
        local vehiclePool = GetGamePool('CVehicle')

        for i = 1, #vehiclePool do
            if GetPedInVehicleSeat(vehiclePool[i], -1) == 0 then
                DeleteEntity(vehiclePool[i])
            end
        end
    
        TriggerServerEvent('kd_adminpanel:deleteVehicles', #vehiclePool)
    end
end)

RegisterNUICallback("deleteObjects", function(data, cb)
    if canUseAction('objectWipe') then 
        local objectsPool = GetGamePool('CObject')

        for i = 1, #objectsPool do
            if DoesEntityExist(objectsPool[i]) then
                DeleteEntity(objectsPool[i])
            end
        end
    
        TriggerServerEvent('kd_adminpanel:deleteObjects', #objectsPool)
    end
end)

RegisterNUICallback("deletePeds", function(data, cb)
    if canUseAction('pedWipe') then 
        local pedsPool = GetGamePool('CPed')

        for i = 1, #pedsPool do
            if DoesEntityExist(pedsPool[i]) then
                DeleteEntity(pedsPool[i])
            end
        end
    
        TriggerServerEvent('kd_adminpanel:deletePeds', #pedsPool)
    end
end)

RegisterNUICallback("copyCoords", function(data, cb)
    if canUseAction('copyCoords') then 
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerHeading = GetEntityHeading(playerPed)
    
        local xyz = playerCoords.x..', '..playerCoords.y..', '..playerCoords.z
        local vec3 = 'vec3(' .. playerCoords.x .. ', ' .. playerCoords.y .. ', ' .. playerCoords.z .. ')'
        local vec4 = 'vec4(' .. playerCoords.x .. ', ' .. playerCoords.y .. ', ' .. playerCoords.z .. ', ' .. playerHeading .. ')'
    
        if data.type == 'xyz' then
            lib.setClipboard(xyz)
        elseif data.type == 'vec3' then
            lib.setClipboard(vec3) 
        elseif data.type == 'vec4' then
            lib.setClipboard(vec4) 
        end
    end
end)

RegisterNUICallback("tpToCoords", function(data, cb)
    local playerPed = PlayerPedId()
    local coords = data.coords

    if coords and #coords == 3 then
        local vecCoords = vector3(coords[1], coords[2], coords[3])
        SetEntityCoords(playerPed, vecCoords.x, vecCoords.y, vecCoords.z, false, false, false, false)
        cb("success")
    else
        cb("error")
    end
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    if canUseAction('kickPlayer') then 
        TriggerServerEvent('kd_adminpanel:kickPlayer', data.playerId, data.reason)
    end
end)

RegisterNUICallback('banPlayer', function(data, cb)
    if canUseAction('banPlayer') then 
        local playerBanned = lib.callback.await('kd_adminpanel:banPlayer', 2000, data.playerId, data.time, data.reason)

        if not playerBanned then
            TriggerServerEvent('kd_adminpanel:banPlayer', data.playerId, data.reason, data.time)
        end
    end
end)

RegisterNUICallback('gotoPlayer', function(data, cb)
    if canUseAction('gotoPlayer') then 
        TriggerServerEvent('kd_adminpanel:gotoPlayer', data.playerId)
    end
end)

RegisterNUICallback('bringPlayer', function(data, cb)
    if canUseAction('bringPlayer') then 
        TriggerServerEvent('kd_adminpanel:bringPlayer', data.playerId)
    end
end)

RegisterNUICallback('revivePlayer', function(data, cb)
    if canUseAction('revivePlayer') then 
        TriggerServerEvent('kd_adminpanel:revivePlayer', data.playerId)
    end
end)

RegisterNUICallback('healPlayer', function(data, cb)
    if canUseAction('healPlayer') then 
        TriggerServerEvent('kd_adminpanel:healPlayer', data.playerId)
    end
end)

RegisterNUICallback('givePlayerItem', function(data, cb)
    if canUseAction('givePlayerItem') then 
        TriggerServerEvent('kd_adminpanel:givePlayerItem', data.playerId, data.item, data.amount)
    end
end)

RegisterNUICallback('givePlayerMoney', function(data, cb)
    if canUseAction('givePlayerMoney') then 
        TriggerServerEvent('kd_adminpanel:givePlayerMoney', data.playerId, data.account, data.amount)
    end
end)

RegisterNUICallback("restartResource", function(data, cb)
    if canUseAction('restartResource') then 
        TriggerServerEvent('kd_adminpanel:manageResource', data.resource, 'restart')
    end
end)

RegisterNUICallback("startResource", function(data, cb)
    if canUseAction('startResource') then 
        TriggerServerEvent('kd_adminpanel:manageResource', data.resource, 'start')
    end
end)

RegisterNUICallback("stopResource", function(data, cb)
    if canUseAction('stopResource') then 
        TriggerServerEvent('kd_adminpanel:manageResource', data.resource, 'stop')
    end
end)

RegisterNUICallback("savePlayerSettings", function(data, cb)
    TriggerServerEvent("kd_adminpanel:savePlayerSettings", data)
end)

RegisterNUICallback("closeMenu", function(data, cb)
    LocalPlayer.state.menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hideMenu"
    })
end)
