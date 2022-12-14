local m = {}
local button = require("editor.button")
local slider = require("editor.slider")

m.selectionSize = 1

local testImage

function m.init()
    m.buttons = {
        button.createStyledButton("Import png", FILEMANAGER.fileDialoge()),
        button.createStyledButton("<", function() m.selectionSize = m.selectionSize - 1 end),
        button.createStyledButton(">", function() m.selectionSize = m.selectionSize + 1 end),
    }
end

function m.resize()
end

function m.mousepressed(x, y)
    if x < ACTIONBAR.width or x > ACTIONBAR.width + PANEL.width then
        return
    end

    if y < 50 then
        testImage = FILEMANAGER.readFileData()
    end
end

function m.draw(x,y,w,h)
    LG.print(PANEL.selectedPage,x,y)

    --import button
    m.buttons[1].draw(x,y,w,50)

    m.buttons[2].draw(x,y + 50 + PANEL.padding, 50, 50)
    m.buttons[3].draw(x + w - 50,y + 50 + PANEL.padding, 50, 50)

    LG.print("Grid size",x + w/2 - FONT:getWidth("Grid size")/2,y + 55)
    LG.print(tostring(m.selectionSize * 8),x + w/2 - FONT:getWidth("00")/2,y + 55 + FONT:getHeight("00"))


    if testImage ~= nil then
        LG.draw(testImage, x + w, y)
    end
end

return m
