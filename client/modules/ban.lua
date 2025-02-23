function openBanList()
    if not canUseAction('banList') then return end
    local data = lib.callback.await('kd_adminpanel:getBanList', false)
    banList = {}

    if not data or #data < 1 then
        Utils.notify('Info', L('notify.info.noBans'), 'info')
    else
        for i = 1, #data do
            banList[#banList + 1] = {
                title = data[i].name,
                description = L('banListMenu.desc'),
                onSelect = function()
                    banListHandle(data[i].name, data[i].license, data[i].author, data[i].reason, data[i].time_left)
                end
            }
        end

        lib.registerContext({
            id = 'banList',
            title = L('banListMenu.title'),
            options = banList
        })
        lib.showContext('banList')
    end
end

function banListHandle(name, license, author, reason, length)
    if not canUseAction('banList') then return end
    local hours, mins = splitTime(length)
    local options = {}

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.actionsHeader'),
        icon = '  '
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.unBan'),
        description = L('banListMenu.selectedBan.unBanDesc'),
        onSelect = function()
            local confirm = lib.alertDialog({
                header = L('banListMenu.selectedBan.unBanInput.title'),
                content = L('banListMenu.selectedBan.unBanInput.desc'):format(name),
                centered = true,
                cancel = true
            })
            if confirm == 'confirm' then
                local unban = lib.callback.await('kd_adminpanel:unban', 2000, license)
                if unban then
                    TriggerServerEvent('kd_adminpanel:unbanPlayer', name)
                    Utils.notify('Success', L('notify.success.unbanPlayer'):format(name), 'success')
                else
                    Utils.notify('Error', L('notify.error.cantUnban'):format(name), 'error')
                end
            end
        end
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.banInfo.header'),
        icon = '  '
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.banInfo.name'):format(name)
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.banInfo.license'):format(string.sub(license, 0, -20))
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.banInfo.bannedBy'):format(author)
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.banInfo.bannedFor'):format(reason)
    }

    options[#options + 1] = {
        title = L('banListMenu.selectedBan.banInfo.timeLeft'):format(hours, mins)
    }

    lib.registerContext({
        id = 'banList_handle',
        title = L('banListMenu.selectedBan.title'),
        menu = 'banList',
        options = options
    })
    lib.showContext('banList_handle')
end

function splitTime(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)

    return string.format('%02d', hours), string.format('%02d', mins)
end 