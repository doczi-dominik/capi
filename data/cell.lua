
---@class cell
---@field sprites integer[]
---@field flagOverrides string[]|nil
---@field serialize fun():string

---@return cell
local function createCell()
    local c = {}  ---@type cell

    c.sprites = {}
    c.flagOverrides = nil

    function c.serialize()
        local sprites = ""

        for i, s in ipairs(c.sprites) do
            if i > 1 then
                sprites = sprites..";c-s;"
            end

            sprites = sprites..tostring(s)
        end

        local flags = ""

        if c.flagOverrides ~= nil then
            for i, f in ipairs(c.flagOverrides) do
                if i > 1 then
                    flags = flags..";c-f;"
                end

                flags = flags..f
            end
        end

        return string.format("%s;c;%s", sprites, flags)
    end

    return c
end

return createCell