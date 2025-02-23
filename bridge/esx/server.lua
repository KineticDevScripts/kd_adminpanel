if not IsESX() then return end

local ESX = exports['es_extended']:getSharedObject()

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
                cash = lib.math.groupdigits(xPlayer.getMoney(), ','),
                bank = lib.math.groupdigits(xPlayer.getAccount('bank').money, ',')
            })
        end
    end
    TriggerClientEvent('kd_adminpanel:sendOnlinePlayers', source, players)
end)

lib.callback.register('kd_adminpanel:checkGroup', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    return group
end)

lib.callback.register('adminMenu:getPlayerInventory', function(source, playerId)
    if not playerId then 
        print("ERROR: No player ID received in callback.")
        return {} 
    end

    local targetPlayer = ESX.GetPlayerFromId(playerId)
    if not targetPlayer then 
        print("ERROR: Player not found for ID:", playerId)
        return {} 
    end

    local playerItems = {}

    for _, item in pairs(targetPlayer.getInventory()) do
        table.insert(playerItems, {
            name = item.name,
            label = item.label,
            count = item.count or 0 
        })
    end

    return playerItems
end)

function checkGroup(player, doAction)
    local xPlayer = ESX.GetPlayerFromId(player)
    local playerGroup = xPlayer.getGroup()

    if Config.groups[playerGroup] then
        return true
    end

    if doAction then
        xPlayer.kick('Not admin')
    end

    return false
end

function getPlayerBySource(source)
    return ESX.GetPlayerFromId(source)
end

function getPlayerByIdentifier(license)
    return ESX.GetPlayerFromIdentifier(license)
end

function getPlayerCharName(player)
    return player.name
end

function addAccountMoney(player, account, amount)
    return player.addAccountMoney(account, amount)
end

function removeAccountMoney(player, account, amount)
    return player.removeAccountMoney(account, amount)
end

function addItem(player, item, amount)
    if player.canCarryItem(item, amount) then
        return player.addInventoryItem(item, amount)
    end
end

function removeItem(player, item, amount)
    return player.removeInventoryItem(item, amount)
end

function setJob(player, job, grade)
    player.setJob(job, grade)
end