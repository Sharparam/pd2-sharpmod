local sm = SharpMod
local log = sm.log 'menu'

local current_state = game_state_machine:current_state_name()
log:debug('Current state: %s', current_state)

if sm:in_game() then
    if sm:in_pregame() then
        sm:dofile('actions/pregame_menu')
    else
        sm:dofile('actions/ingame_menu')
    end
else
    sm:dofile('actions/outgame_menu')
end
