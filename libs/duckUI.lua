---@diagnostic disable: duplicate-set-field
local utf8 = require("utf8")

local lib = {}

local LG = LG or love.graphics
lib.default_color = {1,1,1}
lib.default_font = LG.getFont()
lib.window_w,lib.window_h = LG.getDimensions()
lib.current_focus = {}
lib.locked_aspect_ratio = false

--------------- BASECLASS ---------------

--#region

---@class baseClassOptions
---@field children table | any Optional library components
---@field bg_color {r:number,g:number,b:number,a:number} Background color
---@field debug_name string String used for finding the right component and debugging its info
---@field fillMode "fill" | "line"
---@field margin number | {left: number,up: number,right: number,down: number}
---@field padding number | {left: number,up: number,right: number,down: number}
---@field outVar table Used to export the components x,y,w,h and redirect its input
---@field sizeFactor number 0 > 1 | 0% > 100% Percentage of element size

---@param options? baseClassOptions
---@param style? baseClassOptions
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

    --- If the user gives a single number as padding or margin, set all side dependent margin and padding to the input
    ---@param t number | {left: number,up: number,right: number,down: number}
    ---@return table 
    local function handleNumberInput(t)
        local temp = t
        t = {}
        for i =1,4 do
            t[i] = temp * lib.getScale()
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

    ---comment
    ---@param x number
    ---@param y number
    ---@param w number
    ---@param h number
    ---@param f? function # Specify object specific calculations
    function c._computeLayout(x,y,w,h,f)
        c.computeX,c.computeY,c.computeW,c.computeH,c.computeFun = x,y,w,h,f -- We don'T have to recalcuale it ourselves, only use if the data is guaranteed to not change

        c.outVar.children = c.children
        c.outVar.parent = c.parent
        c.x,c.y,c.w,c.h = x + c.margin[1],y + c.margin[2],w - c.margin[3] * 2,h - c.margin[4] * 2
        c.outVar.x,c.outVar.y,c.outVar.w,c.outVar.h = c.x,c.y,c.w,c.h

        f = f or function () end
        f()
    end

    function c.recomputeLayout()
        c._computeLayout(c.computeX,c.computeY,c.computeW,c.computeH,c.computeFun)
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

    function c.outVar.addChild(child)
        table.insert(c.children,child)
        child.parent = c
    end

    return c
end
--#endregion


------------ VERTICAL CONTAINER -------------

--#region

---@class VerticalOptions : baseClassOptions

---@param options? VerticalOptions
---@param style? VerticalOptions
function lib.newVerticalContainer(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h,
        function ()
        local cy = c.y
            for i=1,#c.children do
                local ch = c.h * c.children[i].sizeFactor
                c.children[i].computeLayout(c.x + c.padding[1], cy + c.padding[2] ,c.w - c.padding[3] * 2,math.min(ch, c.h-cy + c.y) - c.padding[4] * 2)

                cy = cy + ch
            end
        end
        )
    end

    function c.mouseInput( x, y, button, type)
        local cx,cy = x,y 
        if type == "wheelmoved" then -- We dont get mouse position, only wheel movemenet
            cx,cy = love.mouse.getPosition()
        end
        local endPos = c.padding[2]
        local startPos = c.y + c.padding[2]

        print(c.debug_name, startPos)
        for i = 1, #c.children do
            startPos = startPos + math.min(c.children[i].sizeFactor * c.h,c.h - startPos + c.y) + c.children[i].margin[2]
            print("vert",c.children[i].debug_name,startPos .. " | " .. endPos, x.. " | ".. y,c.y,c.h)
            if cy < startPos and cy > endPos then
                c.children[i].mouseInput( x, y, button, type)
                break
            end
            startPos = startPos + c.children[i].margin[4]
            endPos = startPos

        end
    end

    return c
end
--#endregion


----------------- TEXT -------------------

--#region

---@class TextOptions : baseClassOptions
---@field text string Text to display
---@field alignmet love.AlignMode | "+90"
---@field color {r:number,g:number,b:number,a:number} Primary color
---@field font love.Font

