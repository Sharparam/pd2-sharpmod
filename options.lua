Hooks:Add('MenuManagerInitialize', 'MenuManagerInitialize_SharpMod', function(menu_manager)
    local sm = SharpMod
    local log = sm.log
    MenuCallbackHandler.SharpMod_set_debug = function(self, item)
        sm.options.debug = item:value() == 'on'
    end
    MenuCallbackHandler.SharpMod_set_loglevel = function(self, item)
        local level = tonumber(item:value())
        sm.options.loglevel = level
        sm.log.level = level
    end
    MenuCallbackHandler.SharpMod_set_hidenews = function(self, item)
        sm.options.hide_news = item:value() == 'on'
        if sm.options.hide_news then
            sm:dofile('vendor/hide_news')
        end
    end
    MenuCallbackHandler.SharpMod_set_disableanticheat = function(self, item)
        sm.options.disable_anticheat = item:value() == 'on'
    end
    MenuCallbackHandler.SharpMod_set_enabledebugmenu = function(self, item)
        sm.options.enable_debug_menu = item:value() == 'on'
        if sm.options.enable_debug_menu then
            sm:dofile('utils/enable_debug_menu')
        end
    end
    MenuCallbackHandler.SharpMod_set_penetratingteleport = function(self, item)
        sm.options.penetrating_teleport = item:value() == 'on'
    end
    MenuCallbackHandler.SharpMod_set_killcivilians = function(self, item)
        sm.options.kill_civilians = item:value() == 'on'
    end
    MenuCallbackHandler.SharpMod_set_freepreplanning = function(self, item)
        local enable = item:value() == 'on'
        sm.options.free_preplanning = enable

        if not sm.cheat_manager then return end

        local cheat = sm.cheat_manager.free_preplanning
        if enable then cheat:enable() else cheat:disable() end
    end
    MenuCallbackHandler.SharpMod_set_moneyamount = function(self, item)
        sm.options.money_amount = item:value()
    end
    MenuCallbackHandler.SharpMod_set_ccamount = function(self, item)
        sm.options.coins_amount = item:value()
    end
    MenuCallbackHandler.SharpMod_open_waypoint_options = function(self)

    end
    MenuCallbackHandler.SharpMod_close = function(self)
        sm:save_settings()
    end

    sm:load_settings()

    for k, _ in pairs(sm.options.waypoints) do
        MenuCallbackHandler['SharpMod_waypoints_set_' .. k] = function(self, item)
            local enable = item:value() == 'on'
            sm.options.waypoints[k] = enable
            if sm.waypoints and sm.waypoints.enabled then
                sm.waypoints:disable()
                sm.waypoints:enable()
            end
            log:info('Waypoints for %s turned %s', k, enable and 'on' or 'off')
        end
    end

    MenuHelper:LoadFromJsonFile(sm.base_path .. 'options.json', sm, sm.options)
    MenuHelper:LoadFromJsonFile(sm.base_path .. 'waypoint_options.json', sm, sm.options.waypoints)
end)
