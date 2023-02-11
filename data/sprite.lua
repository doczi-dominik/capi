local utils = require("data.utils")

local m = {}

m.SER_DELIM = ";sf;"

---@class sprite
---@field flags string[]
---@field serialize fun():string
---@field load fun(serialized: string)
---@field draw fun(x: number, y: number)
---@field drawForPalette fun(x: number, y: number)

---@param image love.Image
---@param size integer
---@param sx integer
---@param sy integer
---@param flags string[]?
---@return sprite
function m.create(image, size, sx, sy, flags)
    local s = {}
    local quad = LG.newQuad(sx, sy, size, size, image:getDimensions())

    s.flags = flags or {}

    function s.serialize()
        local str = ""

        for i, f in ipairs(s.flags) do
            if i > 1 then
                str = str..m.SER_DELIM
            end

            str = str..f
        end

        return str
    end

    function s.load(serialized)
        s.flags = utils.split(serialized, m.SER_DELIM)
    end

    function s.draw(x, y)
        LG.draw(image, quad, x, y)
    end

    function s.drawForPalette(x, y)
        local scale = 48 / size

        LG.draw(image, quad, x, y, 0, scale, scale)
    end

    return s
end

return m