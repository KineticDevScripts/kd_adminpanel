LocalPlayer.state.menuOpen = false

-- Keybind to toggle the menu
if Config.commands['openMenu'].keybind.enabled then
    local keybind = lib.addKeybind({
        name = 'adminmenu',
        description = Config.commands['openMenu'].keybind.help,
        defaultKey = Config.commands['openMenu'].keybind.key,
        onPressed = function(self)
            LocalPlayer.state.menuOpen = not LocalPlayer.state.menuOpen
            SetNuiFocus(LocalPlayer.state.menuOpen, LocalPlayer.state.menuOpen)
            SendNUIMessage({
                action = LocalPlayer.state.menuOpen and "showMenu" or "hideMenu"
            })
        end
    })
end 

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

-- Send online players
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

RegisterNetEvent('kd_adminpanel:updatePlayerCount')
AddEventHandler('kd_adminpanel:updatePlayerCount', function(playerCount)
    SendNUIMessage({
        action = 'updatePlayerCount',
        playerCount = playerCount
    })
end)

-- Client event to open menu from server side command
RegisterNetEvent("kd_adminpanel:openMenu")
AddEventHandler("kd_adminpanel:openMenu", function(source)
    LocalPlayer.state.menuOpen = not LocalPlayer.state.menuOpen
    SetNuiFocus(LocalPlayer.state.menuOpen, LocalPlayer.state.menuOpen)
    SendNUIMessage({
        action = LocalPlayer.state.menuOpen and "showMenu" or "hideMenu"
    })
end)

-- Fetch player settings when the resource starts
RegisterNetEvent("kd_adminpanel:sendPlayerSettings")
AddEventHandler("kd_adminpanel:sendPlayerSettings", function(settings)
    SendNUIMessage({
        action = "applySettings",
        settings = settings,
    })
end)

-- Request player settings from the server
Citizen.CreateThread(function()
    TriggerServerEvent("kd_adminpanel:getPlayerSettings")
end)