AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    MySQL.query("SELECT data_type FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'kd_bans' AND COLUMN_NAME = 'exp_time'", function(result)
        if result[1].data_type == 'int' then
            MySQL.query("ALTER TABLE kd_bans MODIFY COLUMN exp_time varchar(40);", function(id) end)
        end
    end)
end)

local function extractIdentifiers(src)
    local identifiers = { ip = '', discord = '', license = '' }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, 'ip') then
            identifiers.ip = id
        elseif string.find(id, 'discord') then
            identifiers.discord = id
        elseif string.find(id, 'license') then
            identifiers.license = id
        end
    end
    return identifiers
end

local function getBanExpire(currentTime, hours)
    local hour = 3600
    local time = hour * hours
    return currentTime + time
end

local function splitTime(seconds)
    local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

    if seconds <= 0 then
        return 0, 0
    else
        local hours = string.format('%02.f', math.floor(seconds / 3600))
        local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
        local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

        return hours, mins
    end
end

BanPlayer = function(target, time, reason, source)
    local identifiers = extractIdentifiers(target)
    local author = GetPlayerName(source)
    local player = GetPlayerName(target)
    local license = identifiers.license
    local ip = identifiers.ip
    local discord = identifiers.discord
    local reason = reason or ''
    local currentTime = os.time()
    local banExp = getBanExpire(currentTime, time)

    if checkGroup(source, true) then
        MySQL.insert('INSERT INTO kd_bans (author, player, license, ip, discord, reason, ban_time, exp_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {author, player, license, ip, discord, reason, currentTime, banExp}, function(id)
        end)
    
        DropPlayer(target, 'Banned For: '..reason)
    end
end

DisableConnect = function(name, setKickReason, deferrals)
    local player = source
    deferrals.defer()
    Wait(0)
    deferrals.update((L('deferrals.checkingBans')):format(GetCurrentResourceName(), name))
    local info = extractIdentifiers(player)
    local playerIdentifier = info.license
    MySQL.query('SELECT * FROM kd_bans WHERE license = ?', {playerIdentifier}, function(result)
        if result[1] then
            local time = result[1].ban_time
            local expTime = result[1].exp_time
            local timeLeft = math.floor(expTime - os.time())
            if timeLeft < 1 then
                MySQL.query('DELETE FROM kd_bans WHERE license = ?', { playerIdentifier })
                deferrals.done()
            elseif timeLeft > 1 or timeLeft == 1 then
                local hours, minutes = splitTime(timeLeft)
                deferrals.done((L('deferrals.banned')):format(result[1].reason, hours, minutes))
            end
        else
            deferrals.done()
        end
    end)
end

lib.callback.register('kd_adminpanel:getBanList', function(source)
    if checkGroup(source, true) then
        local data
        MySQL.query('SELECT * FROM kd_bans', function(result)
            if result[1] then
                for i=1, #result do
                    local timeLeft
                    timeLeft = result[i].exp_time - os.time()
                    if timeLeft > 0 then
                        if not data then data = {} end
                        data[#data +1] = {
                            name = result[i].player,
                            license = result[i].license,
                            author = result[i].author,
                            reason = result[i].reason,
                            exp_time = result[i].exp_time,
                            time_left = timeLeft
                        }
                    end
                end
            else
                data = {}
            end
        end)
        while not data do Wait() end
        return data
    end
end)

lib.callback.register('kd_adminpanel:banPlayer', function(source, target, time, reason)
    if checkGroup(source, true) then
        return BanPlayer(target, time, reason, source)
    end
end)

lib.callback.register('kd_adminpanel:unban', function(source, targetlicense)
    if checkGroup(source, true) then
        MySQL.query('DELETE FROM kd_bans WHERE license = ?', { targetlicense })

        return true
    end
end)

AddEventHandler('playerConnecting', DisableConnect)