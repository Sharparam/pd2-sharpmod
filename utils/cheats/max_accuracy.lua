return _G.SharpMod.cheat_manager:add('max_accuracy', 'Max accuracy', function()
    _G.SharpMod.backuper:backup('NewRaycastWeaponBase._get_spread_from_number')
    function NewRaycastWeaponBase._get_spread_from_number() return 0 end
end, function()
    _G.SharpMod.backuper:restore('NewRaycastWeaponBase._get_spread_from_number')
end)
