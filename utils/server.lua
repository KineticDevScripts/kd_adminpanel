Utils = {
    notify = function(title, msg, type, player)
        TriggerClientEvent('ox_lib:notify', player, {
            title = title,
            description = msg,
            position = Config.notifyAlign,
            type = type
        })
    end,

    announcement = function(msg)
        TriggerClientEvent('ox_lib:alertDialog', -1, {
            header = 'An admin has made an announcement',
            content = 'Message: '..msg,
            centered = true,
            cancel = false,
            labels = {
                confirm = 'Close'
            }
        })
    end,

    revivePlayer = function(player)
        local data = {
            revive = true
        }
    
        TriggerClientEvent('kni_ambulancejob:healPlayer', player, data)

        -- exports.wasabi_ambulance:RevivePlayer(player) 
    end,

    healPlayer = function(player)
        local data = {
            heal = true
        }
    
        TriggerClientEvent('kni_ambulancejob:healPlayer', player, data)
    end
}