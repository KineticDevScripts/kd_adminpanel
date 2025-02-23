function toggleInvisibility(enabled)
    if canUseAction('invisibility') and enabled and LocalPlayer.state.invisible then return end
    LocalPlayer.state.invisible = enabled
    SetEntityVisible(cache.ped, not enabled)

    if enabled then
        Utils.showTextUI(L('textUI.invisibility'))
    else
        Utils.hideTextUI()
    end
end

function godMode()
    if not canUseAction('godMode') then return end
    LocalPlayer.state.godMode = not LocalPlayer.state.godMode
    
    if LocalPlayer.state.godMode then
        SetPlayerInvincible(PlayerId(), true)
        while LocalPlayer.state.godMode do
            Wait(0)
            Utils.showTextUI(L('textUI.godMode'))
        end
        Utils.hideTextUI()
        SetPlayerInvincible(PlayerId(), false)
    end
end