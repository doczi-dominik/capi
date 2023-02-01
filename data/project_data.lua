local createSprites = require("data.sprite_collection")
local createCells = require("data.cell_collection")

local m = {}

---@class projectData
---@field version integer
---@field sprites spriteCollection
---@field cells cellCollection
---@field serialize fun():string

local function split(s, delim)
    local result = {}

    for match in (s..delim):gmatch("(.-)"..delim) do
        table.insert(result, match)
    end

    return result
end

function m.create(spriteSize)
    local p = {}

    p.version = 0
    p.sprites = createSprites(spriteSize)
    p.cells = createCells(8, 8)

    function p.serialize()
        return string.format("%d;pd;%s;pd;%s", p.version, p.sprites.serialize(), p.cells.serialize())
    end

    return p
end

function m.load(serialized)
end

return m