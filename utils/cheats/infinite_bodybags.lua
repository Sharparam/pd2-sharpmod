return SharpMod.cheat_manager:add('infinite_bodybags', 'Infinite body bags', function()
    SharpMod.backuper:backup('PlayerManager.on_used_body_bag')
    function PlayerManager.on_used_body_bag() end
    managers.player:_set_body_bags_amount(17)
end, function()
    SharpMod.backuper:restore('PlayerManager.on_used_body_bag')
end)
