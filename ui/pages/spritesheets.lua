local button = require("ui.button")

local m = {}

m.selectionSize = 1
m.spriteSize = 2

local function import()
end

local function reduceGrid()
    m.selectionSize = (m.selectionSize - 2) % 5 + 1
end

local function increaseGrid()
    m.selectionSize = (m.selectionSize) % 5 + 1
end

local function reduceSprite()
    m.spriteSize = (m.spriteSize - 2) % 17 + 1
end

local function increaseSprite()
    m.spriteSize = (m.spriteSize) % 17 + 1
end

local function drawRange(x, y, w, label, value)
    m.reduceBtn.draw(x, y, 50, 50)
    m.increaseBtn.draw(x + w - 50, y, 50, 50)

    LG.print(label,x + w/2 - FONT:getWidth(label)/2, y)

    local str = tostring(value)

    LG.print(str, x + w/2 - FONT:getWidth(str)/2, y + FONT_HEIGHT)
end

return m
