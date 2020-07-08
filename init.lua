local orig_log = log

if not _G.SharpMod then
    log('Setting up SharpMod, ModPath = ' .. ModPath)
    local sm = {
        base_path = ModPath,
        data_path = SavePath .. 'sharpmod.json',
        script_extension = '.lua',
        options = {
            debug = false,
            enable_debug_menu = false,
            debughud_draw_drama = true,
            debughud_draw_state = true,
            debughud_console = true,
            debughud_draw_nav = false,
            debughud_additional_esp = true,
            debughud_mission_elements = false,
            debughud_additional_elements = false,
            disable_anticheat = false,
            penetrating_teleport = false,
            coins_amount = 100,
            money_amount = 1000000000,
            free_preplanning = false,
            xray_civ = true,
            xray_civ_r = 0, xray_civ_g = 0, xray_civ_b = 255,
            xray_cops = true,
            xray_cops_r    = 255, xray_cops_g    = 0,   xray_cops_b    = 0,
            xray_special_r = 153, xray_special_g = 50,  xray_special_b = 204,
            xray_sniper_r  = 0,   xray_sniper_g  = 128, xray_sniper_b  = 0,
            xray_cams = true,
            xray_cams_r     = 255, xray_cams_g     = 51,  xray_cams_b     = 0,
            xray_friendly_r = 51,  xray_friendly_g = 204, xray_friendly_b = 255,
            xray_items = true,
            kill_civilians = true,
            waypoints = {
                apply_thermite_paste = true,
                atm_interaction = true,
                bank_note = true,
                big_computer_server = true,
                c4_x1_bag = true,
                caustic_soda = true,
                christmas_present = true,
                crate_loot = true,
                crate_loot_crowbar = true,
                cut_fence = false,
                cut_glass = true,
                diamond_pickup = true,
                diamond_pickup_axis = false,
                elevator_button_roof = true,
                gage_assignment = true,
                gen_pku_artifact = true,
                gen_pku_artifact_statue = true,
                gen_pku_cocaine = true,
                gen_pku_crowbar = true,
                gen_pku_jewelry = true,
                gold_pile = true,
                grab_server = true,
                hack_ipad = true,
                hack_ipad_jammed = true,
                hold_grab_goat = true,
                hold_open_vault = true,
                hold_take_painting = true,
                hold_take_server = true,
                hold_take_server_axis = true,
                hydrogen_chloride = true,
                interaction_ball = true,
                invisible_interaction_checking = true,
                invisible_interaction_open = true,
                iphone_answer = true,
                key = false,
                money_wrap = true,
                money_wrap_single_bundle = true,
                muriatic_acid = true,
                open_from_inside = true,
                open_slash_close_act = false,
                pickup_boards = true,
                pickup_case = true,
                pickup_harddrive = true,
                pickup_keycard = true,
                pickup_keys = true,
                pickup_tablet = true,
                place_flare = true,
                pick_lock_easy_no_skill = false,
                pick_lock_hard_no_skill = false,
                press_take_liquid_nitrogen = false,
                read_barcode_activate = true,
                safe_loot_pickup = true,
                samurai_armor = true,
                security_station = true,
                sewer_manhole = true,
                shaped_sharge = true,
                stash_planks_pickup = true,
                stash_server = true,
                take_chainsaw = true,
                take_confidential_folder = true,
                take_confidential_folder_event = true,
                take_confidential_folder_icc = true,
                take_keys = true,
                take_weapons = true,
                take_weapons_axis_z = true,
                test_interactive_door = true,
                use_bridge = true,
                use_computer = true,
                weapon_case = true,
                weapon_case_axis_z = true
            }
        },
        hooks = {
            ['lib/managers/menumanager'] = { 'options' },
            ['lib/managers/jobmanager'] = { 'utils/jobfix' },
            ['lib/managers/moneymanager'] = { 'utils/moneymanager' },
            ['lib/managers/dialogmanager'] = { 'utils/meth' }
        }
    }

    Color.purple = Color('9932CC')
    Color.labia = Color('E75480')
    Color.gold = Color('FFD700')
    Color.silver = Color('CFCFC4')
    Color.bronze = Color('CD7F32')
    Color.neongreen = Color('39FF14')
    Color.lilac = Color('D891EF')
    Color.brown = Color('6B4423')
    Color.grey = Color('B2BEB5')
    Color.limited = Color('4F7942')
    Color.unlimited = Color('FDEE00')
    Color.pro = Color('7BB661')
    Color.wip = Color('0D98BA')

    local function transfer_options(source, target)
        for k, v in pairs(source) do
            if type(v) == 'table' and type(target[k]) == 'table' then
                transfer_options(v, target[k])
            else
                target[k] = v
            end
        end
    end

    function sm:load_settings()
        local file = io.open(self.data_path, 'r')
        if not file then return end
        local saved = json.decode(file:read('*all'))
        transfer_options(saved, self.options)
        file:close()
    end

    function sm:save_settings()
        local file = io.open(self.data_path, 'w+')
        if not file then return end
        file:write(json.encode(self.options))
        file:close()
    end

    function sm:require(script, add_ext)
        return self:loadscript(script, add_ext)
    end

    function sm:loadscript(script, add_ext)
        local path = self.base_path .. script
        if add_ext ~= false then path = path .. self.script_extension end
        local file = io.open(path, 'rb')

        if not file then
            orig_log('[SharpMod] loadscript: Failed to find file ' .. path)
            return nil
        end

        local exec, err = loadstring(file:read('*all'), path)
        file:close()
        if not exec then orig_log('[SharpMod] loadscript error: ' .. tostring(err)) return end
        local result = { exec() }
        return unpack(result)
    end

    function sm:dofile(script, add_ext)
        local path = self.base_path .. script
        if add_ext ~= false then path = path .. self.script_extension end
        return dofile(path)
    end

    function sm.safecall(func, ...)
        local succ, ret = pcall(func, ...)
        if succ then
            return ret
        else
            orig_log('[SharpMod] ERROR in safecall: %s', ret)
        end
    end

    function sm:ingame()
        if not game_state_machine then return false end
        local current_state = game_state_machine:current_state_name()
        return string.find(current_state, 'game')
    end
    sm.in_game = sm.ingame

    function sm:in_pregame()
        if not game_state_machine then return false end
        local current_state = game_state_machine:current_state_name()
        return string.find(current_state, 'ingame_waiting_for_players')
    end

    function sm:system_message(msg, data)
        if type(data) == 'table' then msg = managers.localization:text(msg, data) end
        managers.chat:feed_system_message(ChatManager.GAME, msg)
    end

    function sm:add_money(value)
        self.log:info('Attempting to add $%d to inventory', value)
        managers.money:_add_to_total(value)
    end

    function sm:add_cc(value)
        self.log:info('Attempting to add %d CC to inventory', value)
        local current = Application:digest_value(managers.custom_safehouse._global.total)
        local future = current + value
        Global.custom_safehouse_manager.total = Application:digest_value(future, true)
    end

    sm.log = sm:require('logging')

    _G.SharpMod = sm
end

local sm = _G.SharpMod
local log = sm.log

sm:load_settings()

if sm.options.loglevel then
    sm.log.level = sm.options.loglevel
end

if not sm.backuper then
    sm.log:debug('Initializing backuper')
    local Backuper = sm:require('vendor/backuper')
    sm.backuper = Backuper:new('SharpMod.backuper')
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_SharpMod", function(loc)
    loc:load_localization_file(_G.SharpMod.base_path .. "loc/english.json")
end)

if sm.options.disable_anticheat then sm:dofile('utils/disable_anticheat') end
if sm.options.enable_debug_menu then sm:dofile('utils/enable_debug_menu') end
if sm.options.hide_news then sm:dofile('vendor/hide_news') end

if GameSetup or sm:in_game() then
    sm:require('utils/cheat_manager')
    if sm.options.free_preplanning and sm:in_pregame()
        then sm.cheat_manager.free_preplanning:enable()
    end
end

log:debug('Required script: %s', RequiredScript)
local required_script = RequiredScript:lower()

if sm.hooks[required_script] then
    for _, script in ipairs(sm.hooks[required_script]) do
        sm.log:info('Loading %s', script)
        sm:dofile(script)
    end
end

log:info('_VERSION == %s', _VERSION)

return sm
