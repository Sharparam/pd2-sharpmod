local sm = SharpMod
if not sm.item_unlocker then
    local iu = {}

    local pairs = pairs

    iu.add_counts = {
        weapon_mods = 20,
        materials = 20,
        textures = 20,
        colors = 20
    }

    function iu:unlock_items(item_type)
        if item_type == "all" then
            self:unlock_all_items()
        elseif item_type == "weapons" then
            self:unlock_weapons()
        else
            self:unlock_items_category(item_type)
        end
    end

    function iu:unlock_all_items()
        local types = { "weapon_mods", "masks", "materials", "textures", "colors" }
        for _, item_type in pairs(types) do self:unlock_items_category(item_type) end
        self:unlock_weapons()
    end

    function iu:unlock_weapons()
        local weapons = Global.blackmarket_manager.weapons
        for weapon_id in pairs(weapons) do
            managers.upgrades:aquire(weapon_id)
            weapons[weapon_id].unlocked = true
        end
    end

    function iu:unlock_items_category(item_type)
        for id, data in pairs(tweak_data.blackmarket[item_type]) do
            if data.infamy_lock then data.infamy_lock = false end

            local global_value = self:get_global_value(data)
            local count = self.add_counts[item_type] or 1
            for i = 1, count do
                managers.blackmarket:add_to_inventory(global_value, item_type, id)
            end
        end
    end

    function iu:get_global_value(data)
        if data.global_value then
            return data.global_value
        elseif data.infamous then
            return "infamous"
        elseif data.dlcs or data.dlc then
            local dlcs = data.dlcs or {}
            if data.dlc then table.insert(dlcs, data.dlc) end
            return dlcs[math.random(#dlcs)]
        else
            return "normal"
        end
    end

    sm.item_unlocker = iu
end

return sm.item_unlocker
