local createSprite = require("data.sprite")
local createMeta = require("data.sheet_metadata")
local templates = require("data.library_template")

---@class spriteCollection
---@field data sprite[]
---@field selectedIndex integer
---@field spriteSize integer
---@field addSpriteSheet fun(name: string, spritesheet: love.ImageData)
---@field removeSpriteSheet fun(name: string)
---@field serialize fun():string
---@field exportForLibrary fun()

---@param spriteSize integer
---@return spriteCollection
local function createCollection(spriteSize)
    local c = {}

    c.spriteSize = spriteSize
    c.sheets = {}   ---@type sheetMetadata[]
    c.data = {}  ---@type sprite[]
    c.selectedIndex = 1

    ---@param name string
    ---@param spritesheet love.ImageData
    function c.addSpriteSheet(name, spritesheet)
        c.sheets[#c.sheets+1] = createMeta(name, spritesheet)

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

    function c.serialize()
        local sheets = ""

        for i, s in ipairs(c.sheets) do
            if i > 1 then
                sheets = sheets..";sc-s;"
            end

            sheets = sheets..s.serialize()
        end

        local data = ""

        for i, d in ipairs(c.data) do
            if i > 1 then
                data = data..";sc-d;"
            end

            data = data..d.serialize()
        end

        return string.format("%d;sc;%s;sc;%s", c.spriteSize, sheets, data)
    end

    function c.exportForLibrary()
        local sizedata = string.format("local spriteSize = %d\n", c.spriteSize)

        local spriteLines = {}
        local flaglines = {}

        for i, v in ipairs(c.sheets) do
            local sprline = string.format("sprites[%d] = '%s'", i, v.spritesheet:encode("png"):getString())

            spriteLines[#spriteLines+1] = sprline
        end

        for i, v in ipairs(c.data) do
            if #v.flags > 0 then
                local flagline = string.format("flags[%d] = '%s'", i, table.concat(v.flags, "|"))

                flaglines[#flaglines+1] = flagline
            end
        end

        local sprdata = table.concat(spriteLines, "\n") .. "\n"
        local flagdata = table.concat(flaglines, "\n") .. "\n"

        return sizedata
            ..templates.libs_raw_flags
            ..sprdata
            ..flagdata
            ..templates.decompress
    end

    return c
end

return createCollection