---@param options? TextOptions
---@param style? TextOptions
function lib.newText(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)
    c.text = options.text or ""
    c.alignmet = style.alignmet or options.alignmet or "center"
    c.font = style.font or options.font or lib.default_font ---@type love.Font
    c.color = style.color or options.color or {0,0,0}
    c.tw = 0

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h)
        c.tw = w
    end

    function c:draw()
        LG.setColor(c.color)

        if c.alignmet == "+90" then
            LG.print(c.text,
            c.x + c.tw/2 - c.font:getHeight()/1.7,
            c.y + c.h/2 + c.font:getWidth(c.text)/2,
            -math.pi/2,
            1,1)
        else
            local _, lines = c.font:getWrap(c.text, c.w)
            local y = c.y + c.h/2 - (c.font:getHeight() * #lines)/2

            ---@diagnostic disable-next-line: param-type-mismatch
            LG.printf(c.text,c.font, c.x, y, c.w, c.alignmet)
        end
    end

    function c.outVar.setText(text)
        c.text = text
    end

    return c
end

--#endregion


------------ HORIZONTAL CONTAINER -------------

--#region

---@class HorizontalOptions : baseClassOptions

---@param options? HorizontalOptions
---@param style? HorizontalOptions
function lib.newHorizontalContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h,
        function ()        
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
        end)
    end

    function c.mouseInput( x, y, button,type)
        local cx,cy = x,y
        if type == "wheelmoved" then -- We dont get mouse position, only wheel movemenet
            cx,cy = love.mouse.getPosition()
        end
        local endPos = c.padding[1]
        local startPos = c.x + c.padding[1]
        for i = 1, #c.children do
            startPos = startPos + math.min(c.children[i].sizeFactor * c.w,c.w - startPos + c.x) + c.children[i].margin[1]
            print("vert",c.children[i].debug_name,startPos .. " | " .. endPos, x.. " | ".. y,c.x,c.w)
            if cx < startPos and cx > endPos then
                c.children[i].mouseInput( x, y, button,type)
                break
            end
            startPos = startPos + c.children[i].margin[3]
            endPos = startPos
        end
    end


    return c
end
--#endregion


------------ TEXT INPUT -------------

--#region

---@class textInputOptions : baseClassOptions
---@field text string Text to display
---@field bar_width number
---@field max_characters number
---@field border_color {r:number,g:number,b:number,a:number}
---@field border_size number
---@field color {r:number,g:number,b:number,a:number} Primary color
---@field filter "any" | "number"
---@field alignmet "center" | "left" | "right"
---@field placeholder string
---@field onEnter function
---@field font love.Font

---@param options? textInputOptions
---@param style? textInputOptions
function lib.newTextInput(options, style)
    options = options or {}
    style = style or {}
    local c = lib.baseClass(options, style)
    c.text = style.text or options.text or ""
    c.bar_width = style.bar_width or options.bar_width or 10
    c.color = style.color or options.color or COLOR.WHITE
    c.border_color = style.border_color or options.border_color
    c.border_size = style.border_size or options.border_size or 0
    c.max_characters = style.max_characters or options.max_characters or 20
    c.filter = style.filter or options.filter or "any"
    c.alignmet = style.alignmet or options.alignmet or "left"
    c.placeholder = style.placeholder or options.placeholder or ""
    c.font = style.font or options.font or lib.default_font ---@type love.Font
    c.onEnter = style.onEnter or options.onEnter

    function c.getTextLength()
        local byteOffset = utf8.offset(c.text, -1)
        return byteOffset or 0
    end

    function c.outVar.setText(text)
        c.text = text
    end

    if c.filter == "any" then
        c.filter = "."
    elseif c.filter == "number" then
        c.filter = "%d"
    end

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h)
    end

    function c.draw()
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

        if c.color ~= nil and c.text ~= "" then
            LG.setColor(c.color)
            LG.setScissor(c.x + c.border_size,c.y + c.border_size,c.w -  c.border_size * 2,c.h -  c.border_size * 2)
            
            local y = c.y + c.h/2 - c.font:getHeight()/2
            LG.printf(c.text,c.font, c.x + c.border_size, y, c.w, c.alignmet)
        else
            LG.setColor(0.6,0.6,0.6)
            LG.print(c.placeholder,c.x + c.w / 2 - lib.default_font:getWidth(c.placeholder)/2,c.y + c.h / 2 - lib.default_font:getHeight()/2)
        end

        LG.setScissor()
    end

    function c.mouseInput(x,y,button, type)
        if type == "mousepressed" then
            c.mousepressed(x,y,button)
        end
    end

    function c.mousepressed(x,y,button)
        lib.current_focus = c
    end

    function c.keypressed(key, scancode, isrepeat)
        if key == "return" then
            lib.current_focus = {}
            if c.onEnter ~= nil then
                c.onEnter()
            end
        elseif key == "backspace" then
            c.text = string.sub(c.text,1,c.getTextLength() - 1)
        end
        c.outVar.text = c.text
    end

    function c.textinput(t)
        if c.getTextLength() < c.max_characters then
            c.text = c.text .. (string.match(t,c.filter) or "")
        end
        c.outVar.text = c.text
    end

    return c
end

--#endregion


------------ CONTAINER -----------------

