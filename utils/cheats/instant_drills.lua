return _G.SharpMod.cheat_manager:add('instant_drills', 'Instant drills', function()
    _G.SharpMod.backuper:add_clbk('TimerGui.update', function(_, self)
        local current_timer = self._current_timer
        -- current_timer can be string!
        if (type(current_timer) == 'number' and current_timer or tonumber(current_timer) or -1) > 0 then
            self._current_timer = -1
        end
    end, 'insta_drill', 1)
end, function()
    _G.SharpMod.backuper:remove_clbk('TimerGui.update', 'insta_drill', 1)
end)
