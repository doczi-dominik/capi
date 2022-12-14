local m = {}

m.DESIGN_WIDTH = 320
m.DESIGN_PADDING = 10

m.width = 0
m.padding = 0

m.selectedPage = 1

function m.init()
    m.pages = {
        require("editor.pages.spritesheets"),
        require("editor.pages.spritesheets"),
        require("editor.pages.spritesheets")
    }

    for i=1,#m.pages,1 do
        m.pages[i].init()
    end
end

function m.resize()
    m.padding = m.DESIGN_PADDING * SCALE
    m.width = m.DESIGN_WIDTH * SCALE

    for i=1,#m.pages do
        m.pages[i].resize()
    end
end

function m.mousepressed(x, y, button)
    m.pages[m.selectedPage].mousepressed(x, y, button)
end

function m.draw()
    LG.setColor(COLOR.PRIMARY)
    LG.rectangle("fill", ACTIONBAR.width, 0, m.width, WINDOW_H)
    LG.setColor(COLOR.BUTTON_HIGHLIGHT)
    LG.rectangle("fill", ACTIONBAR.width, ACTIONBAR.padding, m.width - ACTIONBAR.padding, WINDOW_H - ACTIONBAR.padding * 2)
    LG.setColor(COLOR.WHITE)

    m.pages[m.selectedPage].draw(ACTIONBAR.width + m.padding, ACTIONBAR.padding + m.padding, m.width - ACTIONBAR.padding - m.padding * 2,DESIGN_H - (ACTIONBAR.padding * 2) - m.padding * 2)
end

return m