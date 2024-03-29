---@class sheet
---@field cellWidth integer
---@field cellHeight integer
---@field cellSize integer
---@field width integer
---@field height integer
---@field canvas love.Canvas
---@field canvasX integer
---@field canvasY integer
---@field canvasZoom number
---@field showGrid boolean
---@field cursorX integer
---@field cursorY integer
---@field dragStartX integer|nil
---@field dragStartY integer|nil
---@field dragStartOffsetX integer
---@field dragStartOffsetY integer
---@field zoomText table
---@field isCellValid fun(cellX: integer, cellY: integer): boolean
---@field screenToCell fun(screenX: integer, screenY: integer): integer, integer, boolean
---@field cursorToCell fun(): integer, integer, boolean
---@field cellToIndex fun(x: integer, y: integer): integer
---@field indexToCell fun(i: integer): integer, integer
---@field updateCursor fun(x: integer, y: integer)
---@field updateDrag fun(x: integer, y: integer)
---@field startDrag fun(x: integer, y: integer)
---@field finishDrag fun()

---@class createSheetOptions
---@field width integer width of the sheet in cells
---@field height integer height of the sheet in cells
---@field cellSize integer size of a cell in pixels
---@field mousemoved fun(x: integer, y: integer, s: table?)
---@field mousepressed fun(x: integer, y: integer, button: integer, s: table?)
---@field mousereleased fun(x: integer, y: integer, button: integer, s: table?)
---@field draw fun(s: table)
---@field drawUnscaled fun(s: table, x: integer, y: integer, scale: number)?

local DESIGN_PADDING = 24

---@param opts createSheetOptions
---@return sheet
local function createSheet(opts)
    local s = {}

    s.cellWidth = opts.width
    s.cellHeight = opts.height
    s.cellSize = opts.cellSize

    s.width = s.cellWidth * s.cellSize
    s.height = s.cellHeight * s.cellSize

    s.canvas = LG.newCanvas(s.width, s.height)
    s.canvasX = 0
    s.canvasY = 0
    s.canvasZoom = 1

    s.showGrid = true

    s.cursorX = -1
    s.cursorY = -1
    s.dragStartX = nil
    s.dragStartY = nil
    s.dragOffsetX = 0
    s.dragOffsetY = 0

    function s.isCellValid(cellX, cellY)
        local isXValid = 0 < cellX and cellX <= s.cellWidth
        local isYValid = 0 < cellY and cellY <= s.cellHeight

        return isXValid and isYValid
    end

    function s.screenToCell(screenX, screenY)
        local padding = DESIGN_PADDING * SCALE

        local baseX = s.x + padding + s.canvasX
        local baseY = s.y + padding + s.canvasY

        local div = s.cellSize * s.canvasZoom * SCALE

        local cellX = math.ceil((screenX - baseX) / div)
        local cellY = math.ceil((screenY - baseY) / div)

        return cellX, cellY, s.isCellValid(cellX, cellY)
    end

    function s.cursorToCell()
        return s.screenToCell(s.cursorX, s.cursorY)
    end

    function s.cellToIndex(x, y)
        return (y - 1) * (s.cellWidth + 1) + x
    end

    function s.indexToCell(i)
        i = i - 1
        local ww = s.cellWidth + 1

        local x = i % ww * s.cellSize
        local y = math.floor(i / ww) * s.cellSize

        return x, y
    end

    function s.updateCursor(x, y)
        s.cursorX = x
        s.cursorY = y
    end

    function s.updateDrag(x, y)
        local dsx = s.dragStartX
        local dsy = s.dragStartY

        if dsx == nil or dsy == nil then
            return
        end

        local dx = x - dsx
        local dy = y - dsy
        local dist = math.sqrt(dx^2 + dy^2)

        if dist < 15 then
            return
        end

        s.canvasX = s.dragOffsetX + dx
        s.canvasY = s.dragOffsetY + dy
    end

    function s.startDrag(x, y)
        s.dragStartX = x
        s.dragStartY = y
        s.dragOffsetX = s.canvasX
        s.dragOffsetY = s.canvasY
    end

    function s.finishDrag()
        s.dragStartX = nil
        s.dragStartY = nil
    end

    s.mousemoved = opts.mousemoved or function() end
    s.mousepressed = opts.mousepressed or function() end
    s.mousereleased = opts.mousereleased or function() end

    function s.wheelmoved(_, y)
        if y > 0 then
            s.canvasZoom = s.canvasZoom + 0.1
        end

        if y < 0 and s.canvasZoom > 0.2 then
            s.canvasZoom = s.canvasZoom - 0.1
        end

        if s.zoomText ~= nil then
            s.zoomText.setText(string.format("Zoom: %d%%", s.canvasZoom * 100))
        end
    end

    function s.draw()
        local w = s.width
        local h = s.height

        local padding = DESIGN_PADDING * SCALE
        local scale = s.canvasZoom * SCALE

        local x = s.x + padding + s.canvasX
        local y = s.y + padding + s.canvasY

        LG.setColor(COLOR.WHITE)
        LG.setCanvas(s.canvas)
        LG.clear()

        opts.draw(s)

        LG.setCanvas()
        LG.setScissor(s.x, s.y, s.w, s.h)

        LG.draw(s.canvas, x, y, 0, scale, scale)

        LG.setColor(0.7, 0.7, 0.7, 0.5)
        LG.setLineWidth(2)

        if s.showGrid then
            for gy = 0, s.height, s.cellSize do
                gy = gy * scale

                LG.line(x, y + gy, x + w * scale, y + gy)
            end

            for gx = 0, s.width, s.cellSize do
                gx = gx * scale

                LG.line(x + gx, y, x + gx, y + h * scale)
            end
        end

        LG.rectangle("line", x, y, w * scale, h * scale)

        LG.setLineWidth(1)
        LG.setColor(1, 1, 1, 1)

        if opts.drawUnscaled ~= nil then
            opts.drawUnscaled(s, x, y, scale)
        end

        LG.setScissor()
    end

    return s
end

return createSheet