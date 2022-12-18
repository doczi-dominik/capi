local m = {}

---@type love.Canvas
local canvas

---@type number, number
local w, h

---@type number, number
local cursorX, cursorY

m.zoom = 1

function m.init(width, height)
    w = width
    h = height
    canvas = LG.newCanvas(width, height)
end

function m.update(dt)
    cursorX, cursorY = love.mouse.getPosition()
end

function m.wheelmoved(x, y)
    if y > 0 then
        m.zoom = m.zoom + 0.05
    end

    if y < 0 then
        m.zoom = m.zoom - 0.05
    end
end

function m.draw()
    local offset = 24 * SCALE
    local scale = m.zoom * SCALE

    local x = ACTIONBAR.width + PANEL.width + offset
    local y = offset

    local cx = math.floor((cursorX - x) / (64 * scale))
    local cy = math.floor((cursorY - y) / (64 * scale))

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
    LG.draw(canvas, x, y, 0, scale, scale)
end

return m