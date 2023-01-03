local m = {}

local DESIGN_PADDING = 24

local info  ---@type table
local sprites  ---@type spriteCollection
local cells  ---@type cellCollection
local canvas  ---@type love.Canvas
local w, h  ---@type integer, integer
local cursorX, cursorY = love.mouse.getPosition()
local offsetX, offsetY = 0, 0

local dragStartX, dragStartY  ---@type number|nil, number|nil
local dragStartOffsetX ---@type number
local dragStartOffsetY  ---@type number
local dragEnabled = false

local function updateDrag()
    if dragStartX == nil or dragStartY == nil then
        return
    end

    local dx = dragStartX - cursorX
    local dy = dragStartY - cursorY
    local dist = (dx ^ 2 + dy ^ 2) ^ 0.5

    if dist > 15 then
        dragEnabled = true
    end

    if dragEnabled then
        offsetX = dragStartOffsetX + cursorX - dragStartX
        offsetY = dragStartOffsetY + cursorY - dragStartY
    end
end

local function getPosition()
    local padding = DESIGN_PADDING * SCALE

    local x = info.x + padding + offsetX
    local y = padding + offsetY

    return x, y
end

m.zoom = 1
m.showGrid = true

---@class sheetInitOptions
---@field info table info table used by `duckUI` to maintain layout information
---@field sprites spriteCollection reference to the main spriteCollection
---@field cells cellCollection reference to the main cellCollection

---@param opts sheetInitOptions
function m.init(opts)
    info = opts.info
    sprites = opts.sprites
    cells = opts.cells

    local cellW = cells.width
    local cellH = cells.height

    local function screenToCell(screenX, screenY)
        local baseX, baseY = getPosition()
        local div = sprites.spriteSize * m.zoom * SCALE

        local cellX = math.ceil((screenX - baseX) / div)
        local cellY = math.ceil((screenY - baseY) / div)

        local isXValid = 0 < cellX and cellX <= cellW
        local isYValid = 0 < cellY and cellY <= cellH

        return cellX, cellY, isXValid and isYValid
    end

    local function onLeftClick(x, y)
        dragStartX, dragStartY = x, y
        dragStartOffsetX = offsetX
        dragStartOffsetY = offsetY
    end

    local function onRightRelease(x, y)
        local cellX, cellY, isValid = screenToCell(x, y)

        if isValid then
            local cell = cells.data[cellY][cellX].sprites

            table.remove(cell, #cell)
        end
    end

    local function onLeftRelease(x, y)
        dragStartX, dragStartY = nil, nil
        dragEnabled = false

        local cellX, cellY, isValid = screenToCell(x, y)

        if isValid then
            local cell = cells.data[cellY][cellX].sprites

            cell[#cell+1] = sprites.selectedIndex
        end
    end

    w = cellW * sprites.spriteSize
    h = cellH * sprites.spriteSize

    canvas = LG.newCanvas(w, h)

    function info.mousepressed(x, y, button)
        if button == 1 then
            onLeftClick(x, y)
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

        updateDrag()
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