--#region

---@class containerOptions : baseClassOptions

---@param options? containerOptions
---@param style? containerOptions
function lib.newContainer(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h)
    end

    function c:draw()
        if c.outVar.draw ~= nil then
            c.outVar:draw()
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

--#endregion


------------ BUTTON -------------

--#region

---@class buttonOptions : baseClassOptions
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
---@field color {r:number,g:number,b:number,a:number} Primary color
---@field text string Text to display
---@field alignmet "center" | "+90"

---@param options? buttonOptions
---@param style? buttonOptions
function lib.newButton(options, style)
    local c = lib.baseClass(options, style)
    style = style or {}
    options = options or {}
    c.onClick = style.onClick or options.onClick or function () end
    c.drawExt = style.drawExt or options.drawExt
    c.color = style.color or options.color or {0,0,0}
    c.highlight_color = style.highlight_color or options.highlight_color
    c.border_color = style.border_color or options.border_color
    c.border_size = style.border_size or options.border_size or 0
    c.text = options.text or ""
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
        c._computeLayout(x,y,w,h)
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
            c:onClick()
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

        LG.setColor(c.color)

        if c.sprite ~= nil then
            local sw = c.sprite:getWidth() - c.border_size * 2
            local sh = c.sprite:getHeight() - c.border_size * 2

            local scaleX = c.w / sw
            local scaleY = c.h / sh

            local scale = math.min(scaleX, scaleY)
            local w = sw * scale
            local h = sh * scale

            LG.draw(c.sprite,c.x + (c.w - w)/2 + c.border_size,c.y + (c.h - h)/2 + c.border_size, 0, scale, scale)
        end


        ---- handle text -----

        if c.alignmet == "+90" then
            LG.print(c.text,
            c.x + c.tw/2 - FONT:getHeight()/1.7,
            c.y + c.h/2 + FONT:getWidth(c.text)/2,
            -math.pi/2,
            1,1)
        else
            local _, lines = lib.default_font:getWrap(c.text, c.w)
            local y = c.y + c.h/2 - (lib.default_font:getHeight() * #lines)/2

            ---@diagnostic disable-next-line: param-type-mismatch
            LG.printf(c.text, c.x, y, c.w, c.alignmet)
        end
    end

    return c
end
--#endregion


------------ LIST CONTAINER -----------

--#region

---@class listContainerOptions : baseClassOptions
---@field item_height number
---@field items table
---@field color {r:number,g:number,b:number,a:number} Primary color
---@field item function How an item should look like

function lib.newListContainer(options, style)
    local c = lib.baseClass(options,style)
    options = options or {}
    style = style or {}
    c.item_height = style.item_height or options.item_height or 50
    c.items = options.items or {}
    c.item = options.item
    c.color = style.color or options.color
    c.item_highlight_color = style.item_highlight_color or options.item_highlight_color

    c.scrollPos = 0
    c.maxItemsHeight = 0
    c.topBarSize = 28

    local deleteImage = LG.newImage("libs/assets/trash.png")
    local selectImage = LG.newImage("libs/assets/select.png")
    local deselectImage = LG.newImage("libs/assets/deselect.png")

    function c.outVar.addItem(data)
        if c.item ~= nil then
            local item = c.item(data)
            item.isSelected = false
            table.insert(c.items,item)
            c.computeChildren()
        end
    end

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h)
        c.computeChildren()
    end

    function c.computeChildren()
        local itemCount = 0
        for i = 1, #c.items do
            c.items[i].computeLayout(c.x,c.y + (c.topBarSize * lib.getScale()) + (c.item_height * (i-1)) + c.scrollPos,c.w,c.item_height)
            itemCount = i
        end

        c.maxItemsHeight = (c.item_height + c.margin[2] + c.margin[4]) * itemCount
    end

    function c.mouseInput(x, y, button, type)
        if type == "wheelmoved" then
            c.wheelmoved(x,y)
        elseif type == "mousepressed" then
            c.mousepressed(x,y,button)
        end
    end

    function c.mousepressed(x,y,button)
        local barSize = c.topBarSize * lib.getScale()

        if y > c.y + barSize then -- Handle items
            local startPos = y-c.y + barSize

            local itemIndex = math.floor((startPos - c.scrollPos) / c.item_height)

            -- If the items don't exist, don't search for them
            if itemIndex > #c.items then
                return
            end

            c.items[itemIndex].isSelected = not c.items[itemIndex].isSelected
        else -- Handle top bar interaction
            if x > c.x + c.w - barSize then
                c.removeSelectedItems()
            elseif x > c.x + c.w - barSize * 2 then
                c.setAllSelect(true)
            elseif x > c.x + c.w - barSize * 3 then
                c.setAllSelect(false)
            end
        end
    end

    function c.removeSelectedItems()

        for i = #c.items, 1,-1 do
            if c.items[i].isSelected then
                table.remove(c.items,i)
            end
        end

        c.computeChildren()

        if math.floor(c.maxItemsHeight - c.h) < 0 then
            c.scrollPos = 0
        end

        c.parent.recomputeLayout()
    end

    function c.wheelmoved(x,y)
        local outOfScreenPixels = math.floor(c.maxItemsHeight - c.h)
        local scrollSpeed = 40

        if outOfScreenPixels < 0 then
            c.scrollPos = 0
        end

        if y < 0 and outOfScreenPixels > 0 and c.scrollPos > -outOfScreenPixels then
            c.scrollPos = c.scrollPos - scrollSpeed
        elseif y > 0 and c.scrollPos < 0 then
                c.scrollPos = math.min(c.scrollPos + scrollSpeed,outOfScreenPixels)
        end

        c.computeChildren()
    end

    function c.setAllSelect(bool)
        for i = 1, #c.items do
            c.items[i].isSelected = bool
        end
    end

    function c.draw()
        local topBar = c.topBarSize * lib.getScale()


        if c.bg_color ~= nil then
            LG.setColor(c.bg_color)
            LG.rectangle(c.fillMode,c.x,c.y + topBar,c.w,c.h - topBar)
        end

        if c.color ~= nil then
            LG.setColor(c.color)
        end

        -- Draw top bar buttons

        lib.drawSprite(deleteImage,c.x + c.w - topBar ,c.y,topBar,topBar)
        lib.drawSprite(selectImage,c.x + c.w - topBar * 2,c.y,topBar,topBar)
        lib.drawSprite(deselectImage,c.x + c.w - topBar * 3,c.y,topBar,topBar)

        LG.setScissor(c.x,c.y + topBar,c.w,c.h - topBar)
        for i = 1, #c.items do
            local last_color = c.items[i].bg_color
            if c.items[i].isSelected and c.item_highlight_color ~= nil then -- Set bg color as highlight
                last_color = c.items[i].bg_color
                c.items[i].bg_color = c.item_highlight_color
            end

            c.items[i].draw()

            -- Reset item color
            c.items[i].bg_color = last_color
        end

        LG.setScissor()
    end



    return c
