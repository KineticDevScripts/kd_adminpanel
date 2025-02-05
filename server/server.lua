ESX = exports["es_extended"]:getSharedObject()

local playerSettings = {}

function sendLog(timestamp, action, admin, target, details)
    TriggerClientEvent('kd_adminpanel:addLog', -1, timestamp, action, admin, target, details)
end

if Config.commands['openMenu'].enabled then
    lib.addCommand(Config.commands['openMenu'].name, {
        help = Config.commands['openMenu'].help,
        params = {},
        restricted = Config.commands['openMenu'].restricted
    }, function(source, args, raw)
        local timestamp = os.date("%Y-%m-%d %H:%M:%S")

        sendLog(timestamp, 'Open Menu', GetPlayerName(source), 'None', 'Menu Accessed By Command')
        TriggerClientEvent("kd_adminpanel:openMenu", source)
    end)
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
        playerSettings[identifier] = {
            primaryColor = "#ff0000",
            secondaryColor = "#0d0c0c",
            menuSize = 70,
            menuPosition = { top = 100, left = 100 }
        }
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

RegisterNetEvent("kd_adminpanel:manageResource")
AddEventHandler("kd_adminpanel:manageResource", function(resource, action)
    if action == 'restart' then
        restartResource(resource)
    elseif action == 'start' then
        StartResource(resource)
    elseif action == 'stop' then
        StopResource(resource)
    end
end)

RegisterNetEvent("kd_adminpanel:kickPlayer")
AddEventHandler("kd_adminpanel:kickPlayer", function(playerId, reason)
    local name = GetPlayerName(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    --xPlayer.kick(reason)
    print('kicked '..name..' for '..reason)
end)

RegisterNetEvent("kd_adminpanel:gotoPlayer")
AddEventHandler("kd_adminpanel:gotoPlayer", function(playerId)
    local name = GetPlayerName(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local xSource = ESX.GetPlayerFromId(source)
    local targetCoords = xPlayer.getCoords(true)

    xSource.setCoords(targetCoords)
end)

RegisterNetEvent("kd_adminpanel:revivePlayer")
AddEventHandler("kd_adminpanel:revivePlayer", function(playerId)
    local name = GetPlayerName(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    xPlayer.triggerEvent('kni_ambulancejob:healPlayer', {revive = true})
end)

RegisterNetEvent("kd_adminpanel:healPlayer")
AddEventHandler("kd_adminpanel:healPlayer", function(playerId)
    local name = GetPlayerName(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    xPlayer.triggerEvent('kni_ambulancejob:healPlayer', {heal = true})
end)

RegisterNetEvent("kd_adminpanel:givePlayerItem")
AddEventHandler("kd_adminpanel:givePlayerItem", function(playerId, item, amount)
    local name = GetPlayerName(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    xPlayer.addInventoryItem(item, amount)
end)

RegisterNetEvent("kd_adminpanel:selfRevive")
AddEventHandler("kd_adminpanel:selfRevive", function(source)
    print('add webhook on server')
end)

RegisterNetEvent("kd_adminpanel:selfHeal")
AddEventHandler("kd_adminpanel:selfHeal", function(source)
    print('add webhook on server')
end)

RegisterNetEvent("kd_adminpanel:giveSelfMoney")
AddEventHandler("kd_adminpanel:giveSelfMoney", function(amount)
    local src = source
    local name = GetPlayerName(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    sendLog(timestamp, 'Self Money', GetPlayerName(source), 'None', 'Admin Gave Himself $'..lib.math.groupdigits(amount, ','))
    xPlayer.addAccountMoney('money', amount)
end)

local lastPlayerCount = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Check every second to detect changes in player count
        
        local playerCount = #GetPlayers() -- Get total number of players
        if playerCount ~= lastPlayerCount then
            lastPlayerCount = playerCount
            -- Send player count to NUI only when it changes
            TriggerClientEvent('kd_adminpanel:updatePlayerCount', -1, playerCount)
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