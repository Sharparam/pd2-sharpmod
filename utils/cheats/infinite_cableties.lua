local M_player = managers.player
local add_special = M_player.add_special
local set_infinite_special = M_player.set_infinite_special

return _G.SharpMod.cheat_manager:add('infinite_cableties', 'Infinite cable-ties', function()
    set_infinite_special("cable_tie", true)
    --Add 1 more cable in case, if player don't have cable ties yet
    add_special(M_player, { name = "cable_tie", amount = 1 })
end, function()
    set_infinite_special("cable_tie", nil)
end)
