local sm = SharpMod

local loadstring = loadstring
local pcall = pcall
local pairs = pairs
local next = next
local unpack = unpack
local clone = clone
local tab_insert = table.insert

local log = sm.log 'backuper'

local safecall = sm.safecall

local Backuper = class()

function Backuper:init(class_name)
    self._name = class_name
    self._originals = {}
    self._hacked = {}
    self._callbacks = {}
end

function Backuper:backup(stuff_string, name)
    local O = self._originals
    local have_orig = O[name] or O[stuff_string]
    if have_orig then
        return have_orig
    end

    local execute, serr = loadstring(self._name..'._originals[\"'..(name or stuff_string)..'\"] = '..stuff_string)

    if serr then
        return log('backup'):error('Failed to backup string %s. Error thrown: %s', stuff_string, serr)
    end

    local success, err = pcall(execute)

    if success then
        return O[name] or O[stuff_string]
    else
        log('backup'):error('Failed to backup string %s. Error thrown: %s', stuff_string, err)
    end
end

function Backuper:hijack_adv(fstr, new_function)
    if not self._hacked[fstr] then
        self:backup(fstr)
        self._hacked[fstr] = {}
        local exec, serr = loadstring(fstr..' = function(...) local tb = { '..self._name..'._originals[\''..fstr..'\'] } \
            for _,func in ipairs('..self._name..'._hacked[\''..fstr..'\']) do table.insert(tb, func) end    \
                return '..self._name..'._hacked[\''..fstr..'\'][1](  tb, 1, ... )  end')

        if serr then
            return log('hijack_adv'):error('Error hijacking function %s. Error thrown: %s', fstr, serr)
        end

        local s,res = pcall(exec)
        if not s then
            return log('hijack_adv'):error('Error hijacking function %s. Error thrown: %s', fstr, res)
        end
    end
    tab_insert(self._hacked[fstr], new_function)
    return new_function
end

function Backuper:unhijack_adv(fstr, new_func)
    local remove = table.remove
    for index,func in pairs(self._hacked[fstr]) do
        if func == new_func then
            remove(self._hacked[fstr], index)
        end
    end
    if #self._hacked[fstr] == 0 then
        self:restore(fstr)
    end
end

function Backuper:hijack(function_string, new_function)
    local H = self._hacked

    local o = self:backup(function_string)
    H[function_string] = function( ... ) return new_function( o, ... ) end

    local exec, serr = loadstring(function_string..' = '..self._name..'._hacked[\''..function_string..'\']')

    if serr then
        return log('hijack'):error('Error hijacking function %s. Error thrown: %s', function_string, serr)
    end

    local s,res = pcall(exec)
    if s then
        return H[function_string]
    else
        log('hijack'):error('Error hijacking function %s. Error thrown: %s', function_string, res)
    end
end

local call_clbks_arr = function( arr, ... )
    for _,clbk in pairs(arr) do
        safecall(clbk, ...)
    end
end

function Backuper:add_clbk(function_string, new_function, id, pos)
    if not id or not pos then
        return log('add_clbk'):error('No pos or id was provided')
    end
    local CLBKS = self._callbacks
    local f_clbks = CLBKS[function_string]
    local bef_clbks
    local aft_clbks
    if not f_clbks then
        aft_clbks = {}
        bef_clbks = {}
        f_clbks = { [1] = bef_clbks, [2] = aft_clbks }
        CLBKS[function_string] = f_clbks
    else
        bef_clbks = f_clbks[1]
        aft_clbks = f_clbks[2]
    end
    if not self._hacked[function_string] then
        self:hijack(function_string,
            function(o, ...)
                call_clbks_arr(bef_clbks, o, ...)
                local r = { o(...) }
                call_clbks_arr(aft_clbks, r, ...)
                return unpack(r)
            end
        )
    end
    local have_clbk = f_clbks[pos][id]
    if not have_clbk then
        f_clbks[pos][id] = new_function
        return new_function
    else
        return have_clbk
    end
end

function Backuper:remove_clbk(function_string, id, pos)
    local CLBKS = self._callbacks
    local f_clbks = CLBKS[function_string]
    if f_clbks then
        local b_clbks = f_clbks[1]
        local a_clbks = f_clbks[2]
        local p_clbks = pos == 1 and b_clbks or pos == 2 and a_clbks or {}
        if id and pos then
            p_clbks[id] = nil
        elseif not pos then
            b_clbks[id] = nil
            a_clbks [id] = nil
        elseif not id then
            for id,_ in pairs(clone(p_clbks)) do
                p_clbks[id] = nil
            end
        elseif not id and not pos then
            self:restore( function_string )
            return true
        else
            return false
        end
        if not next(b_clbks) and not next(a_clbks) then
            self:restore(function_string)
        end
        return true
    else
        return false
    end
end

function Backuper:restore(stuff_string, name)
    local O = self._originals
    local n = O[name] or O[stuff_string]
    if n then
        local exec, serr = loadstring(stuff_string .. ' = ' .. self._name .. '._originals["' .. stuff_string .. '"]')
        if serr then
            return log('restore'):error('Failed to restore string %s. Error thrown: %s', stuff_string, serr)
        end
        local success, err = pcall(exec)
        if success then
            O[stuff_string] = nil
            self._hacked[stuff_string] = nil
            self._callbacks[stuff_string] = nil
        else
            log('restore'):error('Failed to restore string %s. Error thrown: %s', stuff_string, err)
        end
    end
end

function Backuper:restore_all()
    local name = self._name
    local _O = self._originals
    local _H = self._hacked
    local CLBKS = self._callbacks
    for n,_ in pairs(self._originals) do
        local exec, serr = loadstring(n .. ' = ' .. name .. '._originals["' .. n .. '"]')
        if serr then
            log('restore_all'):error('Failed to restore string %s. Error thrown: %s', n, serr)
        else
            local success, err = pcall(exec)
            if success then
                _O[n] = nil
                _H[n] = nil
                CLBKS[n] = nil
            else
                log('restore_all'):error('Failed to restore string %s. Error thrown: %s', n, err)
            end
        end
    end
end

function Backuper:destroy()
    self:restore_all()
end

return Backuper
