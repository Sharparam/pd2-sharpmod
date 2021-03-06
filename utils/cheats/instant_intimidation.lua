return _G.SharpMod.cheat_manager:add('instant_intimidation', 'Instant intimidation', function()
    local on_intimidated = _G.SharpMod.backuper:backup('CopLogicIdle.on_intimidated')
    local hacked_on_intimidated = function(data, amount, aggressor_unit, ...)
        if aggressor_unit == managers.player:player_unit() then
            CopLogicIdle._surrender(data, amount)
            return true
        else
            return on_intimidated(data, amount, aggressor_unit, ...)
        end
    end
    CopLogicIdle.on_intimidated = hacked_on_intimidated

    _G.SharpMod.backuper:backup('CopLogicAttack.on_intimidated')
    _G.SharpMod.backuper:backup('CopLogicArrest.on_intimidated')
    _G.SharpMod.backuper:backup('CopLogicSniper.on_intimidated')
    CopLogicAttack.on_intimidated = hacked_on_intimidated
    CopLogicArrest.on_intimidated = hacked_on_intimidated
    CopLogicSniper.on_intimidated = hacked_on_intimidated

    -- Shield logic
    _G.SharpMod.backuper:backup('CopBrain._logic_variants.shield.intimidated')
    CopBrain._logic_variants.shield.intimidated = CopLogicIntimidated
    local shield_on_intimidated = _G.SharpMod.backuper:backup('CopLogicIntimidated.on_intimidated')
    function CopLogicIntimidated.on_intimidated(data, amount, aggressor_unit, ...)
        local unit = data.unit
        if unit:base()._tweak_table == "shield" then
            CopLogicIntimidated._do_tied(data, aggressor_unit)
            CopInventory._chk_spawn_shield(unit:inventory(), nil)
        else
            shield_on_intimidated(data, amount, aggressor_unit, ...)
        end
    end
end, function()
    _G.SharpMod.backuper:restore('CopLogicIdle.on_intimidated')
    _G.SharpMod.backuper:restore('CopLogicAttack.on_intimidated')
    _G.SharpMod.backuper:restore('CopLogicArrest.on_intimidated')
    _G.SharpMod.backuper:restore('CopLogicSniper.on_intimidated')
    _G.SharpMod.backuper:restore('CopLogicIntimidated.on_intimidated')
    _G.SharpMod.backuper:restore('CopBrain._logic_variants.shield.intimidated')
end)
