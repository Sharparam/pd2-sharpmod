local sm = SharpMod
if sm:ingame() then sm:dofile('actions/ingame_menu') else sm:dofile('actions/outgame_menu') end
