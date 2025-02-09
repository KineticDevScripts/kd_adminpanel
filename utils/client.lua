Utils = {
    notify = function(title, msg, type)
        lib.notify({
            title = title,
            description = msg,
            position = Config.notifyAlign,
            type = type
        })
    end,

    revive = function()
        TriggerEvent('ars_ambulancejob:healPlayer', {revive = true})
    end,

    heal = function()
        TriggerEvent('ars_ambulancejob:healPlayer', {heal = true})
    end
}