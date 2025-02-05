RegisterNUICallback('requestPlayers', function(data, cb)
    TriggerServerEvent('kd_adminpanel:getOnlinePlayers')
    cb('ok')
end)

RegisterNUICallback('requestResources', function(data, cb)
    TriggerServerEvent('kd_adminpanel:getResources')
    cb('ok')
end)

RegisterNUICallback('requestResources2', function(data, cb)
    local resourceList = {}

    for i = 0, GetNumResources(), 1 do
        local tablea = {
            name = GetResourceByFindIndex(i)
        }
        
        table.insert(resourceList, tablea)
    end
    cb(resourceList)
end)

RegisterNUICallback('getServerData', function(data, cb)
    -- Fetch the real server data
    local serverData = {
      status = "Online",  -- You can replace this with dynamic data like server status
      playerCount = '1',  -- Get online player count
      uptime = '3 hours 4 minutes',  -- You can use an actual uptime function here
      version = GetCurrentResourceName()  -- This will fetch the resource name (use actual version if you store it)
    }
  
    -- Send the server data back to NUI
    cb(serverData)
  end)

RegisterNUICallback('selectPlayer', function(data, cb)
    print(data)
    cb('ok')
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('kd_adminpanel:kickPlayer', data.playerId, data.reason)
    cb('ok')
end)

RegisterNUICallback('gotoPlayer', function(data, cb)
    TriggerServerEvent('kd_adminpanel:gotoPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('revivePlayer', function(data, cb)
    TriggerServerEvent('kd_adminpanel:revivePlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('healPlayer', function(data, cb)
    TriggerServerEvent('kd_adminpanel:healPlayer', data.playerId)
    cb('ok')
end)

RegisterNUICallback('givePlayerItem', function(data, cb)
    TriggerServerEvent('kd_adminpanel:givePlayerItem', data.playerId, data.item, data.amount)
    cb('ok')
end)

RegisterNUICallback("selfRevive", function(data, cb)
    TriggerEvent('kni_ambulancejob:healPlayer', {revive = true})
    cb("ok")
end)

RegisterNUICallback("selfHeal", function(data, cb)
    TriggerEvent('kni_ambulancejob:healPlayer', {heal = true})
    cb("ok")
end)

RegisterNUICallback("giveSelfMoney", function(data, cb)
    TriggerServerEvent('kd_adminpanel:giveSelfMoney', data.amount)
    cb("ok")
end)

RegisterNUICallback("restartResource", function(data, cb)
    TriggerServerEvent('kd_adminpanel:manageResource', data.resource, 'restart')
    cb("ok")
end)

RegisterNUICallback("startResource", function(data, cb)
    TriggerServerEvent('kd_adminpanel:manageResource', data.resource, 'start')
    cb("ok")
end)

RegisterNUICallback("stopResource", function(data, cb)
    TriggerServerEvent('kd_adminpanel:manageResource', data.resource, 'stop')
    cb("ok")
end)

RegisterNUICallback("savePlayerSettings", function(data, cb)
    TriggerServerEvent("kd_adminpanel:savePlayerSettings", data)
    cb("ok")
end)

RegisterNUICallback("closeMenu", function(data, cb)
    LocalPlayer.state.menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hideMenu"
    })
    cb("ok")
end)