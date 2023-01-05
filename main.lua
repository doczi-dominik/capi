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
local spriteInfo = {}
local spritePalette = {}
local flagInfo = {}
local toolMediator = require("data.tool_mediator")

ROOT = require("ui.interface").createRoot(panelInfo, sheetInfo, toolMediator)
ROOT.computeLayout()

local spriteCollection = require("data.sprite_collection")(16)

spriteCollection.addSpriteSheet("Test Sheet", love.image.newImageData("assets/image/test.png"))

local cellCollection = require("data.cell_collection")(8, 8)

SHEET = require("sheet.sheet")
SHEET.init({
    info = sheetInfo,
    sprites = spriteCollection,
    cells = cellCollection,
    toolMediator = toolMediator
})

PAGES = {
    require("ui.pageview.spritesheetView").createSpriteSheet(spriteInfo),
    require("ui.pageview.spritesView").createSprite(spriteInfo,spritePalette),
    require("ui.pageview.flagView").createFlagView(flagInfo),
    require("ui.pageview.projectView").createExportView()
}

panelInfo.setChild(PAGES[1])

--#region

function love.load()
    DUI.load()
end

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

function love.keypressed(key, scancode, isrepeat)
    DUI.keypressed(key, scancode, isrepeat)
end

function love.textinput(t)
    DUI.textinput(t)
end

--#endregion

love.resize(LG.getDimensions())