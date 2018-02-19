return SharpMod.cheat_manager:add('interact_with_all', 'Interact with everything', function()
    SharpMod.backuper:backup('BaseInteractionExt._has_required_upgrade')
    SharpMod.backuper:backup('BaseInteractionExt._has_required_deployable')
    SharpMod.backuper:backup('BaseInteractionExt.can_interact')

    function BaseInteractionExt._has_required_upgrade() return true end
    function BaseInteractionExt._has_required_deployable() return true end
    function BaseInteractionExt.can_interact() return true end
end, function()
    SharpMod.backuper:restore('BaseInteractionExt._has_required_upgrade')
    SharpMod.backuper:restore('BaseInteractionExt._has_required_deployable')
    SharpMod.backuper:restore('BaseInteractionExt.can_interact')
end)
