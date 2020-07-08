return _G.SharpMod.cheat_manager:add('drill_repair', 'Auto drill repair', function()
    _G.SharpMod.backuper:hijack('Drill.set_jammed', function(o,self, jammed, ...)
        local r = o(self,jammed, ...)
        local player = managers.player:local_player()
        local unit = self._unit
        if alive(unit) then
            local interaction = unit.interaction
            if interaction then
                interaction = interaction(unit)
            end
            local interact = interaction and interaction.interact
            if interact then
                interact(interaction, player)
            end
        end
        return r
    end)
end, function()
    _G.SharpMod.backuper:restore('Drill.set_jammed')
end)
