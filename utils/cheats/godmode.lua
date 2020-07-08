local ID = 'godmode'

if _G.SharpMod.cheat_manager:has_cheat(ID) then return _G.SharpMod.cheat_manager[ID] end

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
    -- RunNewLoop secured with pcall, so you don't have to worry about crashy code.
    updator = RunNewLoop(__clbk)
end

local function verify_ply_alive()
    local ply = managers.player:player_unit()
    return alive(ply) and ply
end

local function set_god_mode(bool)
    local player = verify_ply_alive()
    if not player then return end
    -- Godmode being stored in global variable aswell.
    player:character_damage():set_god_mode(bool)
end

return _G.SharpMod.cheat_manager:add('godmode', 'GODMODE', function()
    query_execution_testfunc(verify_ply_alive, { f = set_god_mode, a = { true } })
end, function()
    query_execution_testfunc(verify_ply_alive, { f = set_god_mode, a = { false } })
end)
