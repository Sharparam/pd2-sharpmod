local sm = SharpMod

local options = {
    {
        text = 'Add money',
        callback = function() sm:add_money(sm.options.money_amount) end
    },
    {
        text = 'Add continental coins',
        callback = function() sm:add_cc(sm.options.coins_amount) end
    },
    {
        text = 'Unlock all items',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('all') end
    },
    {
        text = 'Unlock weapons',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('weapons') end
    },
    {
        text = 'Unlock weapon mods',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('weapon_mods') end
    },
    {
        text = 'Unlock masks',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('masks') end
    },
    {
        text = 'Unlock materials',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('materials') end
    },
    {
        text = 'Unlock textures',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('textures') end
    },
    {
        text = 'Unlock colors',
        callback = function() sm:require('utils/item_unlocker'):unlock_items('colors') end
    },
    {
        text = 'Close',
        is_cancel_button = true
    }
}

QuickMenu:new('SharpMod', 'Choose an action!', options):Show()
