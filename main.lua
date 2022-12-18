---@diagnostic disable: duplicate-set-field

LG = love.graphics
LG.setDefaultFilter("nearest","nearest")

DESIGN_W, DESIGN_H = 1280, 720
WINDOW_W, WINDOW_H = 0, 0
SCALE = 0

FONT = LG.newFont("assets/font/monogram-extended.ttf", 28)
FONT_HEIGHT = FONT:getHeight()
LG.setFont(FONT)

-- LIBRARY SETUP
DUI = require("libs.duckUI")
DUI.setDefaultResolution(DESIGN_W,DESIGN_H)
require("ui.colors")
require("ui.style")

local sheetInfo = {}
local panelInfo =  {}

ROOT = require("ui.interface").createRoot(panelInfo, sheetInfo)
ROOT.computeLayout()

SHEET = require("sheet.sheet")
SHEET.init(sheetInfo, 8, 8)

PAGES = {
    require("ui.pageview.spritesheetView"),
    require("ui.pageview.nemtom"),
    require("ui.pageview.exportView")
}

panelInfo.setChild(PAGES[1])

function love.resize(w, h)
    WINDOW_W, WINDOW_H = w, h
    SCALE = math.min(WINDOW_W / DESIGN_W, WINDOW_H / DESIGN_H)

    DUI.resize(w,h)
    ROOT.computeLayout()
end


function love.mousepressed(x, y, button)
    ROOT.mouseInput(x, y, button, "mousepressed")
end

function love.mousereleased(x, y, button)
    ROOT.mouseInput(x, y, button, "mousereleased")
end

function love.mousemoved(x, y)
    ROOT.mouseInput(x, y, nil, "mousemoved")
end

function love.wheelmoved(x, y)
    ROOT.mouseInput(x, y, nil, "wheelmoved")
end

function love.update(dt)
end

function love.draw()
    ROOT.draw()
end

love.resize(LG.getDimensions())