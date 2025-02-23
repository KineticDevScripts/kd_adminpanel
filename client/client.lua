local group 
LocalPlayer.state.menuOpen = false
LocalPlayer.state.invisible = false
LocalPlayer.state.godMode = false

if Config.commands['adminMenu'].enabled then
    RegisterCommand(Config.commands['adminMenu'].name, function(source, args)
        lib.callback('kd_adminpanel:checkGroup', false, function(playerGroup)
            group = playerGroup
            if canUseAction('open') and not LocalPlayer.state.menuOpen then
                openMenu()
            end
        end)
    end)
end

if Config.commands['banList'].enabled then
    RegisterCommand(Config.commands['banList'].name, function(source, args)
        lib.callback('kd_adminpanel:checkGroup', false, function(playerGroup)
            group = playerGroup
            if canUseAction('banList') then
                openBanList()
            end
        end)
    end)
end

if Config.keys['adminMenu'].enabled then
    local keybind = lib.addKeybind({
        name = 'adminmenu',
        description = Config.keys['adminMenu'].desc,
        defaultKey = Config.keys['adminMenu'].key,
        onPressed = function(self)
            lib.callback('kd_adminpanel:checkGroup', false, function(playerGroup)
                group = playerGroup
                if canUseAction('open') and not LocalPlayer.state.menuOpen then
                    openMenu()
                end
            end)
        end
    })
end

RegisterNetEvent('kd_adminpanel:sendOnlinePlayers')
AddEventHandler('kd_adminpanel:sendOnlinePlayers', function(players)
    SendNUIMessage({
        action = 'updatePlayerList',
        players = players
    })
end)

RegisterNetEvent('kd_adminpanel:sendResources')
AddEventHandler('kd_adminpanel:sendResources', function(resources)
    SendNUIMessage({
        action = 'updateResourceList',
        resources = resources
    })
end)

RegisterNetEvent('kd_adminpanel:addLog')
AddEventHandler('kd_adminpanel:addLog', function(timestamp, action, admin, target, details)
    SendNUIMessage({
        action = 'updateLogs',
        log = {
            timestamp = timestamp,
            action = action,
            admin = admin,
            target = target,
            details = details 
        }
    })
end)

function openMenu()
    if LocalPlayer.state.menuOpen then return end
    
    if canUseAction('open') then
        LocalPlayer.state.menuOpen = true
    
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "showMenu"
        })
    end
end

function canUseAction(menu)
    if Config.groups[group] then
        if Config.groups[group][menu] then
            return true
        else
            return Utils.notify('Error', L('notify.error.noAccess'), 'error')
        end
    else 
        return Utils.notify('Error', L('notify.error.groupNotAllowed'):format(group), 'error')
    end
end