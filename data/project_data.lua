local sprites = require("data.sprite_collection")
local cells = require("data.cell_collection")
local utils = require("data.utils")

local m = {}

m.SER_DELIM = ";pd;"

---@class projectData
---@field version integer
---@field sprites spriteCollection
---@field cells cellCollection
---@field serialize fun():string

---@param spriteSize integer
---@param mapWidth integer
---@param mapHeight integer
---@return projectData
function m.create(spriteSize, mapWidth, mapHeight)
    local p = {}  ---@type projectData

    p.version = 0
    p.sprites = sprites.create(spriteSize)
    p.cells = cells.create(mapWidth, mapHeight)

    function p.serialize()
        return string.format("%d%s%s%s%s", p.version, m.SER_DELIM, p.sprites.serialize(), m.SER_DELIM, p.cells.serialize())
    end

    return p
end

---@param serialized string
---@return projectData?
function m.load(serialized)
    local parts = utils.split(serialized, m.SER_DELIM)

    local ver = tonumber(parts[1])

    if ver == nil then
        return
    end

    local sprs = sprites.load(parts[2])

    if sprs == nil then
        return
    end

    local cls = cells.load(parts[3])

    if cls == nil then
        return
    end

    local p = m.create(-1, -1, -1)

    p.version = ver
    p.sprites = sprs
    p.cells = cls

    return p
end

return m