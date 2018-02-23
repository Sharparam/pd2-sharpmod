local sm = SharpMod
local log = sm.log

if sm.cheat_manager then return sm.cheat_manager end

log:debug('Setting up cheat manager')

sm.cheat_manager = {
    cheats = {}
}

local cm = sm.cheat_manager

function cm:add(id, name, enable, disable)
    if rawget(self.cheats, id) then return rawget(self.cheats, id) end

    local cheat = {
        id = id,
        name = name,
        enable_func = enable,
        disable_func = disable
    }

    cheat.enable = function(self)
        if self.enabled then return end
        self.enable_func(self)
        self.enabled = true
        log:info('%s ENABLED', self.name)
        log:system('%s ENABLED', self.name)
    end

    cheat.disable = function(self)
        if not self.enabled then return end
        self.disable_func(self)
        self.enabled = false
        log:info('%s DISABLED', self.name)
        log:system('%s DISABLED', self.name)
    end

    cheat.toggle = function(self)
        if self.enabled then self:disable() else self:enable() end
    end

    rawset(self.cheats, id, cheat)

    -- self['enable_' .. id] = function(self) self.cheats[id]:enable() end
    -- self['disable_', .. id] = function(self) self.cheats[id]:disable() end
    -- self['toggle_', .. id] = function(self) self.cheats[id]:toggle() end

    return rawget(self.cheats, id)
end

function cm:has_cheat(id)
    return type(rawget(self.cheats, id)) ~= 'nil'
end

log:debug('cheat_manager: Loading vendor scripts')
sm:require 'vendor/player_equip_fix'
sm:require 'vendor/player_upgrade_hack'
sm:require 'vendor/pubinfloopv2'

log:debug('cheat_manager: Loading interaction speed helper')
local interactionspeed = sm:require 'utils/interactionspeed'

local fun_cheats = {
    'godmode', 'infinite_ammo', 'infinite_converts', 'infinite_equipment', 'instant_drills',
    'instant_intimidation', 'interact_with_all', 'max_accuracy', 'no_recoil',
    'extreme_firerate', 'explosive_bullets'
}

function cm:enable_funmode()
    log:info('Enabling FUN MODE')
    log:system('Enabling FUN MODE')
    interactionspeed:enable_instant()
    for i = 1, #fun_cheats do
        self.cheats[fun_cheats[i]]:enable()
    end
end

function cm:disable_funmode()
    for i = 1, #fun_cheats do
        self.cheats[fun_cheats[i]]:disable()
    end
    interactionspeed:disable()
    log:info('Fun mode disabled')
    log:system('Fun mode disabled')
end

log:debug('cheat_manager: Setting up meta tables')

local function init_cheat(id)
    log:warn('%s not found in cheats table, attempting to load it', id)
    local cheat = sm:require('utils/cheats/' .. id)
    if type(rawget(cm.cheats, id)) == 'nil' then rawset(cm.cheats, id, cheat) end
    return cheat
end

setmetatable(cm.cheats, {
    __index = function(tbl, key) return init_cheat(key) end
})

setmetatable(cm, {
    __index = function(tbl, key)
        local cheat = rawget(cm.cheats, key)
        if cheat then return cheat end
        return init_cheat(key)
    end
})

log:debug('Cheat manager init finished, returning module')
return sm.cheat_manager
