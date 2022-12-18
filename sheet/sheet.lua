local m = {}

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

local x,y = SHEETINFO.x,SHEETINFO.y

m.zoom = 1

function m.init(width, height)
    w = width
    h = height
    canvas = LG.newCanvas(width, height)
end

function m.mousepressed(x, y, button)
    if button ~= 1 or x < ACTIONBAR.width + PANEL.width then
        return
    end

    dragStartX, dragStartY = x, y
    dragStartOffsetX = offsetX
    dragStartOffsetY = offsetY
end

function m.mousereleased(x, y, button)
    if button ~= 1 then
        return
    end

    dragStartX, dragStartY = nil, nil
    dragEnabled = false
end

function m.mousemoved(x, y)
    if x < ACTIONBAR.width + PANEL.width then
        return
    end

    cursorX, cursorY = x, y

    updateDrag()
end

function m.wheelmoved(x, y)
    if y > 0 then
        m.zoom = m.zoom + 0.1
    end

    if y < 0 then
        m.zoom = m.zoom - 0.1
    end
end

function SHEETINFO.mousepressed(x,y,button)
end

function m.update(dt)
    cursorX, cursorY = love.mouse.getPosition()
end

function m.draw()
    local sheetAreaX = ACTIONBAR.width + PANEL.width

    local padding = 24 * SCALE
    local scale = m.zoom * SCALE

    local x = sheetAreaX + padding + offsetX
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
    LG.setScissor(sheetAreaX, 0, WINDOW_W - sheetAreaX, WINDOW_H)
    LG.draw(canvas, x, y, 0, scale, scale)
    LG.setScissor()
end

return m