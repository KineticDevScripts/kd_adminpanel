local ScaleformButtons = function(keysTable)
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(10)
    end
    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()

    for btnIndex, keyData in ipairs(keysTable) do
        local btn = GetControlInstructionalButton(0, keyData[2], true)

        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(btnIndex - 1)
        ScaleformMovieMethodAddParamPlayerNameString(btn)
        BeginTextCommandScaleformString("STRING")
        AddTextComponentSubstringKeyboardDisplay(keyData[1])
        EndTextCommandScaleformString()
        EndScaleformMovieMethod()
    end

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()

    return scaleform
end

local  CONTROLS = { exit = Config.spectate.exit.button, screenshot = Config.spectate.screenshot.button, revive = Config.spectate.revive.button, kick = Config.spectate.kick.button}

local spectatorReturnCoords

local isSpectateEnabled = false

local isInTransitionState = false

local storedTargetPed

local storedTargetPlayerId

local storedTargetServerId

local function calculateSpectatorCoords(coords)
    return vec3(coords.x, coords.y, coords.z - 15.0)
end

local function prepareSpectatorPed(enabled)
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, enabled)
    SetEntityVisible(playerPed, not enabled, 0)

    if enabled then
        TaskLeaveAnyVehicle(playerPed, 0, 16)
    end
end

local function collisionTpCoordTransition(coords)
    if not IsScreenFadedOut() then DoScreenFadeOut(500) end
    while not IsScreenFadedOut() do Wait(5) end

    local playerPed = PlayerPedId()
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    local attempts = 0
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Wait(5)
        attempts = attempts + 1
        if attempts > 1000 then
            print('Failed to load collisions')
            error()
        end
    end
end

local function stopSpectating()
    isSpectateEnabled = false
    isInTransitionState = true

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(5) end

    NetworkSetInSpectatorMode(false, nil)
     SetMinimapInSpectatorMode(false, nil)
    if spectatorReturnCoords then
        print('Returning spectator to original coords')
        if not pcall(collisionTpCoordTransition, spectatorReturnCoords) then
            print('collisionTpCoordTransition failed!')
        end
    else
        print('No spectator return coords saved')
    end
    prepareSpectatorPed(false)

    storedTargetPed = nil
    storedTargetPlayerId = nil
    storedTargetServerId = nil
    spectatorReturnCoords = nil

    DoScreenFadeIn(500)
    while IsScreenFadingIn() do Wait(5) end
    isInTransitionState = false

    TriggerServerEvent('kd_adminpanel:spectate:end')
end

local function createSpectatorTeleportThread()
    CreateThread(function()
        local initialTargetServerid = storedTargetServerId
        while isSpectateEnabled and storedTargetServerId == initialTargetServerid do

            if not DoesEntityExist(storedTargetPed) then
                local newPed = GetPlayerPed(storedTargetPlayerId)
                if newPed > 0 then
                    storedTargetPed = newPed
                else
                    stopSpectating()
                    break
                end
            end

            local newSpectateCoords = calculateSpectatorCoords(GetEntityCoords(storedTargetPed))
            SetEntityCoords(PlayerPedId(), newSpectateCoords.x, newSpectateCoords.y, newSpectateCoords.z, 0, 0, 0, false)

            Wait(500)
        end
    end)
end

local getWebhook = function()
    local webhook = lib.callback.await('kd_adminpanel:spectate:screenWebhook', 300)
    return webhook
end

local screenshot = function()
    exports['screenshot-basic']:requestScreenshotUpload(getWebhook(), 'files[]', function(data2)
        local resp = json.decode(data2)
        print(json.encode(resp))
        if not resp or not resp?.attachments?[1]?.proxy_url then
            return print("No webhook Found!")
        else
            TriggerServerEvent('kd_adminpanel:screenshotPlayer', storedTargetServerId)
        end
    end)
end

local keysTable = {
    {'Exit Spectate', CONTROLS.exit},
}

