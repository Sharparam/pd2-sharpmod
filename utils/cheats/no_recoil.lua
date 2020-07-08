return _G.SharpMod.cheat_manager:add('no_recoil', 'No recoil', function()
    _G.SharpMod.backuper:backup('FPCameraPlayerBase.recoil_kick')
    function FPCameraPlayerBase.recoil_kick() end

    _G.SharpMod.backuper:hijack('PlayerCamera.play_shaker',function( orig, self, effect, ... )
        -- These shakers are annoying and disturbs you when sniping with high rate of fire.
        if effect == 'fire_weapon_kick' or effect == 'fire_weapon_rot' then
            return
        end
        return orig(self, effect, ...)
    end)
end, function()
    _G.SharpMod.backuper:restore('FPCameraPlayerBase.recoil_kick')
    _G.SharpMod.backuper:restore('PlayerCamera.play_shaker')
end)
