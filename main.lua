LG = love.graphics

DESIGN_W, DESIGN_H = 1280, 720
WINDOW_W, WINDOW_H = 0, 0
SCALE = 0

FONT = LG.newFont("assets/font/monogram-extended.ttf", 28)
FONT_HEIGHT = FONT:getHeight()
LG.setFont(FONT)

require("ui.colors")

ACTIONBAR = require("ui.actionbar")
PANEL = require("ui.panel")
SHEET = require("sheet.sheet")

ACTIONBAR.init()
PANEL.init()
SHEET.init(512, 512)

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

function love.wheelmoved(x, y)
    SHEET.wheelmoved(x, y)
end

function love.update(dt)
    SHEET.update(dt)
end

function love.draw()
    PANEL.draw()
    ACTIONBAR.draw()

    SHEET.draw()
end