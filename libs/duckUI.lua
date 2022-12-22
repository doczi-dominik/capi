---@diagnostic disable: duplicate-set-field
local lib = {}

local LG = love.graphics
lib.default_color = {1,1,1}
lib.default_font = LG.getFont()
lib.window_w,lib.window_h = LG.getDimensions()

--[[
        padding/margin
    x       y       w       h
    left   up    right    down

]]


--------------- BASECLASS ---------------

---@class options
---@field children table | any Optional library components
---@field bg_color {r:number,g:number,b:number,a:number} Background color
---@field debug_name string String used for finding the right component and debugging its info
---@field fillMode "fill" | "line"
---@field margin number | {left: number,up: number,right: number,down: number}
---@field padding number | {left: number,up: number,right: number,down: number}
---@field outVar table Used to export the components x,y,w,h and redirect its input
---@field sizeFactor number 0 > 1 | 0% > 100% Percentage of element size
---@field text string Text to display
---@field color {r:number,g:number,b:number,a:number} Text color
---@field alignmet "center" | "+90"
---@field onClick function Function to call when a button is pressed
---@field drawExt function Settable draw function that gets called before any other draw in the component
---@field highlight_color {r:number,g:number,b:number,a:number} The color that is set on an active button
---@field border_color {r:number,g:number,b:number,a:number} 
---@field border_size number
---@field toggleable boolean Sets the button to a toggle switch
---@field dependencyTable table
---@field dependencyIndex number
---@field sprite love.Image
---@field defaultOn boolean
---@field text_scale number
---@field child table

---comment
---@param options? options?
---@param style? options?
function lib.baseClass(options, style)
    local c = {}
    options = options or {} ---@type table
    style = style or {} ---@type table
    c.debug_name = options.debug_name or "" ---@type string
    c.children = options.children or {} ---@type table
    c.parent = c.parent or {}   ---@type table
    c.outVar = options.outVar or {} ---@type table
    c.padding = style.padding or options.padding or 0   ---@type number | {left: number,up: number,right: number,down: number}
    c.bg_color = style.bg_color or options.bg_color ---@type table 
    c.fillMode = style.fillMode or options.fillMode or "fill" ---@alias modes "fill" | "line" 
    c.sizeFactor = style.sizeFactor or options.sizeFactor or 1  ---@type number 0 > 1 | 0% > 100% Percentage of element size
    c.margin = style.margin or options.margin or 0  ---@type number | {left: number,up: number,right: number,down: number}

    local function handleNumberInput(t)
        local temp = t
        t = {}
        for i =1,4 do
            t[i] = temp
        end

        return t
    end

    if type(c.padding) == "number" then
        c.padding = handleNumberInput(c.padding)
    end

    if type(c.margin) == "number" then
        c.margin = handleNumberInput(c.margin)
    end


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
        c.x,c.y,c.w,c.h = x + c.margin[1],y + c.margin[2],w - c.margin[3] * 2,h - c.margin[4] * 2
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

---@param options? options
---@param style? options
function lib.newVerticalContainer(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin[1],y + c.margin[2],w - c.margin[3] * 2,h - c.margin[4] * 2
        local cy = c.y
        for i=1,#c.children do
            local ch = c.h * c.children[i].sizeFactor           
            c.children[i].computeLayout(c.x + c.padding[1], cy + c.padding[2] ,c.w - c.padding[3] * 2,math.min(ch, c.h-cy + c.y) - c.padding[4] * 2)

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
            
            ccy = ccy + (c.children[i].sizeFactor * c.h) + c.padding[2]
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

---@param options? options
---@param style? options
function lib.newText(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)
    c.text = options.text or ""
    c.alignmet = style.alignmet or options.alignmet or "center"
    c.color = style.color or options.color or {0,0,0}
    c.tw = 0

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin[1],y + c.margin[2],w - c.margin[3] * 2,h - c.margin[4] * 2
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

    function c.outVar.setText(text)
        c.text = text
    end

    return c
end


------------ HORIZONTAL CONTAINER -------------

---@param options? options
---@param style? options
function lib.newHorizontalContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin[1],y + c.margin[2],w - c.margin[3] * 2,h - c.margin[4] * 2
        local cx = c.x
        for i=1,#c.children do
            local cw = c.w * c.children[i].sizeFactor
            c.children[i].computeLayout(
                cx + c.padding[1],
                y + c.padding[2],
                math.min(cw,c.w - cx + c.x) - c.padding[3] * 2,
                c.h - c.padding[4] * 2)
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
            ccx = ccx + (c.children[i].sizeFactor * c.w) + c.padding[1]
            if cx < ccx then
                c.children[i].mouseInput( x, y, button,type)
                break
            end
        end
    end


    return c
end

------------ CONTAINER -----------------

---@param options? options
---@param style? options
function lib.newContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c.outVar.x,c.outVar.y,c.outVar.w,c.outVar.h   = x,y,w,h
    end

    function c:draw()
        if c.outVar.draw ~= nil then
            c.outVar.draw()
        end
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


---@param options? options
---@param style? options
function lib.newButton(options, style)
    local c = lib.baseClass(options, style)
    style = style or {}
    options = options or {}
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
    c.sprite = style.sprite or options.sprite
    c.alignmet = style.alignmet or options.alignmet or "center"
    c.defaultOn = style.defaultOn or options.defaultOn or false
    c.isOn = c.defaultOn
    c.tw = 0

    if c.dependencyIndex ~= nil then
        c.dependencyTable[c.dependencyIndex] = c
    end

    function c.computeLayout(x,y,w,h)
        c.x,c.y,c.w,c.h = x + c.margin[1],y + c.margin[2],w - c.margin[3] * 2,h - c.margin[4] * 2
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
        if c.drawExt ~= nil then
            c:drawExt()
        end

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
        if c.sprite ~= nil then
            LG.draw(c.sprite,c.x + c.border_size,c.y + c.border_size,0,c.w / c.sprite:getWidth() - c.border_size * 2, c.h / c.sprite:getHeight() - c.border_size * 2)
        end

        
        ---- handle text -----
        LG.setColor(c.color)
        
        if c.alignmet == "center" then
            LG.print(c.text,c.x + c.tw/2 - lib.default_font:getWidth(c.text)/2,c.y + c.h/2 - lib.default_font:getHeight()/2,0,c.text_scale,c.text_scale)    
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


------------ SLIDER --------------

---@param options? options
---@param style? options
function lib.newSlider(options, style)
    local c = lib.baseClass(options, style)

    function c.draw()
    end
end



------------ MAIN CONTAINER -------------

---@param options? options
---@param style? options
function lib.newMainContainer(options, style)
    local c = lib.baseClass(options, style)
    options = options or {}
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

---Resizes the current window
---@param w number
---@param h number
function lib.resize(w,h)
    lib.window_w = w
    lib.window_h = h
end

---Sets the default detail color of the library
---@param color table
function lib.setDefaultColor(color)
    lib.default_color = color
end

---Sets the default library resolution
---@param w number
---@param h number
function lib.setDefaultResolution(w,h)
    lib.default_res = {w,h}
end

---Sets the default library font
---@param font love.Font
function lib.setDefaultFont(font)
    lib.default_font = font
end



return lib