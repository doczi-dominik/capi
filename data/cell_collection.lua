local cell = require("data.cell")
local utils = require("data.utils")

local m = {}

m.SER_DELIM = ";cc;"
m.SER_DATA_DELIM = ";cc-d;"

---@class cellCollection
---@field width integer
---@field height integer
---@field data cell[][]
---@field serialize fun():string
---@field exportForLibrary fun()

---@param width integer
---@param height integer
---@return cellCollection
function m.create(width, height)
    local c = {}

    c.width = width
    c.height = height
    c.data = {}  ---@type cell[][]

    for y = 1, height do
        c.data[y] = {}

        for x = 1, width do
            c.data[y][x] = cell.create()
        end
    end

    function c.serialize()
        local data = ""

        for y = 1, c.height do
            for x = 1, c.width do
                if y ~= 1 and x ~= 1 then
                    data = data..m.SER_DATA_DELIM
                end

                data = data..c.data[y][x].serialize()
            end
        end

        return string.format("%d%s%d%s%s", c.width, m.SER_DELIM, c.height, m.SER_DELIM, data)
    end

    return c
end

---@param serialized string
---@return cellCollection?
function m.load(serialized)
    local parts = utils.split(serialized, m.SER_DELIM)

    local w = tonumber(parts[1])
    local h = tonumber(parts[2])

    if w == nil or h == nil then
        return
    end

    local c = m.create(w, h)

    for i, d in ipairs(utils.split(parts[3], m.SER_DATA_DELIM)) do
        local y = math.ceil(i / w)
        local x = math.floor((i - 1) % w) + 1

        c.data[y][x] = cell.load(d)
    end

    return c
end

return m