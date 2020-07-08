local sm = _G.SharpMod
local log = sm.log

if sm.interactionspeed then return sm.interactionspeed end

sm.interactionspeed = {}

local backuper = sm.backuper
local BaseInteractionExt = BaseInteractionExt
local backup = backuper.backup
local restore = backuper.restore

function sm.interactionspeed:enable()
    if self.enabled then return end

    function BaseInteractionExt.toggle_int_speed(ext, speed)
        if ext.speed_changed and ext.speed_changed == speed then
            ext:restore_speed()
            return
        end
        ext:set_int_speed(speed)
    end

    function BaseInteractionExt.set_int_speed(ext, speed)
        ext.speed_changed = speed
        backup(backuper, 'BaseInteractionExt._get_timer')
        function BaseInteractionExt._get_timer() return speed end
        log:debug('Interaction speed set to %d', speed)
    end

    function BaseInteractionExt.restore_speed(ext)
        restore(backuper, 'BaseInteractionExt._get_timer')
        ext.speed_changed = nil
        log:debug('Interaction speed restored')
    end

    self.enabled = true
end

function sm.interactionspeed:disable()
    if not self.enabled then return end

    BaseInteractionExt:restore_speed()
    --Cleanup
    BaseInteractionExt.toggle_int_speed = nil
    BaseInteractionExt.set_int_speed = nil
    BaseInteractionExt.restore_speed = nil

    self.enabled = false

    log:debug('Interaction speed mods disabled')
end

function sm.interactionspeed:toggle_speed(speed)
    self:enable()
    BaseInteractionExt:toggle_int_speed(speed)
end

function sm.interactionspeed:set_speed(speed)
    self:enable()
    BaseInteractionExt:set_int_speed(speed)
end

function sm.interactionspeed:enable_instant()
    self:set_speed(0.01)
end

function sm.interactionspeed:toggle_instant()
    self:toggle_speed(0.01)
end

function sm.interactionspeed:restore_speed()
    if not self.enabled or not BaseInteractionExt.restore_speed then return end
    BaseInteractionExt:restore_speed()
end

return sm.interactionspeed
