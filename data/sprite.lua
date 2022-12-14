
---@class sprite
---@field flags string[]
---@field draw fun(x: number, y: number)

---@param image love.Image
---@param size integer
---@param sx integer
---@param sy integer
---@param flags string[]?
---@return sprite
local function createSprite(image, size, sx, sy, flags)
    local s = {}
    local quad = LG.newQuad(sx, sy, size, size, image:getDimensions())

    s.flags = flags or {}

    function s.draw(x, y)
        LG.draw(image, quad, x, y)
    end

    return s
end

return createSprite