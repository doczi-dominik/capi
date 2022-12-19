local m = {}

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
            data[y][x] = 0
        end
    end

    w = cellW * sprites.spriteSize
    h = cellH * sprites.spriteSize

    canvas = LG.newCanvas(w, h)

    function info.mousepressed(x, y, button)
        dragStartX, dragStartY = x, y
        dragStartOffsetX = offsetX
        dragStartOffsetY = offsetY
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

        local cx = math.floor((cursorX - x) / (sprSize * scale))
        local cy = math.floor((cursorY - y) / (sprSize * scale))

        LG.setColor(COLOR.WHITE)
        LG.setCanvas(canvas)
        LG.clear()

        LG.setColor(0.7, 0.7, 0.7, 0.5)

        if m.showGrid then
            for y = 0, h, sprSize do
                LG.line(0, y, w, y)
            end

            for x = 0, w, sprSize do
                LG.line(x, 0, x, h)
            end
        end

        LG.rectangle("line", 0, 0, w, h)

        LG.setColor(1, 1, 1, 1)

        for y = 0, cellH - 1 do
            for x = 0, cellW - 1 do
                local index = data[y + 1][x + 1]

                if index ~= 0 then
                    sprites.data[index].draw(x * sprSize, y * sprSize)
                end
            end
        end

        LG.rectangle("fill", cx * sprSize, cy * sprSize, sprSize, sprSize)

        LG.setCanvas()
        LG.setScissor(info.x, 0, WINDOW_W - info.y, WINDOW_H)
        LG.draw(canvas, x, y, 0, scale, scale)
        LG.setScissor()
    end
end

return m