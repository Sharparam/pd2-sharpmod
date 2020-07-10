local sm = _G.SharpMod
local log = sm.log

if not sm.waypoints then
    local waypoints = {}
    local waypoint_config = sm.options.waypoints

    local pairs = pairs
    local tostring = tostring
    local white = Color.white

    local tweak_data = tweak_data
    local TD_interaction = tweak_data.interaction
    local TD_E_Specials = tweak_data.equipments.specials

    local managers = managers
    local M_hud = managers.hud
    local M_interaction = managers.interaction

    local ID_PREFIX = 'SharpMod_'

    local DEFAULT_ICON = 'wp_standard'

    local ARMOR_ICON = 'wp_scrubs'
    local BAG_ICON = 'wp_bag'
    local C4_ICON = 'equipment_c4'
    local CRATE_ICON = 'equipment_barcode'
    local DIAMOND_ICON = 'interaction_diamond'
    local DOOR_ICON = 'wp_door'
    local ECM_ICON = 'equipment_ecm_jammer'
    local FOLDER_ICON = 'interaction_patientfile'
    local GOLD_ICON = 'interaction_gold'
    local KEYCARD_ICON = 'equipment_bank_manager_key'
    local METH_INGREDIENT_ICON = 'pd2_methlab'
    local MONEY_BAG_ICON = 'equipment_money_bag'
    local MONEY_WRAP_ICON = 'interaction_money_wrap'
    local WEAPON_ICON = 'ak'

    local replace_icons = {
        caustic_soda = METH_INGREDIENT_ICON,
        crate_loot = CRATE_ICON,
        crate_loot_crowbar = CRATE_ICON,
        gen_pku_artifact_statue = ARMOR_ICON,
        hydrogen_chloride = METH_INGREDIENT_ICON,
        muriatic_acid = METH_INGREDIENT_ICON,
        open_door = DOOR_ICON,
        pickup_keycard = KEYCARD_ICON,
        stash_planks_pickup = 'equipment_planks',
        take_weapons = WEAPON_ICON,
        take_weapons_axis_z = WEAPON_ICON,
        weapon_case = WEAPON_ICON,
        weapon_case_axis_z = WEAPON_ICON,
        [ [[c4]] ] = C4_ICON,
        [ [[.+_armor]] ] = ARMOR_ICON,
        [ [[folder]] ] = FOLDER_ICON
    }

    local temp = {}

    local function is_tweak_enabled(tweak)
        if waypoint_config[tweak] then return true end
        for k, _ in pairs(waypoint_config) do
            if tweak:match(k) then return true end
        end
        return false
    end

    local function get_tweak_icon(tweak)
        local icon = replace_icons[tweak]
        if icon then
            log:debug('Tweak %s has a configured replacement icon %s', tweak, tostring(icon))
            return icon
        end

        for k, replacement in pairs(replace_icons) do
            if tweak:match(k) then
                log:debug(
                    'Tweak %s matches pattern %s which has a configured replacement icon %s',
                    tweak,
                    k,
                    tostring(replacement)
                )
                return replacement
            end
        end

        icon = TD_interaction[tweak].icon
        if icon then
            log:debug('Tweak %s has a default icon %s', tweak, tostring(icon))
            return icon
        end

        local interaction_tweak = TD_interaction[tweak]
        local special_equipment = interaction_tweak.special_equipment or interaction_tweak.special_equipment_block
        local special_tweak = TD_E_Specials[special_equipment]
        icon = special_tweak and special_tweak.icon

        return icon or DEFAULT_ICON
    end

    local function make_id(unit)
        return ID_PREFIX .. tostring(unit:key())
    end

    local function add_waypoint(unit)
        local tweak = unit:interaction().tweak_data
        local icon = get_tweak_icon(tweak)

        if not temp[tweak] and type(waypoint_config[tweak]) == 'nil' then
            log:warn('Waypoint tweak not configured: %s', tweak)
        end

        if is_tweak_enabled(tweak) then
            if not temp[tweak] then
                log:debug('Adding waypoint for %s', tweak)
            end
            local id = make_id(unit)
            M_hud:add_waypoint(id, {
                icon = icon,
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
        if type(obj) ~= 'string' then obj = make_id(obj) end
        M_hud:remove_waypoint(obj)
    end

    function waypoints:enable()
        if self.enabled then return end

        local backuper = sm.backuper
        local backup = backuper.backup
        local ObjectInteractionManager = ObjectInteractionManager

        for _, unit in pairs(M_interaction._interactive_units) do
            add_waypoint(unit)
        end

        local remove_unit = backup(backuper, 'ObjectInteractionManager.remove_unit')
        function ObjectInteractionManager.remove_unit(mgr, obj)
            local result = remove_unit(mgr, obj)
            if obj:interaction().tweak_data ~= "corpse_dispose" then
                clear_waypoint(obj)
            end
            return result
        end

        local add_unit = backup(backuper, 'ObjectInteractionManager.add_unit')
        function ObjectInteractionManager.add_unit(mgr, obj)
            local result = add_unit(mgr, obj)
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
        for _, unit in pairs(M_interaction._interactive_units) do
            clear_waypoint(unit)
        end
        for id, _ in pairs(M_hud._hud.waypoints) do
            id = tostring(id)
            if id:match('^' .. ID_PREFIX) then
                clear_waypoint(id)
            end
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
