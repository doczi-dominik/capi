local createCell = require("data.cell")

---@class cellCollection
---@field width integer
---@field height integer
---@field data cell[][]
---@field exportForLibrary fun()

---@return cellCollection
local function createCollection(width, height)
    local c = {}

    c.width = width
    c.height = height
    c.data = {}  ---@type cell[][]

    for y = 1, height do
        c.data[y] = {}

        for x = 1, width do
            c.data[y][x] = createCell()
        end
    end

    return c
end

return createCollection