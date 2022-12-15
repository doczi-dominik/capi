local button = require("editor.button")

local m = {}

m.GRID_SIZE_STR = "Grid Size"

m.selectionSize = 1

function m.init()
    m.importBtn = button.createStyledButton("Import png")
    m.reduceGridBtn = button.createStyledButton("<")
    m.increaseGridBtn = button.createStyledButton(">")
end

function m.import()
end

function m.reduceGrid()
    m.selectionSize = (m.selectionSize - 2) % 5 + 1
end

function m.increaseGrid()
    m.selectionSize = (m.selectionSize) % 5 + 1
end

function m.resize()
end

function m.mousepressed(x, y, button)
    local w = ACTIONBAR.width + PANEL.width

    if x < ACTIONBAR.width or x > w then
        return
    end

    if y < 50 then
        m.import()
        return
    end

    if x < ACTIONBAR.width + 50 then
        m.reduceGrid()
    elseif x > w - 50 then
        m.increaseGrid()
    end
end

function m.draw(x,y,w,h)
    m.importBtn.draw(x,y,w,50)
    m.reduceGridBtn.draw(x,y + 50 + PANEL.padding, 50, 50)
    m.increaseGridBtn.draw(x + w - 50,y + 50 + PANEL.padding, 50, 50)

    LG.print(m.GRID_SIZE_STR,x + w/2 - FONT:getWidth(m.GRID_SIZE_STR)/2,y + 55)
    LG.print(tostring(m.selectionSize * 8),x + w/2 - FONT:getWidth("00")/2,y + 55 + FONT:getHeight())
end

return m
