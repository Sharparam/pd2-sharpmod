return _G.SharpMod.cheat_manager:add('infinite_converts', 'Infinite converts', function()
    PlayerManager:hack_upgrade_value('player', 'convert_enemies_max_minions', 500)
    --hack_upgrade_value(PlayerManager, 'player', 'convert_enemies_health_multiplier', 0.25)
end, function()
    PlayerManager:hack_upgrade_value('player', 'convert_enemies_max_minions')
    --hack_upgrade_value(PlayerManager, 'player', 'convert_enemies_health_multiplier')
end)
