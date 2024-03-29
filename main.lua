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
LG.setDefaultFilter("nearest", "nearest")

LG.setFont(FONT)
--#endregion

------ LIBRARY SETUP ---------

--#region
DUI = require("libs.duckUI")
DUI.setDefaultResolution(DESIGN_W, DESIGN_H)
--#endregion

-- TODO: CLEAN UP OBJECT LIFECYCLES
--		 REFACTOR MOUSEMOVED SO THAT THE BUTTON VAR IS THE THIRD PARAMETER IN THE FUNCTION

local currentMouseDown

local panelInfo =  {}
local spriteInfo = {}
local flagInfo = {}
local toolMediator = require("data.tool_mediator")

local projectData = require("data.project_data").create(16, 8, 8)
projectData.sprites.addSpriteSheet("Test Sheet", love.image.newImageData("assets/image/test.png"))

-- Set up multiple windows
WINDOWS = {
    EDITOR = require("ui.interface").createRoot(projectData, panelInfo, toolMediator),
    PROJECT_WINDOW = require("ui.projectWindow").createWindow(),
}

-- Set the current window to the project select screen
CURRENT_WINDOW = WINDOWS.PROJECT_WINDOW

local spritePalette = require("ui.spritePalette")(projectData.sprites)

-- Set up multiple sidebar pages
PAGES = {
    require("ui.pages.spritesheetView").createSpriteSheet(WINDOWS.EDITOR,spriteInfo),
    require("ui.pages.spritesView").createSprite(WINDOWS.EDITOR,spriteInfo,spritePalette),
    require("ui.pages.flagView").createFlagView(WINDOWS.EDITOR,flagInfo),
    require("ui.pages.projectView").createExportView(WINDOWS.EDITOR)
}

-- Default page when the program starts
panelInfo.setChild(PAGES[1])

--#region- LOVE FUNCTIONS

function love.load()
	love.window.maximize()
	DUI.load()
end

function love.resize(w, h)
	WINDOW_W, WINDOW_H = w, h
	SCALE = math.min(WINDOW_W / DESIGN_W, WINDOW_H / DESIGN_H)

	DUI.resize(w, h)
	CURRENT_WINDOW.computeLayout()
end

function love.mousepressed(x, y, button)
	currentMouseDown = button
	CURRENT_WINDOW.mouseInput(x, y, button, "mousepressed")
end

function love.mousereleased(x, y, button)
	currentMouseDown = nil
	CURRENT_WINDOW.mouseInput(x, y, button, "mousereleased")
end

function love.mousemoved(x, y)
	CURRENT_WINDOW.mouseInput(x, y, currentMouseDown, "mousemoved")
end

function love.wheelmoved(x, y)
	CURRENT_WINDOW.mouseInput(x, y, currentMouseDown, "wheelmoved")
end

function love.update(dt) end

function love.draw()
	CURRENT_WINDOW.draw()
end

function love.keypressed(key, scancode, isrepeat)
	DUI.keypressed(key, scancode, isrepeat)
end

function love.textinput(t)
	DUI.textinput(t)
end

--#endregion

love.resize(LG.getDimensions())
