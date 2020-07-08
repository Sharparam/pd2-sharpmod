Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_SharpMod', function()
    local sm = _G.SharpMod
    local log = sm.log

    MenuCallbackHandler.SharpMod_set_debug = function(_, item)
        sm.options.debug = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_set_loglevel = function(_, item)
        local level = tonumber(item:value())
        sm.options.loglevel = level
        sm.log.level = level
    end

    MenuCallbackHandler.SharpMod_set_hidenews = function(_, item)
        sm.options.hide_news = item:value() == 'on'
        if sm.options.hide_news then
            sm:dofile('vendor/hide_news')
        end
    end

    MenuCallbackHandler.SharpMod_set_disableanticheat = function(_, item)
        sm.options.disable_anticheat = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_set_enabledebugmenu = function(_, item)
        sm.options.enable_debug_menu = item:value() == 'on'
        if sm.options.enable_debug_menu then
            sm:dofile('utils/enable_debug_menu')
        end
    end

    MenuCallbackHandler.SharpMod_set_penetratingteleport = function(_, item)
        sm.options.penetrating_teleport = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_set_killcivilians = function(_, item)
        sm.options.kill_civilians = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_set_freepreplanning = function(_, item)
        local enable = item:value() == 'on'
        sm.options.free_preplanning = enable

        if not sm.cheat_manager then return end

        local cheat = sm.cheat_manager.free_preplanning
        if enable then cheat:enable() else cheat:disable() end
    end

    MenuCallbackHandler.SharpMod_set_moneyamount = function(_, item)
        sm.options.money_amount = item:value()
    end

    MenuCallbackHandler.SharpMod_set_ccamount = function(_, item)
        sm.options.coins_amount = item:value()
    end

    MenuCallbackHandler.SharpMod_meth_set_enabled = function(_, item)
        sm.options.meth.enabled = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_meth_set_chat = function(_, item)
        sm.options.meth.chat = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_meth_set_ingredient_hints = function(_, item)
        sm.options.meth.ingredients = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_meth_set_status_hints = function(_, item)
        sm.options.meth.status = item:value() == 'on'
    end

    MenuCallbackHandler.SharpMod_open_waypoint_options = function() end
    MenuCallbackHandler.SharpMod_open_meth_options = function() end
    MenuCallbackHandler.SharpMod_close = function() sm:save_settings() end

    sm:load_settings()

    for k, _ in pairs(sm.options.waypoints) do
        MenuCallbackHandler['SharpMod_waypoints_set_' .. k] = function(_, item)
            local enable = item:value() == 'on'
            sm.options.waypoints[k] = enable
            if sm.waypoints and sm.waypoints.enabled then
                sm.waypoints:disable()
                sm.waypoints:enable()
            end
            log:info('Waypoints for %s turned %s', k, enable and 'on' or 'off')
        end
    end

    MenuHelper:LoadFromJsonFile(sm.base_path .. 'menu/options.json', sm, sm.options)
    MenuHelper:LoadFromJsonFile(sm.base_path .. 'menu/waypoint_options.json', sm, sm.options.waypoints)
    MenuHelper:LoadFromJsonFile(sm.base_path .. 'menu/meth_options.json', sm, sm.options.meth)
end)
