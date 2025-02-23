local function handleSpectatePlayer(targetId)
    local src = source
    if type(targetId) ~= 'string' and type(targetId) ~= 'number' then
      return
    end
    targetId = tonumber(targetId)  
      local targetPed = GetPlayerPed(targetId)

      if targetPed == GetPlayerPed(source) then
        return Utils.notify("Error", L('notify.error.selfSpectate'), 'error', source)  
      end

      if not targetPed then
        return
      end
      
      local targetBucket = GetPlayerRoutingBucket(targetId)
      local srcBucket = GetPlayerRoutingBucket(src)
      local sourcePlayerStateBag = Player(src).state
      local name = GetPlayerName(targetId)
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      if srcBucket ~= targetBucket then
        
        if sourcePlayerStateBag.__spectateReturnBucket == nil then
          sourcePlayerStateBag.__spectateReturnBucket = srcBucket
        end
        SetPlayerRoutingBucket(src, targetBucket)
      end

      if checkGroup(source, true) then
        Utils.notify("Success", L('notify.success.spectatePlayer'):format(name), 'success', source)
        sendLog(timestamp, 'Admin Spectate Player', GetPlayerName(source), name, '')
        TriggerClientEvent('kd_adminpanel:client:startSpectate', src, targetId, GetEntityCoords(targetPed))
      end
  end
  
  RegisterNetEvent('kd_adminpanel:server:startSpectate', handleSpectatePlayer)
  
  --- @param currentTargetId number The current target id.
  --- @param isNextPlayer boolean If we should cycle to the next player or not.
  RegisterNetEvent('cycle', function(currentTargetId, isNextPlayer)
    local src = source
  
    local onlinePlayers = GetPlayers()
    
    if #onlinePlayers <= 2 then
      return TriggerClientEvent('cycleFailed', src)
    end
  
    local sourceIndex = tableIndexOf(onlinePlayers, tostring(src))
    table.remove(onlinePlayers, sourceIndex)
  
    local nextTargetId
    local currentTargetServerIndex = tableIndexOf(onlinePlayers, tostring(currentTargetId))
    if currentTargetServerIndex < 0 then
      nextTargetId = onlinePlayers[1]
    else
      if isNextPlayer then
        nextTargetId = onlinePlayers[currentTargetServerIndex + 1] or onlinePlayers[1]
      else
        nextTargetId = onlinePlayers[currentTargetServerIndex - 1] or onlinePlayers[#onlinePlayers]
      end
    end
    handleSpectatePlayer(nextTargetId)
  end)
  
  RegisterNetEvent('kd_adminpanel:spectate:end', function()
      local src = source
      local sourcePlayerStateBag = Player(src).state
      local prevRoutBucket = sourcePlayerStateBag.__spectateReturnBucket
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      if prevRoutBucket then
        SetPlayerRoutingBucket(src, prevRoutBucket)
        sourcePlayerStateBag.__spectateReturnBucket = nil
      end
      
      Utils.notify("Success", L('notify.success.exitSpectate'), 'success', source)  
      sendLog(timestamp, 'Admin Exit Spectate', GetPlayerName(source), 'None', '')
  end)

  lib.callback.register('kd_adminpanel:spectate:screenWebhook', function(source)
    return Logs.webhook
end)

lib.callback.register('kd_adminpanel:spectate:dropPlayer', function(source, target, reason)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

  if checkGroup(source, true) then
    Utils.notify("Success", L('notify.success.kickPlayer'):format(GetPlayerName(target), 'Spectate Menu'), 'success', source) 
    sendLog(timestamp, 'Admin Kick Player', GetPlayerName(source), GetPlayerName(target), 'Admin Kicked Player From Spectate')
    DropPlayer(target, reason)
    return GetPlayerName(target)
  end
end)