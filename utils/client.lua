Utils = {
    notify = function(title, msg, type)
        lib.notify({
            title = title,
            description = msg,
            position = 'top',
            type = type
        })
    end,

    revive = function()
        TriggerEvent('kni_ambulancejob:healPlayer', {revive = true})
    end,

    heal = function()
        TriggerEvent('kni_ambulancejob:healPlayer', {heal = true})
    end,

    showTextUI = function(text)
        lib.showTextUI(text)
    end,

    hideTextUI = function()
        lib.hideTextUI()
    end
}