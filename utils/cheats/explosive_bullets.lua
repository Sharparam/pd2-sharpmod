return _G.SharpMod.cheat_manager:add('explosive_bullets', 'Explosive bullets', function()
    _G.SharpMod.backuper:hijack('NewRaycastWeaponBase._fire_raycast',function( o, self, ... )
        local old_class = self._bullet_class
        self._bullet_class = InstantExplosiveBulletBase
        local r = o( self, ...)
        self._bullet_class = old_class
        return r
    end)

    if NewShotgunBase then
        _G.SharpMod.backuper:hijack('NewShotgunBase._fire_raycast',function( o, self, ... )
            local old_class = self._bullet_class
            self._bullet_class = InstantExplosiveBulletBase
            local r = o( self, ...)
            self._bullet_class = old_class
            return r
        end)
    end
end, function()
    _G.SharpMod.backuper:restore('NewRaycastWeaponBase._fire_raycast')
    if NewShotgunBase then
        _G.SharpMod.backuper:restore('NewShotgunBase._fire_raycast')
    end
end)
