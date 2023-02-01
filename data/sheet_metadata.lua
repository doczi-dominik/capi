---@class sheetMetadata
---@field name string
---@field spritesheet love.ImageData
---@field encodeSheet fun():string
---@field serialize fun():string

local m = {}

---@param name string
---@param spritesheet love.ImageData
---@return sheetMetadata
function m.createSheetMetadata(name, spritesheet)
    local m = {}  ---@type sheetMetadata

    m.name = name
    m.spritesheet = spritesheet

    function m.encodeSheet()
        return m.spritesheet:encode("png"):getString()
    end

    function m.serialize()
        return string.format("%s;sm;%s", m.name, m.encodeSheet())
    end

    return m
end

return m