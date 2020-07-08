local sm = _G.SharpMod

local options = {
    {
        text = 'Unlock all pre-planning assets',
        callback = function() sm:dofile('actions/all_preplanning') end
    },
    {
        text = 'Close',
        is_cancel_button = true
    }
}

QuickMenu:new('SharpMod', 'Choose an action!', options):Show()
