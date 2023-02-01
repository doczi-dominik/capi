local m = {}

local DESIGN_PADDING = 24

local info  ---@type table
local sprites  ---@type spriteCollection
local cells  ---@type cellCollection
local toolMediator ---@type toolMediator

local canvas  ---@type love.Canvas
local w, h  ---@type integer, integer
local cursorX, cursorY = love.mouse.getPosition()
local offsetX, offsetY = 0, 0

local dragStartX, dragStartY  ---@type number|nil, number|nil
local dragStartOffsetX ---@type number
local dragStartOffsetY  ---@type number

local drawEnabled = false
local eraseEnabled = false

m.zoom = 1
m.showGrid = true

---@class sheetInitOptions
---@field info table info table used by `duckUI` to maintain layout information
---@field sprites spriteCollection reference to the main spriteCollection
---@field cells cellCollection reference to the main cellCollection
---@field toolMediator toolMediator reference to the main toolMediator

---@param opts sheetInitOptions
function m.init(opts)
    info = opts.info
    sprites = opts.sprites
    cells = opts.cells
    toolMediator = opts.toolMediator

    local cellW = cells.width
    local cellH = cells.height

    local function createLayerFilter()
        local f = {}

        for y = 1, cellH do
            f[y] = {}
            for x = 1, cellW do
                f[y][x] = false
            end
        end

        return f
    end

    local function getPosition()
        local padding = DESIGN_PADDING * SCALE

        local x = info.x + padding + offsetX
        local y = padding + offsetY

        return x, y
    end

    local function screenToCell(screenX, screenY)
        local baseX, baseY = getPosition()
        local div = sprites.spriteSize * m.zoom * SCALE

        local cellX = math.ceil((screenX - baseX) / div)
        local cellY = math.ceil((screenY - baseY) / div)

        local isXValid = 0 < cellX and cellX <= cellW
        local isYValid = 0 < cellY and cellY <= cellH

        return cellX, cellY, isXValid and isYValid
    end

    local function floodFill(cellX, cellY, spriteToReplace)
        if cellX < 1 or cellX > cellW then return end
        if cellY < 1 or cellY > cellH then return end

        local spr = cells.data[cellY][cellX].sprites

        if spr[#spr] ~= spriteToReplace then
            return
        end

        spr[math.max(1, #spr)] = sprites.selectedIndex

        floodFill(cellX - 1, cellY, spriteToReplace)
        floodFill(cellX + 1, cellY, spriteToReplace)
        floodFill(cellX, cellY - 1, spriteToReplace)
        floodFill(cellX, cellY + 1, spriteToReplace)
    end

    local function updateDrag(x, y)
        if dragStartX == nil or dragStartY == nil then
            return
        end

        offsetX = dragStartOffsetX + x - dragStartX
        offsetY = dragStartOffsetY + y - dragStartY
    end

    local drawFilter
    local eraseFilter

    local function updateDraw(x, y)
        if not drawEnabled then
            return
        end

        local cellX, cellY, isValid = screenToCell(x, y)

        if isValid and not drawFilter[cellY][cellX] then
            local cell = cells.data[cellY][cellX].sprites

            cell[#cell+1] = sprites.selectedIndex
            drawFilter[cellY][cellX] = true
        end
    end

    local function updateErase(x, y)
        if not eraseEnabled then
            return
        end

        local cellX, cellY, isValid = screenToCell(x, y)

        if isValid and not eraseFilter[cellY][cellX] then
            local cell = cells.data[cellY][cellX].sprites

            table.remove(cell, #cell)
            eraseFilter[cellY][cellX] = true
        end
    end

    local function onMoveLeftClick(x, y)
        dragStartX, dragStartY = x, y
        dragStartOffsetX = offsetX
        dragStartOffsetY = offsetY
    end

    local function onPaintbrushLeftClick(x, y)
        drawEnabled = true
        eraseEnabled = false

        drawFilter = createLayerFilter()

        updateDraw(x, y)
    end

    local function onFillLeftClick(x, y)
        local cellX, cellY, isValid = screenToCell(x, y)

        if not isValid then return end

        local spr = cells.data[cellY][cellX].sprites
        local spriteToReplace = spr[#spr]

        if spriteToReplace == sprites.selectedIndex then
            return
        end

        floodFill(cellX, cellY, spriteToReplace)
    end

    local function onMoveLeftRelease(x, y)
        dragStartX, dragStartY = nil, nil
    end

    local function onPaintbrushLeftRelease(x, y)
        drawEnabled = false
    end

    local function onPaintbrushRightClick(x, y)
        eraseEnabled = true
        drawEnabled = false

        eraseFilter = createLayerFilter()

        updateErase(x, y)
    end

    local function onPaintbrushRightRelease(x, y)
        eraseEnabled = false
    end

    local function onLeftClick(x, y)
        if toolMediator.selectedTool == "move" then
            onMoveLeftClick(x, y)
        elseif toolMediator.selectedTool == "paintbrush" then
            onPaintbrushLeftClick(x, y)
        elseif toolMediator.selectedTool == "fill" then
            onFillLeftClick(x, y)
        end
    end

    local function onLeftRelease(x, y)
        if toolMediator.selectedTool == "move" then
            onMoveLeftRelease(x, y)
        elseif toolMediator.selectedTool == "paintbrush" then
            onPaintbrushLeftRelease(x, y)
        end
    end

    local function onRightClick(x, y)
        if toolMediator.selectedTool == "paintbrush" then
            onPaintbrushRightClick(x, y)
        end
    end

    local function onRightRelease(x, y)
        if toolMediator.selectedTool == "paintbrush" then
            onPaintbrushRightRelease(x, y)
        end
    end

    w = cellW * sprites.spriteSize
    h = cellH * sprites.spriteSize

    canvas = LG.newCanvas(w, h)

    function info.mousepressed(x, y, button)
        if button == 1 then
            onLeftClick(x, y)
        elseif button == 2 then
            onRightClick(x, y)
        end
    end

    function info.mousereleased(x, y, button)
        if button == 1 then
            onLeftRelease(x, y)
        elseif button == 2 then
            onRightRelease(x, y)
        end
    end

    function info.mousemoved(x, y)
        cursorX, cursorY = x, y

        updateDrag(x, y)
        updateDraw(x, y)
        updateErase(x, y)
    end

    function info.wheelmoved(x, y)
        if y > 0 then
            m.zoom = m.zoom + 0.1
        end

        if y < 0 and m.zoom > 0.2 then
            m.zoom = m.zoom - 0.1
        end

        info.zoomText.setText("Zoom: "..m.zoom * 100 .."%")
    end

    function info.draw()
        local sprSize = sprites.spriteSize
        local padding = 24 * SCALE
        local scale = m.zoom * SCALE

        local x = info.x + padding + offsetX
        local y = padding + offsetY

        LG.setColor(COLOR.WHITE)
        LG.setCanvas(canvas)
        LG.clear()

        for y = 0, cellH - 1 do
            for x = 0, cellW - 1 do
                local cell = cells.data[y + 1][x + 1]

                for _, i in ipairs(cell.sprites) do
                    sprites.data[i].draw(x * sprSize, y * sprSize)
                end
            end
        end

        local selX, selY = screenToCell(cursorX, cursorY)

        LG.rectangle("fill", selX * sprSize - sprSize, selY * sprSize - sprSize, sprSize, sprSize)

        LG.setCanvas()
        LG.setScissor(info.x, 0, WINDOW_W - info.y, WINDOW_H)

        LG.draw(canvas, x, y, 0, scale, scale)

        LG.setColor(0.7, 0.7, 0.7, 0.5)
        LG.setLineWidth(2)

        if m.showGrid then
            for gy = 0, h, sprSize do
                gy = gy * scale
                LG.line(x, y + gy, x + w * scale, y + gy)
            end

            for gx = 0, w, sprSize do
                gx = gx * scale
                LG.line(x + gx, y, x + gx, y + h * scale)
            end
        end

        LG.rectangle("line", x, y, w * scale, h * scale)

        LG.setLineWidth(1)
        LG.setColor(1, 1, 1, 1)

        LG.setScissor()
    end
end

return m