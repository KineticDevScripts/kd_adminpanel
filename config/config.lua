Config = {
    locale = 'en', -- only en, you can edit or add more in locales folder
    notifyAlign = 'top', -- 'top' or 'top-right' or 'top-left' or 'bottom' or 'bottom-right' or 'bottom-left' or 'center-right' or 'center-left'

    defaultSettings = {
        primaryColor = "#ff0000",
        secondaryColor = "#0d0c0c",
        menuSize = 65, -- recommended default
        menuPosition = { 
            top = 178, -- recommended default
            left = 436 -- recommended default
        } 
    },

    commands = {
        openMenu = {
            enabled = true, -- enable command?
            name = 'adminmenu', -- command name
            keybind = {
                enabled = true, -- enable keybind?
                key = 'F9', -- default key
                help = 'Open the admin panel' -- keybind help
            }
        }
    },

    groups = { -- what groups can access what actions?
        ['admin'] = {
            ['open'] = true,

            -- Self Options
            ['selfRevive'] = true,
            ['selfHeal'] = true,
            ['selfMoney'] = true,
            ['selfItem'] = true,
            ['noClip'] = true,
            ['invisibility'] = true,
            ['godMode'] = true,

            -- Vehicle Options
            ['spawnCar'] = true,
            ['deleteVehicle'] = true,
            ['repairVehicle'] = true,

            -- Server Options
            ['unbanPlayer'] = true,
            ['announcement'] = true,
            ['carWipe'] = true,
            ['objectWipe'] = true,
            ['pedWipe'] = true,

            -- Dev Options
            ['copyCoords'] = true,

            -- Player Options
            ['kickPlayer'] = true,
            ['banPlayer'] = true,
            ['gotoPlayer'] = true,
            ['bringPlayer'] = true,
            ['revivePlayer'] = true,
            ['healPlayer'] = true,
            ['givePlayerItem'] = true,
            ['givePlayerMoney'] = true,
            ['setPlayerJob'] = true,

            -- Resource Options
            ['restartResource'] = true,
            ['startResource'] = true,
            ['stopResource'] = true,
        },

        ['mod'] = {
            ['open'] = true,

            -- Self Options
            ['selfRevive'] = true,
            ['selfHeal'] = true,
            ['noClip'] = true,

            -- Vehicle Options
            ['spawnCar'] = true,
            ['deleteVehicle'] = true,
            ['repairVehicle'] = true,

            -- Server Options
            ['carWipe'] = true,
            ['objectWipe'] = true,
            ['pedWipe'] = true,

            -- Dev Options
            ['copyCoords'] = true,

            -- Player Options
            ['gotoPlayer'] = true,
            ['bringPlayer'] = true,
            ['revivePlayer'] = true,
            ['healPlayer'] = true,
        },
    },

    noClip = { -- NoClip settings
        firstPersonWhileNoclip = true,
        defaultSpeed = 1.0,
        maxSpeed = 12.0,
        key = {
            enable = true,
            default = 'K',
            help = 'press to toggle NoClip'
        },
        controls = {
            decreaseSpeed = 14,  -- Mouse wheel down
            increaseSpeed = 15,  -- Mouse wheel up
            moveFoward = 32,     -- W
            moveBackward = 33,   -- S
            moveLeft = 34,       -- A
            moveRight = 35,      -- D
            moveUp = 44,         -- Q
            moveDown = 46,       -- E
        },
        particle = {
            fxName = 'core',
            effectName = 'ent_dst_elec_fire_sp'
        }
    }
}