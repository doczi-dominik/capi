local createSprite = require("data.sprite")

---@class spriteCollection
---@field spriteSize integer
---@field addSpriteSheet fun(spritesheet: love.Image)

---@param spriteSize integer
---@return spriteCollection
local function createCollection(spriteSize)
    local data = {}

    local c = {}
    c.spriteSize = spriteSize

    ---@param spritesheet love.Image
    function c.addSpriteSheet(spritesheet)
        local sw, sh = spritesheet:getDimensions()

        for y = 0, sh, spriteSize do
            for x = 0, sw, spriteSize do
                data[#data+1] = createSprite(spritesheet, spriteSize, x, y)
            end
        end
    end

    return c
end

return createCollection