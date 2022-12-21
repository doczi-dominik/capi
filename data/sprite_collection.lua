local createSprite = require("data.sprite")

---@class spriteCollection
---@field data sprite[]
---@field selectedIndex integer
---@field spriteSize integer
---@field addSpriteSheet fun(name: string, spritesheet: love.ImageData)
---@field removeSpriteSheet fun(name: string)

---@param spriteSize integer
---@return spriteCollection
local function createCollection(spriteSize)
    local c = {}

    ---@class sheetMetadata
    ---@field name string
    ---@field spritesheet love.ImageData

    c.sheets = {}   ---@type sheetMetadata[]
    c.data = {}
    c.selectedIndex = 0
    c.spriteSize = spriteSize

    ---@param name string
    ---@param spritesheet love.ImageData
    function c.addSpriteSheet(name, spritesheet)
        c.sheets[#c.sheets+1] = {
            name = name,
            spritesheet = spritesheet
        }

        local img = LG.newImage(spritesheet)
        local sw, sh = spritesheet:getDimensions()

        for y = 0, sh, spriteSize do
            for x = 0, sw, spriteSize do
                c.data[#c.data+1] = createSprite(img, spriteSize, x, y)
            end
        end
    end

    function c.removeSpriteSheet(name)
        for i = #c.sheets, 1, -1 do
            local s = c.sheets[i]

            if s.name == name then
                s.spritesheet:release()
                table.remove(c.sheets, i)
            end
        end
    end

    return c
end

return createCollection