end

--#endregion


------------ SLIDER --------------

--#region

---@class sliderOptions : baseClassOptions

---@param options? sliderOptions
---@param style? sliderOptions
function lib.newSlider(options, style)
    local c = lib.baseClass(options, style)

    function c.computeLayout(x,y,w,h)
        c._computeLayout(x,y,w,h)
    end

    function c.draw()
    end

    return c
end


--#endregion


------------ MAIN CONTAINER ------------

--#region

---@class mainContainerOptions : baseClassOptions
---@field child table

---@param options? mainContainerOptions
---@param style? mainContainerOptions
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
        if lib.locked_aspect_ratio then
            local w = math.min(lib.default_res[1] / lib.default_res[2] * lib.window_h,lib.window_w)
            local h = math.min(lib.default_res[2] / lib.default_res[1] * lib.window_w,lib.window_h)
            c.child.computeLayout((lib.window_w - w) / 2,0,w,h)
        else
            c.child.computeLayout(0,0,lib.window_w,lib.window_h)
        end
    end

    function c.mouseInput(x, y, button, type)
        if type == "mousepressed" then
            c.mousepressed()
        end
        c.child.mouseInput(x, y, button, type)
    end

    function c.mousepressed()
        lib.current_focus = {}
    end

    return c
end


--#endregion


--------- CONFIG FUNCTIONS -----------

--#region
function lib.load()
    love.keyboard.setKeyRepeat(true)
end

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
--#endregion


----------- UPDATE ---------

function lib.update()
    if lib.current_focus.update ~= nil then
        lib.current_focus.update()
    end
end

function lib.drawSprite(drawable,x,y,w,h)
    local sw = drawable:getWidth()
    local sh = drawable:getHeight()

    local scaleX = w / sw
    local scaleY = h / sh

    local scale = math.min(scaleX, scaleY)
    local width = sw * scale
    local height = sh * scale

    LG.draw(drawable,x + (w - width)/2,y + (h - height)/2 , 0, scale, scale)
end

function lib.keypressed(key, scancode, isrepeat)
    if lib.current_focus.keypressed ~= nil then
        lib.current_focus.keypressed(key, scancode, isrepeat)
    end
end

function lib.textinput(t)
    if lib.current_focus.textinput ~= nil then
        lib.current_focus.textinput(t)
    end
end



return lib