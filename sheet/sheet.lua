local m = {}

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

function m.init(sheetInfo, width, height)
    info = sheetInfo
    w = width
    h = height
    canvas = LG.newCanvas(width, height)

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
end

function m.draw()
    local padding = 24 * SCALE
    local scale = m.zoom * SCALE

    local x = info.x + padding + offsetX
    local y = padding + offsetY

    local cx = math.floor((cursorX - x) / (64 * scale))
    local cy = math.floor((cursorY - y) / (64 * scale))

    LG.setColor(COLOR.WHITE)
    LG.setCanvas(canvas)
    LG.clear()

    for y = 0, h, 64 do
        LG.line(0, y, w, y)
    end

    for x = 0, w, 64 do
        LG.line(x, 0, x, h)
    end

    LG.rectangle("fill", cx * 64, cy * 64, 64, 64)

    LG.setCanvas()
    LG.setScissor(info.x, 0, WINDOW_W - info.y, WINDOW_H)
    LG.draw(canvas, x, y, 0, scale, scale)
    LG.setScissor()
end

return m