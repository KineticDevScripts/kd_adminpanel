local ESX = exports['es_extended']:getSharedObject()

LocalPlayer.state.menuOpen = false
LocalPlayer.state.invisible = false
LocalPlayer.state.godMode = false
local group

if Config.commands['openMenu'].enabled then
    RegisterCommand(Config.commands['openMenu'].name, function(source, args)
        ESX.TriggerServerCallback('kd_adminpanel:checkGroup', function(canOpen, playerGroup)
            if canOpen then
                group = playerGroup
                if canUseAction('open') then
                    openMenu()
                end
            else
                Utils.notify('Error',L('notify.error.notAdmin'), 'error')
            end
        end)
    end)
end

if Config.commands['openMenu'].keybind.enabled then
    local keybind = lib.addKeybind({
        name = 'adminmenu',
        description = Config.commands['openMenu'].keybind.help,
        defaultKey = Config.commands['openMenu'].keybind.key,
        onPressed = function(self)
            ESX.TriggerServerCallback('kd_adminpanel:checkGroup', function(canOpen, playerGroup)
                if canOpen then
                    group = playerGroup
                    if canUseAction('open') then
                        openMenu()
                    end
                else
                    Utils.notify('Error',L('notify.error.notAdmin'), 'error')
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

RegisterNetEvent("kd_adminpanel:sendPlayerSettings")
AddEventHandler("kd_adminpanel:sendPlayerSettings", function(settings)
    SendNUIMessage({
        action = "applySettings",
        settings = settings,
    })
end)

Citizen.CreateThread(function()
    TriggerServerEvent("kd_adminpanel:getPlayerSettings")
end)

function openMenu()
    if not canUseAction('open') then return end
    LocalPlayer.state.menuOpen = not LocalPlayer.state.menuOpen
    SetNuiFocus(LocalPlayer.state.menuOpen, LocalPlayer.state.menuOpen)
    SendNUIMessage({
        action = LocalPlayer.state.menuOpen and "showMenu" or "hideMenu"
    })
end

function toggleInvisibility(enabled)
    if canUseAction('invisibility') and enabled and LocalPlayer.state.invisible then return end
    LocalPlayer.state.invisible = enabled
    SetEntityVisible(cache.ped, not enabled)

    if enabled then
        lib.showTextUI(L('textUI.invisibility'))
    else
        lib.hideTextUI()
    end
end

function godMode()
    if not canUseAction('godMode') then return end
    LocalPlayer.state.godMode = not LocalPlayer.state.godMode
    
    if LocalPlayer.state.godMode then
        SetPlayerInvincible(PlayerId(), true)
        while LocalPlayer.state.godMode do
            Wait(0)
            lib.showTextUI(L('textUI.godMode'))
        end
        lib.hideTextUI()
        SetPlayerInvincible(PlayerId(), false)
    end
end

function canUseAction(menu)
    if Config.groups[group] then
        if Config.groups[group][menu] then
            return true
        else
            return Utils.notify('Error',L('notify.error.noAccess'), 'error')
        end
    else 
        return Utils.notify('Error',L('notify.error.groupNotAllowed'), 'error')
    end
end