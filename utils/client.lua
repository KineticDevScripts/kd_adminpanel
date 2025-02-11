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
        TriggerEvent('kni_ambulancejob:healPlayer', {revive = true})
    end,

    heal = function()
        TriggerEvent('kni_ambulancejob:healPlayer', {heal = true})
    end
}