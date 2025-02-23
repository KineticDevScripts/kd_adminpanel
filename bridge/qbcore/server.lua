if not IsQBCore() then return end

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('kd_adminpanel:getOnlinePlayers')
AddEventHandler('kd_adminpanel:getOnlinePlayers', function()
    local players = {}
    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer then
            table.insert(players, {
                id = playerId,
                name = xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname,
                job = xPlayer.PlayerData.job.label,
                cash = lib.math.groupdigits(xPlayer.PlayerData.money.cash, ','),
                bank = lib.math.groupdigits(xPlayer.PlayerData.money.bank, ',')
            })
        end
    end
    TriggerClientEvent('kd_adminpanel:sendOnlinePlayers', source, players)
end)

lib.callback.register('kd_adminpanel:checkGroup', function(source)
    local hasAdmin = QBCore.Functions.HasPermission(source, 'admin')
    local hasMod = QBCore.Functions.HasPermission(source, 'mod')

    if hasAdmin then
        return 'admin'
    elseif hasMod then
        return 'mod'
    else
        return 'user'
    end
end)

-- lib.callback.register('kd_adminpanel:checkGroup', function(source)
--     local permissions = QBCore.Functions.GetPermission(src)
    
--     for group, hasPermission in pairs(permissions) do
--         if hasPermission then
--             return group
--         end
--     end
-- end)

lib.callback.register('adminMenu:getPlayerInventory', function(source, playerId)
    if not playerId then 
        print("ERROR: No player ID received in callback.")
        return {} 
    end

    local targetPlayer = QBCore.Functions.GetPlayer(playerId) 
    if not targetPlayer then 
        print("ERROR: Player not found for ID:", playerId)
        return {} 
    end

    local playerItems = {}

    for _, item in pairs(targetPlayer.PlayerData.items) do
        table.insert(playerItems, {
            name = item.name,
            label = item.label,
            count = item.amount or 0 
        })
    end

    return playerItems
end)

function checkGroup(player, doAction)
    local Player = QBCore.Functions.GetPlayer(player)
    if not Player then return false end

    local playerGroup = QBCore.Functions.GetPermission(Player)

    if Config.groups[playerGroup] then
        return true
    end

    if doAction then
        DropPlayer(Player, 'Not admin')
    end

    return false
end

function getPlayerBySource(source)
    return QBCore.Functions.GetPlayer(source)
end

function getPlayerByIdentifier(license)
    return QBCore.Functions.GetPlayerByCitizenId(license)
end

function getPlayerCharName(Player)
    return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
end

function addAccountMoney(Player, account, amount)
    if account == 'money' then
        return Player.Functions.AddMoney('cash', amount)
    elseif account == 'bank' then
        return Player.Functions.AddMoney('bank', amount)
    end
end

function removeAccountMoney(Player, account, amount)
    if account == 'money' then
        return Player.Functions.RemoveMoney('cash', amount)
    elseif account == 'bank' then
        return Player.Functions.RemoveMoney('bank', amount)
    end
end

function addItem(Player, item, amount)
    return Player.Functions.AddItem(item, amount)
end

function removeItem(player, item, amount)
    return Player.Functions.RemoveItem(item, amount)
end

function setJob(Player, job, group)
    Player.Functions.SetJob(job, grade)
end