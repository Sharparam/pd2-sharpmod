local ID = 'godmode'

if SharpMod.cheat_manager:has_cheat(ID) then return SharpMod.cheat_manager[ID] end

local function query_execution_testfunc(testfunc, func_array)
    local f = func_array.f
    local params = func_array.a or {}
    local updator
    local stop = StopLoopIdent
    local function __clbk()
        if testfunc() then
            f(unpack(params))
            stop(updator)
        end
    end
    updator = RunNewLoop(__clbk) --RunNewLoop secured with pcall, so you don't have to worry about crashy code.
end

local function verify_ply_alive()
    local ply = managers.player:player_unit()
    return alive(ply) and ply
end

local function set_god_mode(bool)
    local player = verify_ply_alive()
    if not player then return end
    player:character_damage():set_god_mode(bool) --Godmode being stored in global variable aswell.
end

return SharpMod.cheat_manager:add('godmode', 'GODMODE', function()
    query_execution_testfunc(verify_ply_alive, { f = set_god_mode, a = { true } })
end, function()
    query_execution_testfunc(verify_ply_alive, { f = set_god_mode, a = { false } })
end)
