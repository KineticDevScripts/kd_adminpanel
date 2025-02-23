Locales['en'] = {
    textUI = {
        invisibility = 'Invisibility - **Activated**',
        godMode = 'Godmode - **Activated**',
        noClip = {
            ('**No Clip** -  *Activated*  \n'),
            ('**Controls:**  \n'),
            ('[K] - Exit NoClip  \n'),
            ('[Mousewheel Down] - Decrease Speed  \n'),
            ('[Mousewheel Up] - Increase Speed  \n'),
            ('[W] - Move Forward  \n'),
            ('[S] - Move Backward  \n'),
            ('[A] - Move Left  \n'),
            ('[D] - Move Right  \n'),
            ('[Q] - Move Up  \n'),
            ('[E] - Move Down  \n'),
        },
    },

    banListMenu = {
        title = 'Bans',
        desc = 'Click to view/manage this ban',

        selectedBan = {
            title = 'Ban Management',
            actionsHeader = '⚙️  Ban Actions  ⚙️',
            unBan = 'Unban Player',
            unBanDesc = 'Unban the selected player',

            unBanInput = {
                title = 'Unban Player',
                desc = 'Are you sure you want to unban %s?'
            },

            banInfo = {
                header = 'ℹ️  Ban Info  ℹ️',
                name = 'Name: %s',
                license = 'Licese: %s',
                bannedBy = 'Banned By: %s',
                bannedFor = 'Banned For: %s',
                timeLeft = 'Time Left: %s hours and %s minutes'
            }
        }
    },
    
    notify = {
        success = {
            selfRevive = 'You have successfully revived yourself!',
            selfHeal = 'You have successfully healed yourself!',
            selfMoney = 'You have successfully gave yourself $%s in cash!',
            selfBank = 'You have successfully added $%s to your bank account!',
            selfItem = 'You have successfully gave yourself %sx %s',
            toggleNoClip = 'You have successfully toggled NoClip',
            toggleInvisibility = 'You have successfully toggled Invisibility',
            toggleGodMode = 'You have successfully toggled GodMode',
            spawnCar = 'You have successfully spawned an %s',
            deleteVehicle = 'You have successfully deleted your vehicle',
            repairVehicle = 'You have successfully repaired your vehicle',
            announcement = 'You have successfully made a server wide announcement',
            carWipe = 'You have successfully wiped %sx unoccupied vehicles',
            objectWipe = 'You have successfully wiped %sx objects',
            pedWipe = 'You have successfully wiped %sx peds',
            kickPlayer = 'You have successfully kicked %s for %s',
            banPlayer = 'You have successfully banned %s',
            unbanPlayer = 'You have successfully unbanned %s',
            spectatePlayer = 'You have successfully began spectating %s',
            screenshotPlayer = 'You have successfully taken a screenshot of %s\'s screen',
            exitSpectate = 'You have successfully stopped spectating',
            gotoPlayer = 'You have successfully teleported to %s',
            bringPlayer = 'You have successfully brought %s',
            revivePlayer = 'You have successfully revived %s',
            healPlayer = 'You have successfully healed %s',
            givePlayerMoney = 'You have successfully gave %s $%s in cash',
            givePlayerBank = 'You have successfully added $%s to %s\'s bank account',
            removePlayerMoney = 'You have successfully removed $%s in cash from %s',
            removePlayerBank = 'You have successfully removed $%s from %s\'s bank account',
            givePlayerItem = 'You have successfully gave %s %sx %s',
            removePlayerItem = 'You have successfully removed %sx %s from %s\'s inventory',
            restartResource = 'You have successfully restarted %s',
            startResource = 'You have successfully started %s',
            stopResource = 'You have successfully stopped %s'
        },

        info = {
            noBans = 'No Bans...'
        },

        error = {
            noAccess = 'You do not have access to this feature',
            groupNotAllowed = 'Group: %s is not allowed',
            invalidAccountType = 'Invalid account type!',
            cantUnban = 'Error unbanning %s',
            selfSpectate = 'You cannot spectate yourself!',
        },
    },

    deferrals = {
        checkingBans = '[%s] Hello %s, Checking for bans. . .',
        banned = 'You are Banned From the Server Reason: \'%s\' (Time Left: %s Hours %s Minutes).'
    }
}