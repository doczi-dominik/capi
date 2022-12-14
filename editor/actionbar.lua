local buttons = require("editor.button")
local m = {}

m.DESIGN_WIDTH = 48
m.DESIGN_PADDING = 6

m.width = 0
m.buttonWidth = 0
m.buttonHeight = 0
m.padding = 0
m.selectedButton = 0

local function buttonCallback(i)
    return function()
        PANEL.selectedPage = i
    end
end

function m.init()
    m.buttons = {
        buttons.createButton("draw",  buttonCallback(1)),
        buttons.createButton("b", buttonCallback(2)),
        buttons.createButton("c", buttonCallback(3)),
    }
end

function m.mousepressed(x, y, button)
    if x > m.width then
        return
    end

    m.selectedButton = math.floor(y / (WINDOW_H/#m.buttons))
end

function m.resize()
    m.padding = m.DESIGN_PADDING * SCALE
    m.width = m.DESIGN_WIDTH * SCALE
    m.buttonWidth = m.width - m.padding * 2
    --m.buttonHeight = WINDOW_H / #m.buttons - (m.padding * 2)
    m.buttonHeight = (WINDOW_H - m.padding * (#m.buttons + 1)) / #m.buttons
end

function m.draw()
    LG.setColor(COLOR.PRIMARY)
    LG.rectangle("fill", 0, 0, m.width, WINDOW_H)
    LG.setColor(COLOR.WHITE)

    for y = 0, #m.buttons - 1 do
        m.buttons[y + 1].draw(m.padding, m.padding + (m.padding + m.buttonHeight) * y, m.buttonWidth, m.buttonHeight, y == m.selectedButton)
    end
end

return m