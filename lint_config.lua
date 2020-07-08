local config = {
    whitelist_globals = {
        ["**"] = {}
    }
}

local luacheckrc = setmetatable({}, { __index = _G })
luacheckrc.stds = {}
assert(pcall(setfenv(assert(loadfile(".luacheckrc")), luacheckrc)))
setmetatable(luacheckrc, nil)

local function add_globals(tbl)
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            table.insert(config.whitelist_globals["**"], k)
        else
            table.insert(config.whitelist_globals["**"], v)
        end
    end
end

local function find_globals(tbl)
    for k, v in pairs(tbl) do
        if k == "globals" or k == "read_globals" then
            add_globals(v)
        elseif type(v) == "table" then
            find_globals(v)
        end
    end
end

find_globals(luacheckrc)

local function make_compat(tbl)
    for k, v in pairs(tbl) do
        if type(k) == "string" and k:match("/") then
            tbl[k:gsub("/", "\\")] = v
        end

        if type(v) == "table" then
            make_compat(v)
        end
    end

    return tbl
end

return make_compat(config)
