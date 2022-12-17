local button = require("ui.button")

local m = {}

m.GRID_SIZE_STR = "Selection Size"

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

local function getRow(y, i)
    return y + (50 + PANEL.padding) * i
end

local function drawRange(x, y, w, label, value)
    m.reduceBtn.draw(x, y, 50, 50)
    m.increaseBtn.draw(x + w - 50, y, 50, 50)

    LG.print(label,x + w/2 - FONT:getWidth(label)/2, y)

    local str = tostring(value)

    LG.print(str, x + w/2 - FONT:getWidth(str)/2, y + FONT_HEIGHT)
end

function m.init()
    m.importBtn = button.createStyledButton("Import png")
    m.reduceBtn = button.createStyledButton("<")
    m.increaseBtn = button.createStyledButton(">")
end

function m.resize()
end

function m.mousepressed(x, y, button)
    local w = ACTIONBAR.width + PANEL.width

    if x < ACTIONBAR.width or x > w then
        return
    end

    if y < 50 then
        import()
        return
    end

    if x < ACTIONBAR.width + 50 then
        if y < 100 then
            reduceSprite()
        else
            reduceGrid()
        end
    elseif x > w - 50 then
        if y < 100 then
            increaseSprite()
        else
            increaseGrid()
        end
    end
end

function m.draw(x,y,w,h)
    m.importBtn.draw(x,y,w,50)

    drawRange(x, getRow(y, 1), w, "Sprite Size", m.spriteSize * 8)

    local lineY = getRow(y, 2) + 25
    LG.setColor(COLOR.PRIMARY)
    LG.line(x, lineY, x + w, lineY)
    LG.setColor(COLOR.WHITE)

    drawRange(x, getRow(y, 3), w, "Sel. Size", m.selectionSize * 8)
end

return m
