local sm = SharpMod
local log = sm.log

if sm.interaction then return sm.interaction end

sm.interaction = {}

sm:require 'vendor/player_equip_fix'

local function is_server() return Network:is_server() end

local pairs = pairs
local insert = table.insert
local tab_contains = table.contains
local select = select
local executewithdelay = executewithdelay

local clone = clone

local Vector3 = Vector3
local Rotation = Rotation
local alive = alive
local managers = managers
local M_network = managers.network
local M_player = managers.player
local ply_list = M_player._players
local M_interaction = managers.interaction

local tweak_data = tweak_data
local T_carry = tweak_data.carry

local function is_client() return Network:is_client() end

local vec0 = Vector3(0,0,0)
local vec1 = Vector3(0,0,50)

local rot0 = Rotation(0,0,0)

local peer_id = M_network:session():local_peer():id()

function sm.interaction:interactbytweak(...)
    local player = ply_list[1]
    if not player then
        log:error("interactbytweak(): Local player isn't alive!")
        return
    end

    local interactives = {}

    local interact_with_all = sm:require 'utils/cheats/interact_with_all'
    local unload = not interact_with_all.enabled
    interact_with_all:enable()

    local tweaks = {}
    for _, arg in pairs({...}) do
        tweaks[arg] = true
    end

    for key, unit in pairs(M_interaction._interactive_units) do
        local interaction = unit.interaction
        interaction = interaction and interaction(unit)
        if interaction and tweaks[interaction.tweak_data] then
            insert(interactives, interaction)
        end
    end

    for _, i in pairs(interactives) do i:interact(player) end

    if (unload) then interact_with_all:disable() end
end

function sm.interaction:testopenallvaults()
    self:interactbytweak("pick_lock_hard", "pick_lock_hard_no_skill", "pick_lock_deposit_transport")
end

function sm.interaction:openalldoors()
    self:interactbytweak("pick_lock_easy_no_skill", "pick_lock_hard_no_skill", "pick_lock_hard", "open_from_inside", "open_train_cargo_door")
end

function sm.interaction:testshapeinteract()
    self:interactbytweak("shaped_sharge", "shaped_charge_single", "c4_mission_door")
end

function sm.interaction:removeallbags()
    self:interactbytweak("carry_drop", "painting_carry_drop")
    M_player:clear_carry()
end

function sm.interaction:bag_people()
    local ply = ply_list[1]
    if (alive(ply)) then
        local session = M_network._session
        local interactions = {}
        for _, unit in pairs(M_interaction._interactive_units) do
            local interaction = unit:interaction()
            if interaction and interaction.tweak_data == 'corpse_dispose' then
                interactions[unit:position() + vec1] = interaction
            end
        end

        local ply_clear_carry = M_player.clear_carry
        local send_to_host = session.send_to_host
        local server_drop_carry = M_player.server_drop_carry

        local is_client = is_client()

        local name = 'person'
        local carry_data = T_carry[name]

        local multiplier = carry_data.multiplier
        local dye_initiated = carry_data.dye_initiated
        local has_dye_pack = carry_data.has_dye_pack
        local dye_value_multiplier = carry_data.dye_value_multiplier

        for pos, interaction in pairs(interactions) do
            interaction:interact(ply)

            local unit = interaction._unit
            local u_id = managers.enemy:get_corpse_unit_data_from_key(unit:key()).u_id

            if is_client then
                send_to_host(session,
                    "server_drop_carry",
                    name,
                    multiplier,
                    dye_initiated,
                    has_dye_pack,
                    dye_value_multiplier,
                    pos,
                    rot0,
                    vec0,
                    100,
                    nil
                )

                send_to_host(session, "sync_interacted_by_id", u_id, "corpse_dispose")
            else
                server_drop_carry(M_player,
                    name,
                    multiplier,
                    dye_initiated,
                    has_dye_pack,
                    dye_value_multiplier,
                    pos,
                    rot0,
                    vec0,
                    100,
                    nil,
                    nil
                )

                unit:set_slot(0)
                session:send_to_peers_synched("remove_corpse_by_id", u_id, true, peer_id)
            end
            ply_clear_carry(M_player)
        end
    end
end

function sm.interaction:grabsmallloot()
    self:interactbytweak("safe_loot_pickup", "diamond_pickup", "tiara_pickup", "money_wrap_single_bundle", "invisible_interaction_open", "mus_pku_artifact")
end

function sm.interaction:graballbigloot()
    if not is_server() then return end
    sm:dofile 'actions/carrystacker'
    self:interactbytweak("carry_drop", "painting_carry_drop", "money_wrap", "gen_pku_jewelry", "taking_meth", "gen_pku_cocaine", "take_weapons", "gold_pile", "hold_take_painting", "invisible_interaction_open", "gen_pku_artifact", "gen_pku_artifact_statue", "gen_pku_artifact_painting")
end

function sm.interaction:quicklyrobstuff()
    self:interactbytweak('weapon_case', 'cash_register', 'requires_ecm_jammer_atm', 'pick_lock_hard', 'pick_lock_hard_no_skill', 'pick_lock_deposit_transport', 'gage_assignment')
    executewithdelay(function() self:grabsmallloot() end, 1)
end

function sm.interaction:drillupgall()
    self:interactbytweak("drill", "drill_upgrade", "drill_jammed", "lance_upgrade", "lance_jammed", "huge_lance_jammed")
end

function sm.interaction:barricade_stuff()
    self:interactbytweak('stash_planks', 'need_boards')
end

function sm.interaction:testclearrats1()
    local remove_special = M_player.remove_special
    remove_special(M_player, "acid")
    remove_special(M_player, "caustic_soda")
    remove_special(M_player, "hydrogen_chloride")
end

function sm.interaction:testclearrats0()
    self:interactbytweak("hydrogen_chloride", "caustic_soda", "muriatic_acid")
    if is_server() then
        self:testclearrats1()
    else
        executewithdelay(function() self:testclearrats1() end, 1) --Due sync delays, we gotta clear our inventory as fast as possible.
    end
end

function sm.interaction:quick_elday_2()
    self:interactbytweak('crate_loot_crowbar', 'crate_loot')

    local start_vote = function() self:interactbytweak('votingmachine1', 'votingmachine2', 'votingmachine3', 'votingmachine4', 'votingmachine5', 'votingmachine6') end
    executewithdelay(start_vote, 3)
end

function sm.interaction:hack_all_computers()
    self:interactbytweak('big_computer_hackable', 'big_computer_not_hackable')
end

function sm.interaction:openatms()
    self:interactbytweak('requires_ecm_jammer_atm')
end

function sm.interaction:quick_ff3()
    self:interactbytweak('pickup_phone', 'pickup_tablet', 'use_computer', 'stash_server_pickup')
end

function sm.interaction:pickup_files()
    self:interactbytweak('invisible_interaction_searching')
end

--invisible_interaction_searching, search_files_false FBI files in Hoxton Breakout
--hold_open_xmas_present presents in Vlad's winter heist
--gen_pku_cocaine_pure, pure meth
function sm.interaction:open_gift_boxes()
    self:interactbytweak('hold_open_xmas_present')
end

-- Diamond heist
function sm.interaction:rewire_circuit()
    self:interactbytweak('invisible_interaction_open')

    local rewire_electric_box = function() self:interactbytweak('rewire_electric_box') end
    executewithdelay(rewire_electric_box, 5)
end

function sm.interaction:cut_glasses()
    self:interactbytweak('cut_glass')
end

-- The bomb: dockyard
function sm.interaction:place_explosives()
    self:interactbytweak('shape_charge_plantable')
end

return sm.interaction
