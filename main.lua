---@diagnostic disable: duplicate-set-field

LG = love.graphics

DESIGN_W, DESIGN_H = 1280, 720
WINDOW_W, WINDOW_H = 0, 0
SCALE = 0

FONT = LG.newFont("assets/font/monogram-extended.ttf", 28)
FONT_HEIGHT = FONT:getHeight()
LG.setFont(FONT)


SHEETINFO = {}
PANELINFO = {}

-- LIBRARY SETUP
DUI = require("libs.duckUI")
DUI.setDefaultResolution(DESIGN_W,DESIGN_H)
require("ui.colors")
require("ui.style")

ROOT = require("ui.interface")
ROOT.computeLayout()



--SHEET = require("sheet.sheet")
--SHEET.init(512, 512)

PAGES = {
    require("ui.pageview.spritesheetView"),
    require("ui.pageview.nemtom"),
    require("ui.pageview.exportView")
}
PANELINFO.setChild(PAGES[1])

function love.resize(w, h)
    WINDOW_W, WINDOW_H = w, h
    SCALE = math.min(WINDOW_W / DESIGN_W, WINDOW_H / DESIGN_H)

    DUI.resize(w,h)
    ROOT.computeLayout()
end

function love.mousepressed(x, y, button)
    --SHEET.mousepressed(x, y, button)
    ROOT.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    --SHEET.mousereleased(x, y, button)
end

function love.mousemoved(x, y)
   --SHEET.mousemoved(x, y)
end

function love.wheelmoved(x, y)
    --SHEET.wheelmoved(x, y)
end

function love.mouse.isDown()
    ROOT.mouseIsDown()
end

function love.update(dt)
end

function love.draw()
    --SHEET.draw()

    ROOT.draw()
end

love.resize(LG.getDimensions())