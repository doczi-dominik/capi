require("ui.colors")
LG = love.graphics

DESIGN_W, DESIGN_H = 1280, 720
WINDOW_W, WINDOW_H = 0, 0
SCALE = 0

FONT = LG.newFont("assets/font/monogram-extended.ttf", 28)
FONT_HEIGHT = FONT:getHeight()
LG.setFont(FONT)

ACTIONBAR = require("ui.actionbar")
PANEL = require("ui.panel")
FILEMANAGER = require("ui.fileManager")

ACTIONBAR.init()
PANEL.init()

function love.resize(w, h)
    WINDOW_W, WINDOW_H = w, h
    SCALE = math.min(WINDOW_W / DESIGN_W, WINDOW_H / DESIGN_H)

    ACTIONBAR.resize()
    PANEL.resize()
end

love.resize(LG.getDimensions())

function love.mousepressed(x, y, button)
    ACTIONBAR.mousepressed(x, y, button)
    PANEL.mousepressed(x, y, button)
end

function love.update(dt)
end

function love.draw()
    PANEL.draw()
    ACTIONBAR.draw()
end