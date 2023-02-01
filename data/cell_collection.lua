local createCell = require("data.cell")

---@class cellCollection
---@field width integer
---@field height integer
---@field data cell[][]
---@field serialize fun():string
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

    function c.serialize()
        local data = ""

        for y = 1, c.height do
            for x = 1, c.width do
                if y ~= 1 and x ~= 1 then
                    data = data..";cc-d;"
                end

                data = data..c.data[y][x].serialize()
            end
        end

        return string.format("%d;cc;%d;cc;%s", c.width, c.height, data)
    end

    return c
end

return createCollection