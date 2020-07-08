local sm = _G.SharpMod
--local log = sm.log
local preplanning = managers.preplanning

if preplanning then
    local free_preplanning = sm.cheat_manager.free_preplanning
    local free_enabled = free_preplanning.enabled
    free_preplanning:enable()

    local equipments = { 'bodybags_bag', 'grenade_crate', 'ammo_bag', 'health_bag' }
    for type, array in pairs(preplanning._mission_elements_by_type) do
        for _, element in pairs(array) do
            if table.contains(equipments, type) then
                -- Instead of placing bodybags, we will place random equipment.
                type = equipments[math.random(2, #equipments)]
            end
            preplanning:reserve_mission_element(type, element:id())
        end
    end

    if not free_enabled then free_preplanning:disable() end
end
