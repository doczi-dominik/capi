
local m = {}

m.DESIGN_WIDTH = 256
m.DESIGN_PADDING = 10

m.width = 0
m.padding = 0

m.selectedPage = 1

function m.init()
    m.pages = {

    }
end

function m.resize()
    m.padding = m.DESIGN_PADDING * SCALE
    m.width = m.DESIGN_WIDTH * SCALE
end

function m.mousepressed(x, y, button)
    do
        return
    end

    m.pages[m.selectedPage].mousepressed(x, y, button)
end

function m.draw()
    LG.setColor(COLOR.PRIMARY)
    LG.rectangle("fill", ACTIONBAR.width, 0, ACTIONBAR.width + m.width, WINDOW_H)
    LG.setColor(COLOR.BUTTON_HIGHLIGHT)
    LG.rectangle("fill", ACTIONBAR.width, ACTIONBAR.padding, ACTIONBAR.width + m.width - ACTIONBAR.padding, WINDOW_H - ACTIONBAR.padding * 2)
    LG.setColor(1, 1, 1)
    

    do
        return
    end
    
    m.pages[m.selectedPage].draw()
end

return m