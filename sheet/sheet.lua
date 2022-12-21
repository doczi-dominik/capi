local m = {}

local DESIGN_PADDING = 24

local data  ---@type integer[][]
local info  ---@type table
local sprites  ---@type spriteCollection
local canvas  ---@type love.Canvas
local cellW, cellH  ---@type integer, integer
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

local function screenToSheet(screenX, screenY)
    local baseX, baseY = getPosition()
    local div = sprites.spriteSize * m.zoom * SCALE

    local cellX = math.ceil((screenX - baseX) / div)
    local cellY = math.ceil((screenY - baseY) / div)

    return cellX, cellY
end

local function onLeftClick(x, y)
    dragStartX, dragStartY = x, y
    dragStartOffsetX = offsetX
    dragStartOffsetY = offsetY
end

local function onRightClick(x, y)
    local sheetX, sheetY = screenToSheet(x, y)

    data[sheetY][sheetX] = 0
end

m.zoom = 1
m.showGrid = true

---@class sheetInitOptions
---@field info table info table used by `duckUI` to maintain layout information
---@field width integer the width of the sheet **in cells**
---@field height integer the height of the sheet **in cells**
---@field sprites spriteCollection reference to the main spriteCollection

---@param opts sheetInitOptions
function m.init(opts)
    info = opts.info
    sprites = opts.sprites
    cellW, cellH = opts.width, opts.height

    data = {}

    for y = 1, cellH do
        data[y] = {}

        for x = 1, cellW do
            data[y][x] = 1
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
        if button ~= 1 then
            return
        end

        dragStartX, dragStartY = nil, nil
        dragEnabled = false
    end

    function info.mousemoved(x, y)
        cursorX, cursorY = x, y

        updateDrag()
    end

    function info.wheelmoved(x, y)
        if y > 0 then
            m.zoom = m.zoom + 0.1
        end

        if y < 0 then
            m.zoom = m.zoom - 0.1
        end
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
                local index = data[y + 1][x + 1]

                if index ~= 0 then
                    sprites.data[index].draw(x * sprSize, y * sprSize)
                end
            end
        end

        local selX, selY = screenToSheet(cursorX, cursorY)

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