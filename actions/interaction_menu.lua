local sm = _G.SharpMod
local cm = sm.cheat_manager

local options = {
    {
        text = 'Toggle instant interaction',
        callback = function() sm:require('utils/interactionspeed'):toggle_instant() end
    },
    {
        text = 'Toggle no bag cooldown',
        callback = function() cm.no_bag_cooldown:toggle() end
    },
    {
        text = 'Toggle instant intimidation',
        callback = function() cm.instant_intimidation:toggle() end
    },
    {
        text = 'Open all vaults',
        callback = function() sm:require('utils/interaction'):testopenallvaults() end
    },
    {
        text = 'Open all doors',
        callback = function() sm:require('utils/interaction'):openalldoors() end
    },
    {
        text = 'Barricade all windows',
        callback = function() sm:require('utils/interaction'):barricade_stuff() end
    },
    {
        text = 'Toggle instant drills',
        callback = function() cm.instant_drills:toggle() end
    },
    {
        text = 'Toggle auto-repairing drills',
        callback = function() cm.drill_repair:toggle() end
    },
    {
        text = 'Close',
        is_cancel_button = true
    }
}

QuickMenu:new('SharpMod', 'Interaction menu', options):Show()
