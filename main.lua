require("editor.colors")
LG = love.graphics


DESIGN_W, DESIGN_H = 1280, 720
WINDOW_W, WINDOW_H = 0, 0
SCALE = 0

FONT = LG.newFont("assets/font/monogram-extended.ttf", 28)
LG.setFont(FONT)


ACTIONBAR = require("editor.actionbar")
PANEL = require("editor.panel")
FILEMANAGER = require("editor.fileManager")

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
--[[
mainmenu = newVerticalContainer()

mainmenu.padding = 8



local m = {}

function m.createContainer(widgets)
    local c = {}

    c.widgets = widgets

    function c.draw()
        for y = 1, #widgets do
            local row = widgets[y]

            for x = 1, #row do
                local dx, dy

                row[x].draw(dx, dy)
            end
        end
    end
end


return m

local root = m.createContainer({
    { m.createContainer({}), m.createText("Asdaf"), m.createButton("fjdsfjskdl", function() end)  },
    { m.createContainer()}
})



local m = {}

function m.init()
    m.images = {

    }
end

function m.draw()

end


local images = {
    [0] = LG.newImage("fjdkf"),
    [1] = LG.newImage("fdf")
}

local map = {
    { {0, {"fjdkf", "kfjdk", "jfdk"}}, {1, 2}, },
    { {1}, {0}, },
}
]]