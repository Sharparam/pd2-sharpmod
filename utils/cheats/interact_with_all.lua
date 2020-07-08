return _G.SharpMod.cheat_manager:add('interact_with_all', 'Interact with everything', function()
    _G.SharpMod.backuper:backup('BaseInteractionExt._has_required_upgrade')
    _G.SharpMod.backuper:backup('BaseInteractionExt._has_required_deployable')
    _G.SharpMod.backuper:backup('BaseInteractionExt.can_interact')

    function BaseInteractionExt._has_required_upgrade() return true end
    function BaseInteractionExt._has_required_deployable() return true end
    function BaseInteractionExt.can_interact() return true end
end, function()
    _G.SharpMod.backuper:restore('BaseInteractionExt._has_required_upgrade')
    _G.SharpMod.backuper:restore('BaseInteractionExt._has_required_deployable')
    _G.SharpMod.backuper:restore('BaseInteractionExt.can_interact')
end)
