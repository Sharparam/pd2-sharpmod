local sm = _G.SharpMod
if not sm.teleport then
    local M_player = managers.player
    local players_tab = M_player._players
    local function GetPlayerUnit() return players_tab[1] end

    local M_slot = managers.slot
    local get_mask = M_slot.get_mask

    local World = World
    local W_raycast = World.raycast

    local mvector3 = mvector3
    local mvec_set = mvector3.set
    local mvec_mul = mvector3.multiply
    local mvec_add = mvector3.add
    local function get_ray(penetrate, slotMask) -- Get col ray
        if not slotMask then slotMask = "bullet_impact_targets" end
        local player = GetPlayerUnit()
        if (alive(player)) then
            local camera = player:camera()
            local fromPos = camera:position()
            local mvecTo = Vector3()
            local forward = camera:rotation():y()
            mvec_set(mvecTo, forward)
            mvec_mul(mvecTo, 99999)
            mvec_add(mvecTo, fromPos)
            local colRay = W_raycast(World, "ray", fromPos, mvecTo, "slot_mask", get_mask(M_slot, slotMask))
            if colRay and penetrate then
                local offset = Vector3()
                mvec_set(offset, forward)
                mvec_mul(offset, 100)
                mvec_add(colRay.hit_position, offset)
            end
            return colRay
        end
    end

    local m_player = managers.player
    local warp_to = m_player.warp_to
    --local rot0 = Rotation(0,0,0)

    sm.teleport = function()
        local ray = get_ray(_G.SharpMod.options.penetrating_teleport)
        if ray then
            warp_to(m_player, ray.hit_position, m_player:player_unit():camera():rotation())
        end
    end
end

sm.teleport()
