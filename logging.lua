local type = type
local ipairs = ipairs
local tostring = tostring
local sformat = string.format
local supper = string.upper

local LEVEL_VERBOSE = 1
local LEVEL_DEBUG = 2
local LEVEL_INFO = 3
local LEVEL_WARNING = 4
local LEVEL_ERROR = 5
local LEVEL_FATAL = 6
local LEVEL_NONE = 7

local orig_log = _G.log

local log = {
    context = 'MAIN',
    level = LEVEL_INFO,
    levels = {
        'VERBOSE', -- 1
        'DEBUG',   -- 2
        'INFO',    -- 3
        'WARNING', -- 4
        'ERROR',   -- 5
        'FATAL',   -- 6
        'NONE'     -- 7
    },
    ids = {
        VERBOSE = LEVEL_VERBOSE,
        DEBUG = LEVEL_DEBUG,
        INFO = LEVEL_INFO,
        WARNING = LEVEL_WARNING,
        ERROR = LEVEL_ERROR,
        FATAL = LEVEL_FATAL,
        NONE = LEVEL_NONE
    }
}

local LOG_FORMAT = '[SharpMod] %s - %s: %s'

local function nametoid(name)
    if type(name) ~= 'string' then name = tostring(name) end
    name = supper(name)
    return log.ids[name]
end

function log:log(level, message, ...)
    if type(level) == 'string' then
        level = nametoid(level)
        if not level then return self:log(LEVEL_INFO, level, message, ...) end
    end
    if type(message) ~= 'string' then message = tostring(message) end
    if level < self.level then return end
    local msg = sformat(LOG_FORMAT, log.levels[level], self.context, sformat(message, ...))
    orig_log(msg)
    return self
end

function log:verbose(message, ...) return self:log(LEVEL_VERBOSE, message, ...) end
function log:trace(message, ...) return self:log(LEVEL_VERBOSE, message, ...) end
function log:debug(message, ...) return self:log(LEVEL_DEBUG, message, ...) end
function log:info(message, ...) return self:log(LEVEL_INFO, message, ...) end
function log:warning(message, ...) return self:log(LEVEL_WARNING, message, ...) end
function log:warn(message, ...) return self:log(LEVEL_WARNING, message, ...) end
function log:error(message, ...) return self:log(LEVEL_ERROR, message, ...) end
function log:fatal(message, ...) return self:log(LEVEL_FATAL, message, ...) end

function log:system(message, ...)
    local msg = "[SharpMod] " .. sformat(message, ...)
    managers.chat:feed_system_message(ChatManager.GAME, msg)
    return self
end

function log:hint(message, ...)
    local data = type(message) == 'table' and message or { text = sformat(message, ...) }
    managers.hud:show_hint(data)
    return self
end

function log:objective(title, message, ...)
    local data = type(title) == 'table' and title or {
        title = title,
        text = sformat(message, ...),
        time = 2
    }
    managers.hud:present_mid_text(data)
    return self
end

setmetatable(log, {
    __call = function(tbl, context, ...)
        return setmetatable({ context = context }, {
            __index = function(t, k) return tbl[k] end,
            __call = function(t, c, ...)
                return getmetatable(tbl).__call(tbl, t.context .. '.' .. c, ...)
            end
        })
    end
})

return log
