if not SharpMod.options.disable_anticheat then return end

local log = SharpMod.log

log.info('DISABLING ANTI-CHEAT')

local PlayerManager = PlayerManager
local NetworkMember = NetworkMember
local NetworkPeer = NetworkPeer

if PlayerManager then
    function PlayerManager.verify_carry()return true end --Sometimes it blocks host from spawning bag, so it lobotomied
    function PlayerManager.verify_equipment()return true end
    function PlayerManager.verify_grenade()return true end
end

if NetworkMember then
    function NetworkMember.place_bag()return true end
end

if NetworkPeer then
    function NetworkPeer.verify_bag()return true end
end

-- Remove loot cap
if tweak_data and tweak_data.money_manager then
    tweak_data.money_manager.max_small_loot_value = math.huge
end
