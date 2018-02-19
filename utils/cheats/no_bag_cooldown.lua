return SharpMod.cheat_manager:add('no_bag_cooldown', 'No bag cooldown', function()
    SharpMod.backuper:backup('PlayerMovement.carry_blocked_by_cooldown')
    function PlayerManager.carry_blocked_by_cooldown() return false end
end, function()
    SharpMod.backuper:restore('PlayerMovement.carry_blocked_by_cooldown')
end)
