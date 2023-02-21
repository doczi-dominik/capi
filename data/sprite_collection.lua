local sprite = require("data.sprite")
local sheetMeta = require("data.sheet_metadata")
local templates = require("data.library_template")
local utils = require("data.utils")

local m = {}

m.SER_DELIM = ";sc;"
m.SER_SHEET_DELIM = ";sc_s;"
m.SER_DATA_DELIM = ";sc_d;"

---@class spriteCollection
---@field sheets sheetMetadata[]
---@field data sprite[]
---@field selectedSprite integer
---@field spriteSize integer
---@field selectionSize integer
---@field addSpriteSheet fun(name: string, spritesheet: love.ImageData)
---@field removeSpriteSheet fun(name: string)
---@field serialize fun():string
---@field exportForLibrary fun():string

---@param spriteSize integer
---@return spriteCollection
function m.create(spriteSize)
    local c = {}  ---@type spriteCollection

    c.spriteSize = spriteSize
    c.sheets = {}   ---@type sheetMetadata[]
    c.data = {}  ---@type sprite[]
    c.selectedSprite = 1
    c.selectionSize = 3

    ---@param name string
    ---@param spritesheet love.ImageData
    function c.addSpriteSheet(name, spritesheet)
        c.sheets[#c.sheets+1] = sheetMeta.create(name, spritesheet)

        local img = LG.newImage(spritesheet)
        local sw, sh = spritesheet:getDimensions()

        for y = 0, sh, spriteSize do
            for x = 0, sw, spriteSize do
                c.data[#c.data+1] = sprite.create(img, spriteSize, x, y)
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
                sheets = sheets..m.SER_SHEET_DELIM
            end

            sheets = sheets..s.serialize()
        end

        local data = ""

        for i, d in ipairs(c.data) do
            if i > 1 then
                data = data..m.SER_DATA_DELIM
            end

            data = data..d.serialize()
        end

        return string.format("%d%s%s%s%s", c.spriteSize, m.SER_DELIM, sheets, m.SER_DELIM, data)
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

---@param serialized string
---@return spriteCollection?
function m.load(serialized)
    local parts = utils.split(serialized, m.SER_DELIM)

    local sprSize = tonumber(parts[1])

    if sprSize == nil then
        return
    end

    local c = m.create(sprSize)

    local serializedSheets = utils.split(parts[2], m.SER_SHEET_DELIM)

    for _, s in ipairs(serializedSheets) do
        c.addSpriteSheet(sheetMeta.deserialize(s))
    end

    local serializedData = utils.split(parts[3], m.SER_DATA_DELIM)

    for i, s in ipairs(serializedData) do
        c.data[i].load(s)
    end

    return c
end

return m