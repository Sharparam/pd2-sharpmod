local sm = SharpMod
local log = sm.log

if not sm.waypoints then
    local waypoints = {}
    local waypoint_config = sm.options.waypoints

    local function in_table(table, value) -- Is element in table
        if type(table) == 'table' then
            for i,x in pairs(table) do
                if x == value then
                    return true
                end
            end
        end
        return false
    end

    local pairs = pairs
    local tostring = tostring
    local white = Color.white
    local insert = table.insert

    local tweak_data = tweak_data
    local TD_interaction = tweak_data.interaction
    local TD_E_Specials = tweak_data.equipments.specials

    local managers = managers
    local M_hud = managers.hud
    local M_interaction = managers.interaction

    local replace_items = {
        pickup_keycard = 'equipment_bank_manager_key',
        crate_loot = 'equipment_barcode',
        crate_loot_crowbar = 'equipment_barcode',
        stash_planks_pickup = 'equipment_planks',
        take_weapons = 'ak',
        take_weapons_axis_z = 'ak',
        weapon_case = 'ak',
        weapon_case_axis_z = 'ak'
    }

    local temp = {}

    local function add_waypoint(unit)
        local tweak = unit:interaction().tweak_data
        local icon = replace_items[tweak] or TD_interaction[tweak].icon

        if not icon then
            local interaction_tweak = TD_interaction[tweak]
            local special_equipment = interaction_tweak.special_equipment or interaction_tweak.special_equipment_block
            local special_tweak = TD_E_Specials[special_equipment]
            icon = special_tweak and special_tweak.icon
        end

        if not temp[tweak] and type(waypoint_config[tweak]) == 'nil' then
            log:warn('Waypoint tweak not configured: %s', tweak)
        end

        if waypoint_config[tweak] then
            if not temp[tweak] then
                log:debug('Adding waypoint for %s', tweak)
            end
            M_hud:add_waypoint(tostring(unit:key()), {
                icon = icon or 'wp_standard',
                distance = true,
                position = unit:position(),
                no_sync = true,
                present_timer = 0,
                state = "present",
                radius = 500,
                color = white,
                blend_mode = "add"
            })
        end

        temp[tweak] = true
    end

    local function clear_waypoint(obj)
        M_hud:remove_waypoint(tostring(obj:key()))
    end

    function waypoints:enable()
        if self.enabled then return end

        local backuper = sm.backuper
        local backup = backuper.backup
        local ObjectInteractionManager = ObjectInteractionManager

        for id, unit in pairs(M_interaction._interactive_units) do
            add_waypoint(unit)
        end

        local remove_unit = backup(backuper, 'ObjectInteractionManager.remove_unit')
        function ObjectInteractionManager:remove_unit(obj)
            local result = remove_unit(self, obj)
            if obj:interaction().tweak_data ~= "corpse_dispose" then
                clear_waypoint(obj)
            end
            return result
        end

        local add_unit = backup(backuper, 'ObjectInteractionManager.add_unit')
        function ObjectInteractionManager:add_unit(obj)
            local result = add_unit(self, obj)
            if obj:interaction().tweak_data ~= "corpse_dispose" then
                add_waypoint(obj)
            end
            return result
        end
        self.enabled = true
        log:info('Waypoints ENABLED')
        log:system('Waypoints ENABLED')
    end

    function waypoints:disable()
        if not self.enabled then return end

        local backuper = sm.backuper
        local restore = backuper.restore
        for id, unit in pairs(M_interaction._interactive_units) do
            clear_waypoint(unit)
        end
        restore(backuper, 'ObjectInteractionManager.remove_unit')
        restore(backuper, 'ObjectInteractionManager.add_unit')
        self.enabled = false
        log:info('Waypoints DISABLED')
        log:system('Waypoints DISABLED')
    end

    function waypoints:toggle()
        if self.enabled then self:disable() else self:enable() end
    end

    sm.waypoints = waypoints
end

sm.waypoints:toggle()
