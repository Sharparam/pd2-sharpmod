local GameSetup = GameSetup
if GameSetup then
    function GameSetup._update_debug_input() end -- Disable debug buttons
end

Global.DEBUG_MENU_ON = true
rawset(getmetatable(Application), "debug_enabled", function() return true end)
