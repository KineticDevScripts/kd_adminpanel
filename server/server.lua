ESX = exports["es_extended"]:getSharedObject()

local playerSettings = {} 

MySQL.ready(function()
    Wait(1000)
    local success, error = pcall(MySQL.scalar.await, 'SELECT 1 FROM `kd_bans`')

    if not success then
        MySQL.query([[
            CREATE TABLE `kd_bans` (
                `author` varchar(40) DEFAULT NULL,
                `player` varchar(40) DEFAULT NULL,
                `license` varchar(50) DEFAULT NULL,
                `ip` varchar(25) DEFAULT NULL,
                `discord` varchar(40) DEFAULT NULL,
                `reason` varchar(100) DEFAULT NULL,
                `ban_time` int(50) NOT NULL,
                `exp_time` varchar(40) NOT NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
    end

    if not success then
        print('^2[success]^7 database was created successfully!')
    end
end)

ESX.RegisterServerCallback('kd_adminpanel:checkGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if checkGroup(source, false) then
        cb(true, group)
    else 
        cb(false)
    end
end)

function checkGroup(player, doAction)
    local xPlayer = ESX.GetPlayerFromId(player)
    local playerGroup = xPlayer.getGroup()

    if Config.groups[playerGroup] then
        return true
    end

    if doAction then
        xPlayer.kick(L('notify.error.notAdmin'))
    end

    return false
end

function sendLog(timestamp, action, admin, target, details)
    TriggerClientEvent('kd_adminpanel:addLog', -1, timestamp, action, admin, target, details)
end

function loadSettings()
    local file = LoadResourceFile(GetCurrentResourceName(), "data/player-settings.json")
    if file then
        playerSettings = json.decode(file) or {}
    end
end

function saveSettings()
    SaveResourceFile(GetCurrentResourceName(), "data/player-settings.json", json.encode(playerSettings, { indent = true }), -1)
end

RegisterNetEvent("kd_adminpanel:getPlayerSettings")
AddEventHandler("kd_adminpanel:getPlayerSettings", function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    if playerSettings[identifier] then
        TriggerClientEvent("kd_adminpanel:sendPlayerSettings", src, playerSettings[identifier])
    else
        -- Default settings
        playerSettings[identifier] = Config.defaultSettings
        TriggerClientEvent("kd_adminpanel:sendPlayerSettings", src, playerSettings[identifier])
    end
end)

RegisterNetEvent("kd_adminpanel:savePlayerSettings")
AddEventHandler("kd_adminpanel:savePlayerSettings", function(newSettings)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    playerSettings[identifier] = newSettings
    saveSettings()
end)

RegisterNetEvent('kd_adminpanel:getOnlinePlayers')
AddEventHandler('kd_adminpanel:getOnlinePlayers', function()
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            table.insert(players, {
                id = playerId,
                name = xPlayer.getName(),
                job = xPlayer.getJob().label,
                ping = GetPlayerPing(playerId)
            })
        end
    end
    TriggerClientEvent('kd_adminpanel:sendOnlinePlayers', source, players)
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

RegisterNetEvent("kd_adminpanel:selfRevive")
AddEventHandler("kd_adminpanel:selfRevive", function()
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Self Revive', GetPlayerName(src), 'None', 'Admin Revived Themself')
        Utils.notify("Success", L('notify.success.selfRevive'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:selfHeal")
AddEventHandler("kd_adminpanel:selfHeal", function()
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Self Heal', GetPlayerName(src), 'None', 'Admin Healed Themself')
        Utils.notify("Success", L('notify.success.selfHeal'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:giveSelfMoney")
AddEventHandler("kd_adminpanel:giveSelfMoney", function(account, amount)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        if account == 'money' then
            sendLog(timestamp, 'Self Money', GetPlayerName(source), 'None', 'Admin Gave Themself $'..lib.math.groupdigits(amount, ','))
            xPlayer.addAccountMoney(account, amount)
            Utils.notify("Success", L('notify.success.selfMoney'):format(lib.math.groupdigits(amount, ',')), 'success', source)
        elseif account == 'bank' then
            sendLog(timestamp, 'Self Bank', GetPlayerName(source), 'None', 'Admin Added $'..lib.math.groupdigits(amount, ',')..' To Their Bank Account')
            xPlayer.addAccountMoney(account, amount)
            Utils.notify("Success", L('notify.success.selfBank'):format(lib.math.groupdigits(amount, ',')), 'success', source)
        else
            Utils.notify("Error", L('notify.error.invalidAccountType'), 'error', source)
        end
    end
end)

RegisterNetEvent("kd_adminpanel:giveSelfItem")
AddEventHandler("kd_adminpanel:giveSelfItem", function(item, amount)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        if xPlayer.canCarryItem(item, amount) then
            xPlayer.addInventoryItem(item, amount)
            sendLog(timestamp, 'Self Item', GetPlayerName(source), 'None', 'Admin Gave Themself '..amount..'x '..item)
            Utils.notify("Success", L('notify.success.selfItem'):format(amount, item), 'success', source)
        else
            Utils.notify("Error", L('notify.error.inventoryFull'), 'error', source)
        end
    end
end)

RegisterNetEvent("kd_adminpanel:toggleNoClip")
AddEventHandler("kd_adminpanel:toggleNoClip", function()
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Toggle NoClip', GetPlayerName(source), 'None', 'Admin Has Toggled NoClip')
        Utils.notify("Success", L('notify.success.toggleNoClip'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:toggleInvisibility")
AddEventHandler("kd_adminpanel:toggleInvisibility", function()
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Toggle Invisibility', GetPlayerName(source), 'None', 'Admin Has Toggled Invisibility')
        Utils.notify("Success", L('notify.success.toggleInvisibility'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:toggleGodMode")
AddEventHandler("kd_adminpanel:toggleGodMode", function()
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Toggle GodMode', GetPlayerName(source), 'None', 'Admin Has Toggled GodMode')
        Utils.notify("Success", L('notify.success.toggleGodMode'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:spawnCar")
AddEventHandler("kd_adminpanel:spawnCar", function(model)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Spawned', GetPlayerName(source), 'None', 'Admin Has Spawned: '..model)
        Utils.notify("Success", L('notify.success.spawnCar'):format(model), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deleteVehicle")
AddEventHandler("kd_adminpanel:deleteVehicle", function(model)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Deleted', GetPlayerName(source), 'None', 'Admin Has Deleted Their Vehicle')
        Utils.notify("Success", L('notify.success.deleteVehicle'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:repairVehicle")
AddEventHandler("kd_adminpanel:repairVehicle", function(model)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Repaired', GetPlayerName(source), 'None', 'Admin Has Repaired Their Vehicle')
        Utils.notify("Success", L('notify.success.repairVehicle'), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:unbanPlayer")
AddEventHandler("kd_adminpanel:unbanPlayer", function(license)
    if checkGroup(source, true) then
        local src = source
        local xPlayer = ESX.GetPlayerFromIdentifier(license)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Player Unbanned', GetPlayerName(source), xPlayer.getName(), 'Admin Unbanned Player')
        Utils.notify("Success", L('notify.success.unbanPlayer'):format(license), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:announcement")
AddEventHandler("kd_adminpanel:announcement", function(msg)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Announcement', GetPlayerName(source), 'None', 'Admin Announcement: '..msg)
        Utils.notify("Success", L('notify.success.announcement'), 'success', source)
    
        Utils.announcement(msg)
    end
end)

RegisterNetEvent("kd_adminpanel:deleteVehicles")
AddEventHandler("kd_adminpanel:deleteVehicles", function(vehAmount)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Vehicle Wipe', GetPlayerName(source), 'None', 'Admin Has Wiped '..vehAmount..'x Unoccupied Vehicles')
        Utils.notify("Success", L('notify.success.carWipe'):format(vehAmount), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deleteObjects")
AddEventHandler("kd_adminpanel:deleteObjects", function(objAmount)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Object Wipe', GetPlayerName(source), 'None', 'Admin Has Wiped '..objAmount..'x Objects')
        Utils.notify("Success", L('notify.success.objectWipe'):format(objAmount), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:deletePeds")
AddEventHandler("kd_adminpanel:deletePeds", function(pedAmount)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Ped Wipe', GetPlayerName(source), 'None', 'Admin Has Wiped '..pedAmount..'x Peds')
        Utils.notify("Success", L('notify.success.pedWipe'):format(pedAmount), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:kickPlayer")
AddEventHandler("kd_adminpanel:kickPlayer", function(playerId, reason)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        xPlayer.kick(reason)
        sendLog(timestamp, 'Player Kicked', GetPlayerName(source), name, 'Reason: '..reason)
        Utils.notify("Success", L('notify.success.kickPlayer'):format(name, reason), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:banPlayer")
AddEventHandler("kd_adminpanel:banPlayer", function(playerId, reason, time)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        sendLog(timestamp, 'Player Banned', GetPlayerName(source), name, 'Reason: '..reason..' Time: '..time)
        Utils.notify("Success", L('notify.success.banPlayer'):format(name), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:gotoPlayer")
AddEventHandler("kd_adminpanel:gotoPlayer", function(playerId)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local xSource = ESX.GetPlayerFromId(source)
        local targetCoords = xPlayer.getCoords(true)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        xSource.setCoords(targetCoords)
        sendLog(timestamp, 'Player Goto', GetPlayerName(source), name, 'Admin Goto Player')
        Utils.notify("Success", L('notify.success.gotoPlayer'):format(name), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:bringPlayer")
AddEventHandler("kd_adminpanel:bringPlayer", function(playerId)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local xSource = ESX.GetPlayerFromId(source)
        local targetCoords = xSource.getCoords(true)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        xPlayer.setCoords(targetCoords)
        sendLog(timestamp, 'Player Bring', GetPlayerName(source), name, 'Admin Bring Player')
        Utils.notify("Success", L('notify.success.bringPlayer'):format(name), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:revivePlayer")
AddEventHandler("kd_adminpanel:revivePlayer", function(playerId)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        Utils.revivePlayer(playerId)
        sendLog(timestamp, 'Player Revive', GetPlayerName(source), name, 'Admin Revive Player')
        Utils.notify("Success", L('notify.success.revivePlayer'):format(name), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:healPlayer")
AddEventHandler("kd_adminpanel:healPlayer", function(playerId)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        Utils.healPlayer(playerId)
        sendLog(timestamp, 'Player Heal', GetPlayerName(source), name, 'Admin Heal Player')
        Utils.notify("Success", L('notify.success.healPlayer'):format(name), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:givePlayerItem")
AddEventHandler("kd_adminpanel:givePlayerItem", function(playerId, item, amount)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
    
        xPlayer.addInventoryItem(item, amount)
        sendLog(timestamp, 'Give Player Item', GetPlayerName(source), name, 'Admin Gave Player: '..amount..'x '..item)
        Utils.notify("Success", L('notify.success.givePlayerItem'):format(name, amount, item), 'success', source)
    end
end)

RegisterNetEvent("kd_adminpanel:givePlayerMoney")
AddEventHandler("kd_adminpanel:givePlayerMoney", function(playerId, account, amount)
    if checkGroup(source, true) then
        local src = source
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
        if account == 'money' then
            sendLog(timestamp, 'Give Player Money', GetPlayerName(source), name, 'Admin Gave Player $'..lib.math.groupdigits(amount, ','))
            xPlayer.addAccountMoney(account, amount)
            Utils.notify("Success", L('notify.success.givePlayerMoney'):format(name, lib.math.groupdigits(amount, ',')), 'success', source)
        elseif account == 'bank' then
            sendLog(timestamp, 'Add Player Bank', GetPlayerName(source), name, 'Admin Added $'..lib.math.groupdigits(amount, ',')..' To Player Bank Account')
            xPlayer.addAccountMoney(account, amount)
            Utils.notify("Success", L('notify.success.givePlayerBank'):format(lib.math.groupdigits(amount, ','), name), 'success', source)
        else
            Utils.notify("Error", L('notify.error.invalidAccountType'), 'error', source)
        end
    end
end)

RegisterNetEvent("kd_adminpanel:setPlayerJob")
AddEventHandler("kd_adminpanel:setPlayerJob", function(playerId, job, grade)
    if checkGroup(source, true) then
        local name = GetPlayerName(playerId)
        local xPlayer = ESX.GetPlayerFromId(playerId)
    
        print(grade)
        xPlayer.setJob(job, grade)
        sendLog(timestamp, 'Set Player Job', GetPlayerName(source), name, 'Admin Set Player\'s job to: '..job)
        Utils.notify("Success", ('You have successfully set %s\'s job to %s'):format(name, job), 'success', source)
        Utils.notify("Success", ('An admin has set your job to %s'):format(job), 'success', playerId)
    end
end)

RegisterNetEvent("kd_adminpanel:manageResource")
AddEventHandler("kd_adminpanel:manageResource", function(resource, action)
    if checkGroup(source, true) then
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")

        if action == 'restart' then
            StopResource(resource)
            Wait(2000)
            StartResource(resource)

            sendLog(timestamp, 'Resource Restart', GetPlayerName(source), 'None', 'Resource: '..resource)
            Utils.notify("Success", L('notify.success.restartResource'):format(resource), 'success', source)
        elseif action == 'start' then
            StartResource(resource)

            sendLog(timestamp, 'Resource Start', GetPlayerName(source), 'None', 'Resource: '..resource)
            Utils.notify("Success", L('notify.success.startResource'):format(resource), 'success', source)
        elseif action == 'stop' then
            StopResource(resource)

            sendLog(timestamp, 'Resource Stop', GetPlayerName(source), 'None', 'Resource: '..resource)
            Utils.notify("Success", L('notify.success.stopResource'):format(resource), 'success', source)
        end
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        loadSettings()
        TriggerClientEvent('kd_adminpanel:updatePlayerCount', -1, playerCount)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        saveSettings()
    end
end)
