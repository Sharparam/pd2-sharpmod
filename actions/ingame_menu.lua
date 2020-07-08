local sm = _G.SharpMod
local cm = sm.cheat_manager

local menu

local options = {
    {
        text = 'Open all deposit boxes',
        callback = function() sm:dofile('actions/bankbuster') end
    },
    {
        text = 'Secure all loot',
        callback = function() sm:dofile('actions/secure_all') end
    },
    {
        text = 'Carry Stacker',
        callback = function() sm:dofile('actions/carrystacker') end
    },
    {
        text = 'Toggle infinite converts',
        callback = function() cm.infinite_converts:toggle() end
    },
    {
        text = 'Tie down all civilians',
        callback = function() sm:dofile('actions/tie_civilians') end
    },
    {
        text = 'Convert all enemies',
        callback = function() sm:dofile('actions/convert_all') end
    },
    {
        text = 'Kill all NPCs',
        callback = function() sm:dofile('actions/kill_all_npcs') end
    },
    {
        text = 'Toggle debug HUD',
        callback = function() sm:require('utils/debug_hud'):toggle() end
    },
    {
        text = 'Toggle GODMODE',
        callback = function() cm.godmode:toggle() end
    },
    {
        text = 'Enable FUN MODE',
        callback = function() cm:enable_funmode() end
    },
    {
        text = 'Disable FUN MODE',
        callback = function() cm:disable_funmode() end
    },
    {
        text = 'Interaction menu',
        callback = function()
            if menu then menu:Hide() end
            sm:dofile('actions/interaction_menu')
        end
    },
    {
        text = 'Equipment menu',
        callback = function()
            if menu then menu:Hide() end
            sm:dofile('actions/equipment_menu')
        end
    },
    {
        text = 'Close',
        is_cancel_button = true
    }
}

menu = QuickMenu:new('SharpMod', 'Choose an action!', options)
menu:Show()
