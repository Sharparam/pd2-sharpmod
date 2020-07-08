return _G.SharpMod.cheat_manager:add('extreme_firerate', 'Extreme fire-rate', function()
    _G.SharpMod.backuper:backup('NewRaycastWeaponBase.trigger_held')
    function NewRaycastWeaponBase:trigger_held(...) return self:fire(...) end

    _G.SharpMod.backuper:backup('NewRaycastWeaponBase.fire_mode')
    function NewRaycastWeaponBase.fire_mode() -- Crazy as hell shooting.
        return 'auto'
    end
end, function()
    _G.SharpMod.backuper:restore('NewRaycastWeaponBase.trigger_held')
    _G.SharpMod.backuper:restore('NewRaycastWeaponBase.fire_mode')
end)
