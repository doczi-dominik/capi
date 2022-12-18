---@diagnostic disable: duplicate-set-field
local lib = {}

local LG = love.graphics
lib.default_color = {1,1,1}
lib.default_font = LG.getFont()
lib.window_w,lib.window_h = LG.getDimensions()




--------------- BASECLASS ---------------

function lib.baseClass(options, style)
    local c = {}
    options = options or {}
    style = style or {}
    c.debug_name = options.debug_name or ""
    c.children = options.children or {}
    c.parent = c.parent or {}
    c.outVar = options.outVar or {}
    c.padding = style.padding or options.padding or 0
    c.bg_color = style.bg_color or options.bg_color
    c.fillMode = style.fillMode or options.fillMode or "fill"
    c.sizeFactor = style.sizeFactor or options.sizeFactor or 1
    c.margin = style.margin or options.margin or 0

    for i = 1,#c.children do
        c.children[i].parent = c
    end

    function c.draw()

        if c.bg_color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,c.x,c.y,c.w,c.h)
        end

        for i=1,#c.children do
            c.children[i].draw()
        end
    end

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
    end

    function c.mouseInput( x, y, button, type)
        for i = 1, #c.children do
            c.children[i].mouseInput(x,y,button, type)
        end
    end

    function c.outVar.setChild(children)
        c.children = children
        for i = 1,#c.children do
            c.children[i].parent = c
        end
    end

    return c
end



------------ VERTICAL CONTAINER -------------

