# Fivem Admin Panel

A modern nui admin panel for FiveM servers, allowing admins to easily perform self actions, manage players and resources, and view action logs. The permission system allows specific groups be to be granted access to specific actions.

[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/UzkdTXqarr)

## Preview:

### Light Mode:
![image](https://github.com/user-attachments/assets/708df23e-7f63-4053-a9b4-c2cfa5e83105)

### Dark Mode:
![image](https://github.com/user-attachments/assets/1b649775-470b-4de0-bd64-ac4c025d64da)

## Config:
```lua
Config = {
    locale = 'en', -- locale | you can add more in locales folder

    menu = { -- menu config
        header = { -- header settings
            topText = 'Kinetic Dev', -- top text
            bottomText = 'Fivem Developer', -- bottom text |shows directly under top text
            logo = 'https://r2.fivemanage.com/KQGRRm8DukQthtgazMChN/images/kinetic-3.jpg' -- header logo | shows to left of top and bottom text
        }
    },
    
    commands = { -- commands
        ['adminMenu'] = { -- command to open menu
            enabled = false, -- enable?
            name = 'adminmenu' -- command
        },

        ['banList'] = { -- command to open banlist
            enabled = true, -- enable?
            name = 'banList' -- command
        }
    },

    keys = { -- keybinds
        ['adminMenu'] = { -- keybind for menu
            enabled = true, -- enable?
            desc = 'Open the admin panel (Staff Only)', -- help description
            key = 'F9' -- key
        }
    },
    
    groups = { -- what groups can access what features?
        ['admin'] = {
            -- Open menu
            ['open'] = true,

            -- Admin actions
            ['selfRevive'] = true,
            ['selfHeal'] = true,
            ['selfMoney'] = true,
            ['selfItem'] = true,
            ['noClip'] = true,
            ['invisibility'] = true,
            ['godMode'] = true,
            ['spawnCar'] = true,
            ['deleteVehicle'] = true,
            ['repairVehicle'] = true,
            ['unBanPlayer'] = true,
            ['announcement'] = true,
            ['carWipe'] = true,
            ['objectWipe'] = true,
            ['pedWipe'] = true,
            ['copyCoords'] = true,

            -- Player actions
            ['kickPlayer'] = true,
            ['banPlayer'] = true,
            ['spectatePlayer'] = true,
            ['gotoPlayer'] = true,
            ['bringPlayer'] = true,
            ['revivePlayer'] = true,
            ['healPlayer'] = true,
            ['givePlayerMoney'] = true,
            ['removePlayerMoney'] = true,
            ['setPlayerJob'] = true,
            ['givePlayerItem'] = true,
            ['removePlayerItem'] = true,

            -- Resource actions
            ['restartResource'] = true,
            ['startResource'] = true,
            ['stopResource'] = true,

            -- Server actions
            ['banList'] = true,
        },
    
        ['mod'] = {
            -- Open menu
            ['open'] = true,

            -- Admin actions
            ['selfRevive'] = true,
            ['selfHeal'] = true,
            ['noClip'] = true,
            ['invisibility'] = true,
            ['godMode'] = true,
            ['spawnCar'] = true,
            ['deleteVehicle'] = true,
            ['repairVehicle'] = true,
            ['carWipe'] = true,
            ['objectWipe'] = true,
            ['pedWipe'] = true,
            ['copyCoords'] = true,

            -- Player actions
            ['kickPlayer'] = true,
            ['spectatePlayer'] = true,
            ['gotoPlayer'] = true,
            ['bringPlayer'] = true,
            ['revivePlayer'] = true,
            ['healPlayer'] = true,
            ['setPlayerJob'] = true,
        },
    },

    noClip = { -- NoClip settings
        firstPersonWhileNoclip = true, -- use first person while noclipping?
        defaultSpeed = 1.0, -- default noclip speed
        maxSpeed = 12.0, -- max noclip speed
        key = { -- keybind
            enable = true, -- enable?
            default = 'K', -- key
            help = 'press to toggle NoClip' -- help description
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
        particle = { -- particle when activate noclip | dont touch if not familiar
            fxName = 'core',
            effectName = 'ent_dst_elec_fire_sp'
        }
    },

    spectate = { -- Spectate settings
        screenshot = {
            enabled = true, -- enabled?
            button = 191,   -- ENTER
        },
        revive = {
            enabled = true, -- enabled?
            button = 29,    -- B
        },
        kick = {
            enabled = true, -- enabled?
            Button = 47,    -- G
        },
        exit = {
            button = 194 -- BACKSPACE
        }
    },
}
```

## Features:

### Dashboard:
* View server resource count, online player count, current uptime, and current script version

### Admin Actions:

#### Self Options:
* Self Revive
* Self Heal
* Self Money
* Self Item
* NoClip
* Invisibility
* GodMode

#### Vehicle Options:
* Spawn Car
* Delete Vehicle
* Repair Vehicle

#### Server Options:
* Announcement
* Vehicle Wipe
* Object Wipe
* Ped Wipe

#### Developer Options:
* Copy Coords
* Teleport To Coords

### Online Players/Player Management:

#### Player Options:
* Kick Player
* Ban Player
* Spectate Player
* Goto Player
* Bring Player
* Revive Player
* Heal Player
* Give Player Money
* Remove Player Money

#### Inventory Options:
* Give Player Item
* Remove Player Item

### Resources:
* View And All Current Server Resources
* Restart Resource
* Start Resource
* Stop Resource

### Logs:
* View All Action Logs With Info

### Light/Dark Mode:
* Toggle Between Light And Dark Mode

## Dependencies

* Framework: [ESX](https://github.com/esx-framework/esx_core)/[QB](https://github.com/qbcore-framework/qb-core)
* [ox_lib](https://github.com/overextended/ox_lib)
* [oxmysql](https://github.com/overextended/oxmysql)
* [screenshot-basic](https://github.com/citizenfx/screenshot-basic) | For Spectate Screenshots
