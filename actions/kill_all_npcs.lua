local function is_hostage(unit) --Checks, if unit's hands tied or unit being intimidated to cuff himself.
    if alive(unit) then
        local brain = unit.brain
        brain = brain and brain(unit)
        if brain and brain.is_hostage and brain.is_hostage(brain) then return true end
        local anim_data = unit.anim_data
        anim_data = anim_data and anim_data(unit)
        if anim_data then
            local tied = anim_data.tied or anim_data.hands_tied
            if tied then return true end
        end
    end
    return false
end

local function is_converted(unit)
    if not alive(unit) then return false end
    if not unit.brain then return false end
    local logic_data = unit:brain()._logic_data
    if not logic_data then return false end
    return logic_data.is_converted
end

local function dmg_melee(unit)
    if unit then
        local action_data = {
            damage = math.huge, --(Ultra * math.huge) damage.
            damage_effect = unit:character_damage()._HEALTH_INIT * 2,
            attacker_unit = managers.player:player_unit(),
            attack_dir = Vector3(0, 0, 0),
            name_id = 'rambo', --Only in rambo style bulldosers can be killed
            col_ray = {
                position = unit:position(),
                body = unit:body("body")
            }
        }

        unit:unit_data().has_alarm_pager = false

        if (action_data.attacker_unit) then
            unit:character_damage():damage_melee(action_data)
        end
    end
end

local function dmg_cam(unit)
    local col_ray = {}
    col_ray.ray = Vector3(1,0,0)
    col_ray.position = unit:position()
    local body
    do
        local i = -1
        repeat
            i = i + 1
            body = unit:body(i)
        until (body and body:extension()) or i >= 5
        if not body then
            return
        end
    end
    col_ray.body = body
    col_ray.body:extension().damage:damage_melee(unit, col_ray.normal, col_ray.position, col_ray.direction, 10000)
    managers.network:session():send_to_peers_synched("sync_body_damage_melee", col_ray.body, unit, col_ray.normal, col_ray.position, col_ray.direction, 10000)
end


for _, ud in pairs(managers.enemy:all_enemies()) do
    if not is_hostage(ud.unit) and not is_converted(ud.unit) then
        pcall(dmg_melee, ud.unit)
    end
end

if SharpMod.options.kill_civilians then
    for _, ud in pairs(managers.enemy:all_civilians()) do
        if not is_hostage(ud.unit) then
            pcall(dmg_melee, ud.unit)
            pcall(dmg_melee, ud.unit)
        end
    end
end

for _, unit in pairs(SecurityCamera.cameras) do pcall(dmg_cam, unit) end