function lib.newVerticalContainer(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
        local cy = c.y
        for i=1,#c.children do
            local ch = c.h * c.children[i].sizeFactor           
            c.children[i].computeLayout(c.x + c.padding, cy + c.padding ,c.w - c.padding * 2,math.min(ch, c.h-cy + c.y) - c.padding * 2)

            cy = cy + ch
        end
    end

    function c.mouseInput( x, y, button, type)
        local cx,cy = x,y
        if type == "wheelmoved" then
            cx,cy = love.mouse.getPosition()
        end
        local lastcy = 0
        local ccy = c.y
        for i = 1, #c.children do
            
            ccy = ccy + (c.children[i].sizeFactor * c.h) + c.padding
            if cy < ccy and cy > lastcy then
                c.children[i].mouseInput( x, y, button, type)
                break
            end
            lastcy = ccy
        end
    end

    return c
end

----------------- TEXT -------------------

function lib.newText(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)
    c.text = options.text or ""
    c.alignmet = style.alignmet or options.alignmet or "center"
    c.color = style.color or options.color or {0,0,0}
    c.tw = 0

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
        c.tw = w
    end

    function c:draw()
        LG.setColor(c.color)
        
        if c.alignmet == "center" then
            LG.print(c.text,c.x + c.w/2 - lib.default_font:getWidth(c.text)/2,c.y + c.h/2 - lib.default_font:getHeight()/2)    
        elseif c.alignmet == "+90" then
            LG.print(c.text,
            c.x + c.tw/2 - FONT:getHeight()/1.7,
            c.y + c.h/2 + FONT:getWidth(c.text)/2,
            -math.pi/2,
            1,1)
        end
    end

    return c
end


------------ HORIZONTAL CONTAINER -------------

function lib.newHorizontalContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
        local cx = c.x
        for i=1,#c.children do
            local cw = c.w * c.children[i].sizeFactor
            c.children[i].computeLayout(
                cx + c.padding,
                y + c.padding,
                math.min(cw,c.w - cx + c.x),
                c.h - c.padding * 2)
            cx = cx + cw
        end
    end

    function c.mouseInput( x, y, button,type)
        local cx,cy = x,y
        if type == "wheelmoved" then
            cx,cy = love.mouse.getPosition()
        end
        local ccx = c.x
        for i = 1, #c.children do
            ccx = ccx + (c.children[i].sizeFactor * c.w) + c.padding
            if cx < ccx then
                c.children[i].mouseInput( x, y, button,type)
                break
            end
        end
    end


    return c
end

------------ CONTAINER -----------------

function lib.newContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.outVar.x,c.outVar.y,c.outVar.w,c.outVar.h   = x,y,w,h
    end

    function c.mouseInput(x, y, button, type)
        if type == "mousepressed" and c.outVar.mousepressed ~= nil then
            c.outVar.mousepressed(x,y,button)
        elseif type == "mousereleased"  and c.outVar.mousereleased ~= nil then
            c.outVar.mousereleased(x,y,button)
        elseif type == "mousemoved" and c.outVar.mousemoved ~= nil then
            c.outVar.mousemoved(x,y)
        elseif type == "wheelmoved" and c.outVar.wheelmoved ~= nil then
            c.outVar.wheelmoved(x,y)
        end
    end

    return c
end


------------ BUTTON -------------

function lib.newButton(options, style)
    local c = lib.baseClass(options, style)
    style = style or {}
    c.onClick = style.onClick or options.onClick
    c.drawExt = style.drawExt or options.drawExt
    c.color = style.color or options.color or {0,0,0}
    c.highlight_color = style.highlight_color or options.highlight_color 
    c.border_color = style.border_color or options.border_color
    c.border_size = style.border_size or options.border_size or 0
    c.text = options.text or ""
    c.text_scale = style.text_scale or options.text_scale or 1
    c.toggleable = style.toggleable or options.toggleable
    c.dependencyTable = style.dependencyTable or options.dependencyTable
    c.dependencyIndex = options.dependencyIndex
    c.alignmet = style.alignmet or options.alignmet or "center"
    c.defaultOn = style.defaultOn or options.defaultOn or false
    c.isOn = c.defaultOn
    c.tw = 0

    if c.dependencyIndex ~= nil then
        c.dependencyTable[c.dependencyIndex] = c
    end

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin,y + c.margin,w - c.margin * 2,h - c.margin * 2
        c.tw = w
    end

    function c.mouseInput(x, y, button, type)
        if type == "mousepressed" then
            c.mousepressed(x,y,button)
        end
    end

    function c.mousepressed( x, y, button)
        if c.toggleable then
            c.isOn = not c.isOn

        elseif c.dependencyIndex ~= nil then
            for i = 1, #c.dependencyTable do
                c.dependencyTable[i].isOn = false
            end
            c.isOn = true
            c:onClick()
        elseif c.onClick ~= nil then
            c:onClick() 
        end
    end

    function c:draw()
        if c.border_color ~= nil then
            LG.setColor(c.border_color)
            LG.rectangle("fill",c.x,c.y,c.w,c.h)
        end

        if c.highlight_color ~= nil and c.isOn then
            LG.setColor(c.highlight_color)
            LG.rectangle(c.fillMode,c.x + c.border_size,c.y + c.border_size,c.w - c.border_size * 2,c.h - c.border_size * 2)
        elseif c.bg_color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,c.x + c.border_size,c.y + c.border_size,c.w - c.border_size * 2,c.h - c.border_size * 2)
        end

        
        ---- handle text -----
        LG.setColor(c.color)
        
        if c.alignmet == "center" then
            LG.print(c.text,c.x + c.w/2 - lib.default_font:getWidth(c.text)/2,c.y + c.h/2 - lib.default_font:getHeight()/2,0,c.text_scale,c.text_scale)    
        elseif c.alignmet == "+90" then
            LG.print(c.text,
            c.x + c.tw/2 - FONT:getHeight()/1.7,
            c.y + c.h/2 + FONT:getWidth(c.text)/2,
            -math.pi/2,
            1,1)
        end

        if c.drawExt ~= nil then
            c:drawExt()
        end
    end

    return c
end


------------ SLIDER --------------

function lib.newSlider(options, style)
    local c = lib.baseClass(options, style)

    function c.draw()
    end
end



------------ MAIN CONTAINER -------------

function lib.newMainContainer(options, style)
    local c = lib.baseClass(options, style)

    c.child = options.child or {}

    function c.draw()
        if c.color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,0,0,lib.window_w,lib.window_h)
        end

        c.child.draw()
    end

    function c.computeLayout()
        c.child.sizeFactor = 1
        c.child.computeLayout(0,0,lib.window_w,lib.window_h)
    end

    function c.mouseInput(x, y, button, type)
        c.child.mouseInput(x, y, button, type)
    end

    return c
end



--------- CONFIG FUNCTIONS -----------

function lib.getScale()
    return math.min(lib.window_w / lib.default_res[1], lib.window_h / lib.default_res[2])
end

function lib.resize(w,h)
    lib.window_w = w
    lib.window_h = h
end

function lib.setDefaultColor(color)
    lib.default_color = color
end

function lib.setDefaultResolution(w,h)
    lib.default_res = {w,h}
end

function lib.setDefaultFont(font)
    lib.default_font = font
end



return lib