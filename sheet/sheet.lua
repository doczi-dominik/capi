local m = {}

local CELL_SIZE = 64

local info
local canvas  ---@type love.Canvas
local w, h  ---@type number, number
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

---comment
---@param sheetInfo table info table used by `duckUI` to maintain layout information
---@param width integer the width of the sheet **in cells**
---@param height integer the height of the sheet **in cells**
function m.init(sheetInfo, width, height)
    info = sheetInfo
    w = width * CELL_SIZE
    h = height * CELL_SIZE
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
        local padding = 24 * SCALE
        local scale = m.zoom * SCALE
    
        local x = info.x + padding + offsetX
        local y = padding + offsetY
    
        local cx = math.floor((cursorX - x) / (CELL_SIZE * scale))
        local cy = math.floor((cursorY - y) / (CELL_SIZE * scale))
    
        LG.setColor(COLOR.WHITE)
        LG.setCanvas(canvas)
        LG.clear()
    
        for y = 0, h, CELL_SIZE do
            LG.line(0, y, w, y)
        end

        for x = 0, w, CELL_SIZE do
            LG.line(x, 0, x, h)
        end

        LG.rectangle("fill", cx * CELL_SIZE, cy * CELL_SIZE, CELL_SIZE, CELL_SIZE)

        LG.setCanvas()
        LG.setScissor(info.x, 0, WINDOW_W - info.y, WINDOW_H)
        LG.draw(canvas, x, y, 0, scale, scale)
        LG.setScissor()
    end
end

return m