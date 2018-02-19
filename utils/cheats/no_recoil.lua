return SharpMod.cheat_manager:add('no_recoil', 'No recoil', function()
    SharpMod.backuper:backup('FPCameraPlayerBase.recoil_kick')
    function FPCameraPlayerBase.recoil_kick() end

    SharpMod.backuper:hijack('PlayerCamera.play_shaker',function( orig, self, effect, ... )
        if effect == 'fire_weapon_kick' or effect == 'fire_weapon_rot' then --These shakers are annoying and disturbs you when sniping with high rate of fire.
            return
        end
        return orig(self, effect, ...)
    end)
end, function()
    SharpMod.backuper:restore('FPCameraPlayerBase.recoil_kick')
    SharpMod.backuper:restore('PlayerCamera.play_shaker')
end)
