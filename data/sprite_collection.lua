local createSprite = require("data.sprite")

---@class spriteCollection
---@field data sprite[]
---@field selectedIndex integer
---@field spriteSize integer
---@field addSpriteSheet fun(spritesheet: love.Image)

---@param spriteSize integer
---@return spriteCollection
local function createCollection(spriteSize)
    local c = {}

    c.data = {}
    c.selectedIndex = 0
    c.spriteSize = spriteSize

    ---@param spritesheet love.Image
    function c.addSpriteSheet(spritesheet)
        local sw, sh = spritesheet:getDimensions()

        for y = 0, sh, spriteSize do
            for x = 0, sw, spriteSize do
                c.data[#c.data+1] = createSprite(spritesheet, spriteSize, x, y)
            end
        end
    end

    return c
end

return createCollection