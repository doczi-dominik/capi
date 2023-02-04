local utils = require "data.utils"

local m = {}

m.SER_DELIM = ";c;"
m.SER_SPR_DELIM = ";c-s;"
m.SER_FLAG_DELIM = ";c-f;"

---@class cell
---@field sprites integer[]
---@field flagOverrides string[]|nil
---@field serialize fun():string

---@return cell
function m.create()
    local c = {}  ---@type cell

    c.sprites = {}
    c.flagOverrides = nil

    function c.serialize()
        local sprites = ""

        for i, s in ipairs(c.sprites) do
            if i > 1 then
                sprites = sprites..m.SER_SPR_DELIM
            end

            sprites = sprites..tostring(s)
        end

        local flags = ""

        if c.flagOverrides ~= nil then
            for i, f in ipairs(c.flagOverrides) do
                if i > 1 then
                    flags = flags..m.SER_FLAG_DELIM
                end

                flags = flags..f
            end
        end

        return string.format("%s%s%s", sprites, m.SER_DELIM, flags)
    end

    return c
end


---@param serialized string
---@return cell
function m.load(serialized)
    local c = m.create()
    local parts = utils.split(serialized, m.SER_DELIM)

    for _, s in ipairs(utils.split(parts[1], m.SER_SPR_DELIM)) do
        local spr = tonumber(s)

        if spr ~= nil then
            c.sprites[#c.sprites+1] = spr
        end
    end

    local flags = parts[2]

    if flags ~= "" then
        c.flagOverrides = utils.split(flags, m.SER_FLAG_DELIM)
    end

    return c
end

return m