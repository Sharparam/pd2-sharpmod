local log = SharpMod.log

local IDS = {
    ['@ID7999172'] = true, -- Harvest & Trustee Bank
    ['@IDe4bc870'] = true, -- Armored Transport
    ['@ID51da6d6'] = true, -- Armored Transport
    ['@ID8d8c766'] = true, -- Armored Transport
    ['@ID50aac55'] = true, -- Armored Transport
    ['@ID5dcd177'] = true, -- Armored Transport
    ['@IDa95e021'] = true, -- Big Bank
    ['@IDe93c9b2'] = true  -- GO Bank
}

for _, v in pairs(managers.interaction._interactive_units) do
    if v.interaction then
        local interaction = v:interaction()
        local id = string.sub(interaction._unit:name():t(), 1, 10)
        log:verbose('Bankbuster ID: %s', id)
        if IDS[id] then
            log:debug('Bankbuster opening ID %s', id)
            interaction:interact(managers.player:player_unit())
        end
    end
end

log:info('ALL DEPOSIT BOXES OPENED')