if Config.spectate.screenshot.enabled then
    keysTable[#keysTable+1] = {'Screenshot Player', CONTROLS.screenshot}
end

if Config.spectate.revive.enabled then
    keysTable[#keysTable+1] = {'Revive Player', CONTROLS.revive}
end

if  Config.spectate.kick.enabled then
    keysTable[#keysTable+1] = {'Kick Player', CONTROLS.kick}
end

local function fivemCheckControls(target)
    if Config.spectate.screenshot.enabled and IsControlJustPressed(0, CONTROLS.screenshot)  then
        screenshot()
    end
    if IsControlJustPressed(0, CONTROLS.exit) then
        stopSpectating()
    end
    if Config.spectate.revive.enabled and IsControlJustPressed(0, CONTROLS.revive) then
        TriggerServerEvent('kd_adminpanel:revivePlayer', target)
    end
    if Config.spectate.kick.enabled and IsControlJustPressed(0, CONTROLS.kick) then
        local dropPlayer = lib.callback.await('kd_adminpanel:spectate:dropPlayer', 2000, target, 'Reason replace')
        if dropPlayer then
            
        end
    end
end

local function createInstructionalThreads(ped)
    CreateThread(function()
        local fivemScaleform = ScaleformButtons(keysTable)
        while isSpectateEnabled do
                DrawScaleformMovieFullscreen(fivemScaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end

        SetScaleformMovieAsNoLongerNeeded()
    end)

    CreateThread(function()
        while isSpectateEnabled do
            fivemCheckControls(ped)
            Wait(5)
        end
    end)
end


RegisterNetEvent('cycleFailed', function()
    print('Cycle failed!')
end)

RegisterNetEvent('kd_adminpanel:client:startSpectate', function(targetServerId, targetCoords)
    if isInTransitionState then
        stopSpectating()
    end

    if targetServerId == GetPlayerServerId(PlayerId()) then
        return  
    end
    
    isInTransitionState = true

    storedTargetPed = nil
    storedTargetPlayerId = nil
    storedTargetServerId = nil

    if spectatorReturnCoords == nil then
        local spectatorPed = PlayerPedId()
        spectatorReturnCoords = GetEntityCoords(spectatorPed)
    end
    prepareSpectatorPed(true)

    local coordsUnderTarget = calculateSpectatorCoords(targetCoords)
    if not pcall(collisionTpCoordTransition, coordsUnderTarget) then
        print('collisionTpCoordTransition failed!')
        stopSpectating()
        return
    end

    local targetResolveAttempts = 0
    local resolvedPlayerId = -1
    local resolvedPed = 0
    while (resolvedPlayerId <= 0 or resolvedPed <= 0) and targetResolveAttempts < 300 do
        targetResolveAttempts = targetResolveAttempts + 1
        resolvedPlayerId = GetPlayerFromServerId(targetServerId)
        resolvedPed = GetPlayerPed(resolvedPlayerId)
        Wait(50)
    end

    if (resolvedPlayerId <= 0 or resolvedPed <= 0) then
        print('Failed to resolve target PlayerId or Ped')

        if not pcall(collisionTpCoordTransition, spectatorReturnCoords) then
            print('collisionTpCoordTransition failed!')
        end
        prepareSpectatorPed(false)

        DoScreenFadeIn(500)
        while IsScreenFadedOut() do Wait(5) end

        isInTransitionState = false
        spectatorReturnCoords = nil
        return sendSnackbarMessage('error', 'nui_menu.player_modal.actions.interaction.notifications.spectate_failed', true)
    end

    storedTargetPed = resolvedPed
    storedTargetPlayerId = resolvedPlayerId
    storedTargetServerId = targetServerId

    NetworkSetInSpectatorMode(true, resolvedPed)
        SetMinimapInSpectatorMode(true, resolvedPed)

    isSpectateEnabled = true
    isInTransitionState = false
    
    createSpectatorTeleportThread()
    createInstructionalThreads(targetServerId)

    DoScreenFadeIn(500)
    while IsScreenFadedOut() do Wait(5) end
end)