local sm = SharpMod
local log = sm.log

local managers = managers

local pairs = pairs
local AI_State = managers.groupai:state()
local convert_hostage_to_criminal = AI_State.convert_hostage_to_criminal
local all_enemies = managers.enemy:all_enemies()
local safecall = sm.safecall

local inf_converts = sm:require 'utils/cheats/infinite_converts'

local inf_converts_enabled = inf_converts.enabled

inf_converts:enable()

log:info('Converting EVERYONE')

for _, ud in pairs(all_enemies) do
    local unit = ud.unit
    if not unit:brain()._logic_data.is_converted then
        --Sometimes it fails to convert single unit
        safecall(convert_hostage_to_criminal, AI_State, unit)
    end
end

if not inf_converts_enabled then inf_converts:disable() end
