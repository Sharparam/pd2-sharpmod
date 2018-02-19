local sm = SharpMod
local cm = sm.cheat_manager

local options = {
    {
        text = 'Toggle infinite cable ties',
        callback = function() cm.infinite_cableties:toggle() end
    },
    {
        text = 'Toggle infinite body bags',
        callback = function() cm.infinite_bodybags:toggle() end
    },
    {
        text = 'Toggle infinite equipment',
        callback = function() cm.infinite_equipment:toggle() end
    },
    {
        text = 'Close',
        is_cancel_button = true
    }
}

QuickMenu:new('SharpMod', 'Equipment', options):Show()
