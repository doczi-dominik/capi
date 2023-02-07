local utils = require("data.utils")

local m = {}

m.SER_DELIM = ";sm;"

---@class sheetMetadata
---@field name string
---@field spritesheet love.ImageData
---@field encodeSheet fun():string
---@field serialize fun():string

---@param name string
---@param spritesheet love.ImageData
---@return sheetMetadata
function m.create(name, spritesheet)
    local d = {}  ---@type sheetMetadata

    d.name = name
    d.spritesheet = spritesheet

    function d.encodeSheet()
        return d.spritesheet:encode("png"):getString()
    end

    function d.serialize()
        return string.format("%s%s%s", d.name, m.SER_DELIM, d.encodeSheet())
    end

    return d
end

function m.deserialize(serialized)
    local parts = utils.split(serialized, m.SER_DELIM)
    local name = parts[1]

    local fd = love.filesystem.newFileData(parts[2], name)
    local decoded = love.image.newImageData(fd)

    return name, decoded
end

return m