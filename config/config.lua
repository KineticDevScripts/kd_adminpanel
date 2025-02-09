Config = {
    notifyAlign = 'top', -- 'top' or 'top-right' or 'top-left' or 'bottom' or 'bottom-right' or 'bottom-left' or 'center-right' or 'center-left'

    commands = {
        openMenu = {
            enabled = true,
            name = 'adminmenu',
            keybind = {
                enabled = true,
                key = 'F9',
                help = 'Open the admin panel'
            }
        }
    },

    groups = {
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
            ['revivePlayer'] = true,
            ['healPlayer'] = true,
            ['givePlayerItem'] = true,

            -- Resource Options
            ['restartResource'] = true,
            ['startResource'] = true,
            ['stopResource'] = true,
        }
    },

    noClip = { -- NoClip settings
        firstPersonWhileNoclip = true,
        defaultSpeed = 1.0,
        maxSpeed = 12.0,
        key = {
            enable = true,
            default = 'K'
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