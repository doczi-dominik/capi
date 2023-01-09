---@diagnostic disable: duplicate-set-field


------- GLOBALS ------

--#region
DESIGN_W, DESIGN_H = 1280, 720
WINDOW_W, WINDOW_H = 0, 0
SCALE = 0

require("ui.colors")
require("ui.style")

FONT = STYLE.FONTS.DEFAULT
FONT_HEIGHT = FONT:getHeight()
--#endregion


-------- LOVE CONFIG -------

--#region
LG = love.graphics
LG.setDefaultFilter("nearest","nearest")

LG.setFont(FONT)
--#endregion


------ LIBRARY SETUP ---------

--#region
DUI = require("libs.duckUI")
DUI.setDefaultResolution(DESIGN_W,DESIGN_H)
--#endregion


local sheetInfo = {}
local panelInfo =  {}
local spriteInfo = {}
local spritePalette = {}
local flagInfo = {}

-- Set up multiple windows
local WINDOWS = {
    EDITOR = require("ui.interface").createRoot(panelInfo, sheetInfo),
    PROJECT_WINDOW = require("ui.projectWindow").createWindow(),
}

-- Set the current window to the project select screen
local current_window = WINDOWS.PROJECT_WINDOW

for i = 1, #WINDOWS do
    WINDOWS[i].computeLayout()
end

-- Set up multiple sidebar pages
PAGES = {
    require("ui.pageview.spritesheetView").createSpriteSheet(WINDOWS.EDITOR,spriteInfo),
    require("ui.pageview.spritesView").createSprite(WINDOWS.EDITOR,spriteInfo,spritePalette),
    require("ui.pageview.flagView").createFlagView(WINDOWS.EDITOR,flagInfo),
    require("ui.pageview.projectView").createExportView(WINDOWS.EDITOR)
}

-- Default page when the program starts
panelInfo.setChild(PAGES[1])

local spriteCollection = require("data.sprite_collection")(16)

spriteCollection.addSpriteSheet("Test Sheet", love.image.newImageData("assets/image/test.png"))

local cellCollection = require("data.cell_collection")(8, 8)

SHEET = require("sheet.sheet")
SHEET.init({
    info = sheetInfo,
    sprites = spriteCollection,
    cells = cellCollection
})



--#region- LOVE FUNCTIONS

function love.load()
    DUI.load()
end

function love.resize(w, h)
    WINDOW_W, WINDOW_H = w, h
    SCALE = math.min(WINDOW_W / DESIGN_W, WINDOW_H / DESIGN_H)

    DUI.resize(w,h)
    current_window.computeLayout()
end

function love.mousepressed(x, y, button)
    current_window.mouseInput(x, y, button, "mousepressed")
end

function love.mousereleased(x, y, button)
    current_window.mouseInput(x, y, button, "mousereleased")
end

function love.mousemoved(x, y)
    current_window.mouseInput(x, y, nil, "mousemoved")
end

function love.wheelmoved(x, y)
    current_window.mouseInput(x, y, nil, "wheelmoved")
end

function love.update(dt)
end

function love.draw()
    current_window.draw()
end

function love.keypressed(key, scancode, isrepeat)
    DUI.keypressed(key, scancode, isrepeat)
end

function love.textinput(t)
    DUI.textinput(t)
end

--#endregion

love.resize(LG.getDimensions())