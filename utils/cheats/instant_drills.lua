return SharpMod.cheat_manager:add('instant_drills', 'Instant drills', function()
    SharpMod.backuper:add_clbk('TimerGui.update', function(o, self, ...)
        local current_timer = self._current_timer
        if (type(current_timer) == 'number' and current_timer or tonumber(current_timer) or -1) > 0 then --I'm 100% serious, current_timer can be string!
            self._current_timer = -1
        end
    end, 'insta_drill', 1)
end, function()
    SharpMod.backuper:remove_clbk('TimerGui.update', 'insta_drill', 1)
end)
