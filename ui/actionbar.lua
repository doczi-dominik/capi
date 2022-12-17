local button = require("ui.button")

local m = {}

m.DESIGN_WIDTH = 48
m.DESIGN_PADDING = 6

m.width = 0
m.buttonWidth = 0
m.buttonHeight = 0
m.padding = 0
m.selectedButton = 0

local function barButton(text, index)
    local bt = button.createButton(
        text,
        function()
            PANEL.selectedPage = index
        end
    )

    ---@diagnostic disable-next-line: duplicate-set-field
    function bt.draw(x, y, w, h, isSelected)
        local tw = w

        if isSelected then
            LG.setColor(COLOR.BUTTON_HIGHLIGHT)
            w = w + m.padding
        else
            LG.setColor(COLOR.BUTTON_COLOR)
        end

        LG.rectangle("fill",x,y,w,h)
        LG.setColor(COLOR.BLACK)
        LG.print(bt.text,
            x + tw/2 - FONT:getHeight()/1.7,
            y + h/2 + FONT:getWidth(bt.text)/2,
            -math.pi/2,
            1,1)
        LG.setColor(COLOR.WHITE)
    end

    return bt
end

function m.init()
    m.buttons = {
        barButton("draw",  1),
        barButton("b", 2),
        barButton("export", 3)
    }
end

function m.mousepressed(x, y, button)
    if x > m.width then
        return
    end

    m.selectedButton = math.floor(y / (WINDOW_H/#m.buttons))
    m.buttons[m.selectedButton + 1].onclick()
end

function m.resize()
    m.padding = m.DESIGN_PADDING * SCALE
    m.width = m.DESIGN_WIDTH * SCALE
    m.buttonWidth = m.width - m.padding * 2
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