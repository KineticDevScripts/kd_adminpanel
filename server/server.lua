function sendLog(timestamp, action, admin, target, details)
    TriggerClientEvent('kd_adminpanel:addLog', -1, timestamp, action, admin, target, details)
end

RegisterNetEvent("kd_adminpanel:selfRevive")
AddEventHandler("kd_adminpanel:selfRevive", function()
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Self Revive', GetPlayerName(source), 'None', 'Admin Revived Themself')
        Utils.notify("Success", L('notify.success.selfRevive'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:selfHeal")
AddEventHandler("kd_adminpanel:selfHeal", function()
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Self Heal', GetPlayerName(source), 'None', 'Admin Healed Themself')
        Utils.notify("Success", L('notify.success.selfHeal'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:giveSelfMoney")
AddEventHandler("kd_adminpanel:giveSelfMoney", function(account, amount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        if account == 'money' then
            addAccountMoney(getPlayerBySource(source), account, amount)

            sendLog(timestamp, 'Self Money', GetPlayerName(source), 'None', 'Admin Gave Themself $'..lib.math.groupdigits(amount, ','))
            Utils.notify("Success", L('notify.success.selfMoney'):format(lib.math.groupdigits(amount, ',')), 'success', source)
        elseif account == 'bank' then
            addAccountMoney(getPlayerBySource(source), account, amount)

            sendLog(timestamp, 'Self Bank', GetPlayerName(source), 'None', 'Admin Added $'..lib.math.groupdigits(amount, ',')..' To Their Bank Account')
            Utils.notify("Success", L('notify.success.selfBank'):format(lib.math.groupdigits(amount, ',')), 'success', source)
        else
            Utils.notify("Error", L('notify.error.invalidAccountType'), 'error', source)
        end
    end
end)

RegisterNetEvent("kd_adminpanel:giveSelfItem")
AddEventHandler("kd_adminpanel:giveSelfItem", function(item, amount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        addItem(getPlayerBySource(source), item, amount)

        sendLog(timestamp, 'Self Item', GetPlayerName(source), 'None', 'Admin Gave Themself '..amount..'x '..item)
        Utils.notify("Success", L('notify.success.selfItem'):format(amount, item), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:toggleNoClip")
AddEventHandler("kd_adminpanel:toggleNoClip", function()
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Toggle NoClip', GetPlayerName(source), 'None', 'Admin Has Toggled NoClip')
        Utils.notify("Success", L('notify.success.toggleNoClip'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:toggleInvisibility")
AddEventHandler("kd_adminpanel:toggleInvisibility", function()
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Toggle Invisibility', GetPlayerName(source), 'None', 'Admin Has Toggled Invisibility')
        Utils.notify("Success", L('notify.success.toggleInvisibility'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:toggleGodMode")
AddEventHandler("kd_adminpanel:toggleGodMode", function()
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Toggle GodMode', GetPlayerName(source), 'None', 'Admin Has Toggled GodMode')
        Utils.notify("Success", L('notify.success.toggleGodMode'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:spawnCar")
AddEventHandler("kd_adminpanel:spawnCar", function(model)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Spawned', GetPlayerName(source), 'None', 'Admin Has Spawned: '..model)
        Utils.notify("Success", L('notify.success.spawnCar'):format(model), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deleteVehicle")
AddEventHandler("kd_adminpanel:deleteVehicle", function(model)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Deleted', GetPlayerName(source), 'None', 'Admin Has Deleted Their Vehicle')
        Utils.notify("Success", L('notify.success.deleteVehicle'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:repairVehicle")
AddEventHandler("kd_adminpanel:repairVehicle", function(model)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Repaired', GetPlayerName(source), 'None', 'Admin Has Repaired Their Vehicle')
        Utils.notify("Success", L('notify.success.repairVehicle'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:unbanPlayer")
AddEventHandler("kd_adminpanel:unbanPlayer", function(name)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Player Unbanned', GetPlayerName(source), name, 'Admin Unbanned Player')
        Utils.notify("Success", L('notify.success.unbanPlayer'):format(name), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:announcement")
AddEventHandler("kd_adminpanel:announcement", function(msg)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")

        Utils.announcement(msg)
    
        sendLog(timestamp, 'Announcement', GetPlayerName(source), 'None', 'Admin Announcement: '..msg)
        Utils.notify("Success", L('notify.success.announcement'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deleteVehicles")
AddEventHandler("kd_adminpanel:deleteVehicles", function(vehAmount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Wipe', GetPlayerName(source), 'None', 'Admin Has Wiped '..vehAmount..'x Unoccupied Vehicles')
        Utils.notify("Success", L('notify.success.carWipe'):format(vehAmount), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deleteObjects")
AddEventHandler("kd_adminpanel:deleteObjects", function(objAmount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Object Wipe', GetPlayerName(source), 'None', 'Admin Has Wiped '..objAmount..'x Objects')
        Utils.notify("Success", L('notify.success.objectWipe'):format(objAmount), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deletePeds")
AddEventHandler("kd_adminpanel:deletePeds", function(pedAmount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Ped Wipe', GetPlayerName(source), 'None', 'Admin Has Wiped '..pedAmount..'x Peds')
        Utils.notify("Success", L('notify.success.pedWipe'):format(pedAmount), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:kickPlayer")
AddEventHandler("kd_adminpanel:kickPlayer", function(playerId, reason)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        DropPlayer(targetPlayer, reason)
        sendLog(timestamp, 'Player Kicked', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Reason: '..reason)
        Utils.notify("Success", L('notify.success.kickPlayer'):format(getPlayerCharName(targetPlayer), reason), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:banPlayer")
AddEventHandler("kd_adminpanel:banPlayer", function(playerId, reason, time)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Player Banned', GetPlayerName(source), GetPlayerName(playerId), 'Reason: '..reason..' Time: '..time)
        Utils.notify("Success", L('notify.success.banPlayer'):format(GetPlayerName(playerId)), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:gotoPlayer")
AddEventHandler("kd_adminpanel:gotoPlayer", function(playerId)
    if checkGroup(source, true) then
        local targetPlayer = getPlayerBySource(playerId)
        local targetPed = GetPlayerPed(playerId)
        local sourcePed = GetPlayerPed(source)
        local targetCoords = GetEntityCoords(targetPed)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")

        SetEntityCoords(sourcePed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)

        sendLog(timestamp, 'Player Goto', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Goto Player')
        Utils.notify("Success", L('notify.success.gotoPlayer'):format(getPlayerCharName(targetPlayer)), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:bringPlayer")
AddEventHandler("kd_adminpanel:bringPlayer", function(playerId)
    if checkGroup(source, true) then
        local targetPlayer = getPlayerBySource(playerId)
        local targetPed = GetPlayerPed(playerId)
        local sourcePed = GetPlayerPed(source)
        local targetCoords = GetEntityCoords(sourcePed)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")

        SetEntityCoords(targetPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)

        sendLog(timestamp, 'Player Bring', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Bring Player')
        Utils.notify("Success", L('notify.success.bringPlayer'):format(getPlayerCharName(targetPlayer)), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:revivePlayer")
AddEventHandler("kd_adminpanel:revivePlayer", function(playerId)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        Utils.revivePlayer(playerId)
        sendLog(timestamp, 'Player Revive', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Revive Player')
        Utils.notify("Success", L('notify.success.revivePlayer'):format(getPlayerCharName(targetPlayer)), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:healPlayer")
AddEventHandler("kd_adminpanel:healPlayer", function(playerId)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        Utils.healPlayer(playerId)
        sendLog(timestamp, 'Player Heal', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Heal Player')
        Utils.notify("Success", L('notify.success.healPlayer'):format(getPlayerCharName(targetPlayer)), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:givePlayerMoney")
AddEventHandler("kd_adminpanel:givePlayerMoney", function(playerId, account, amount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        if account == 'money' then
            addAccountMoney(targetPlayer, account, amount)

            sendLog(timestamp, 'Player Give Money', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Gave Player $'..lib.math.groupdigits(amount, ','))
            Utils.notify("Success", L('notify.success.givePlayerMoney'):format(getPlayerCharName(targetPlayer), lib.math.groupdigits(amount, ',')), 'success', source)
        elseif account == 'bank' then
            addAccountMoney(targetPlayer, account, amount)

            sendLog(timestamp, 'Player Add Bank', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Added $'..lib.math.groupdigits(amount, ',')..' To Player\'s Bank Account')
            Utils.notify("Success", L('notify.success.givePlayerBank'):format(lib.math.groupdigits(amount, ','), getPlayerCharName(targetPlayer)), 'success', source)
        else
            Utils.notify("Error", L('notify.error.invalidAccountType'), 'error', source)
        end
    end
end)

RegisterNetEvent("kd_adminpanel:removePlayerMoney")
AddEventHandler("kd_adminpanel:removePlayerMoney", function(playerId, account, amount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        if account == 'money' then
            removeAccountMoney(targetPlayer, account, amount)

            sendLog(timestamp, 'Player Remove Money', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Gave Player $'..lib.math.groupdigits(amount, ','))
            Utils.notify("Success", L('notify.success.removePlayerMoney'):format(lib.math.groupdigits(amount, ','), getPlayerCharName(targetPlayer)), 'success', source)
        elseif account == 'bank' then
            removeAccountMoney(targetPlayer, account, amount)

            sendLog(timestamp, 'Player Remove Bank', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Added $'..lib.math.groupdigits(amount, ',')..' To Player\'s Bank Account')
            Utils.notify("Success", L('notify.success.removePlayerBank'):format(lib.math.groupdigits(amount, ','), getPlayerCharName(targetPlayer)), 'success', source)
        else
            Utils.notify("Error", L('notify.error.invalidAccountType'), 'error', source)
        end
    end
end)

RegisterNetEvent("kd_adminpanel:setPlayerJob")
AddEventHandler("kd_adminpanel:setPlayerJob", function(playerId, job, grade)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        setJob(targetPlayer, job, grade)
        print(job..' '..grade)
        sendLog(timestamp, 'Set Player Job', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Set Player\'s job to: '..job)
        Utils.notify("Success", ('You have successfully set %s\'s job to %s'):format(getPlayerCharName(targetPlayer), job), 'success', source)
        Utils.notify("Success", ('An admin has set your job to %s'):format(job), 'success', playerId)
    end
end)

RegisterNetEvent("kd_adminpanel:givePlayerItem")
AddEventHandler("kd_adminpanel:givePlayerItem", function(playerId, item, amount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        addItem(targetPlayer, item, amount)

        sendLog(timestamp, 'Player Give Item', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Gave Player '..amount..'x '..item)
        Utils.notify("Success", L('notify.success.givePlayerItem'):format(getPlayerCharName(targetPlayer), amount, item), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:removePlayerItem")
AddEventHandler("kd_adminpanel:removePlayerItem", function(playerId, item, amount)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local targetPlayer = getPlayerBySource(playerId)
    
        removeItem(targetPlayer, item, amount)

        sendLog(timestamp, 'Player Remove Item', GetPlayerName(source), getPlayerCharName(targetPlayer), 'Admin Removed '..amount..'x '..item..' from player\'s inventory')
        Utils.notify("Success", L('notify.success.removePlayerItem'):format(amount, item, getPlayerCharName(targetPlayer)), 'success', source)
    end
end)

function checkResourceState(res)
    if res then
        local state = GetResourceState(res)
        if state then
            return state
        else
            --print('Error: Resource ' .. res .. ' not found.')
        end
    else
        --print('Error: Please specify a resource name.')
    end
end


RegisterNetEvent('kd_adminpanel:getResources')
AddEventHandler('kd_adminpanel:getResources', function()
    local resourceList = {}

    for i = 0, GetNumResources(), 1 do
        local tablea = {
            name = GetResourceByFindIndex(i),
            state = checkResourceState(GetResourceByFindIndex(i))
        }
        
        table.insert(resourceList, tablea)
    end

    TriggerClientEvent('kd_adminpanel:sendResources', source, resourceList)
end)

RegisterNetEvent("kd_adminpanel:manageResource")
AddEventHandler("kd_adminpanel:manageResource", function(resource, action)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
        local src = source

        if action == 'restart' then
            StopResource(resource)
            Wait(2000)
            StartResource(resource)

            sendLog(timestamp, 'Resource Restart', GetPlayerName(src), 'None', 'Resource: '..resource)
            Utils.notify("Success", L('notify.success.restartResource'):format(resource), 'success', source)
        elseif action == 'start' then
            StartResource(resource)

            sendLog(timestamp, 'Resource Start', GetPlayerName(src), 'None', 'Resource: '..resource)
            Utils.notify("Success", L('notify.success.startResource'):format(resource), 'success', source)
        elseif action == 'stop' then
            StopResource(resource)

            sendLog(timestamp, 'Resource Stop', GetPlayerName(src), 'None', 'Resource: '..resource)
            Utils.notify("Success", L('notify.success.stopResource'):format(resource), 'success', source)
        end
    end
end)