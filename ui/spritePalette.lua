local createSheet = require("ui.sheet")

---@param sprites spriteCollection
---@return table
local function create(sprites)
    local data = sprites.data
    local sprSize = sprites.spriteSize

    local w, h = sprites.sheets[1].spritesheet:getDimensions()

    w = math.ceil(w / sprSize)
    h = math.ceil(h / sprSize)

    local function cellToIndex(x, y)
        return (y - 1) * (w + 1) + x
    end

    local function indexToCell(i)
        i = i - 1
        local ww = w + 1

        local x = i % ww * sprSize
        local y = math.floor(i / ww) * sprSize

        return x, y
    end

    ---@param x integer
    ---@param y integer
    ---@param s sheet
    local function mousemoved(x, y, s)
        s.updateCursor(x, y)

        s.updateDrag(x, y)
    end

    ---@param x integer
    ---@param y integer
    ---@param button integer
    ---@param s sheet
    local function mousepressed(x, y, button, s)
        s.startDrag(x, y)

        local cellX, cellY, isValid = s.screenToCell(x, y)

        if not isValid then
            return
        end

        sprites.selectedSprite = cellToIndex(cellX, cellY)
    end

    ---@param x integer
    ---@param y integer
    ---@param button integer
    ---@param s sheet
    local function mousereleased(x, y, button, s)
        s.finishDrag()
    end

    ---@param s sheet
    local function draw(s)
        for i = 1, #data do
            data[i].draw(indexToCell(i))
        end

        local selX, selY = s.cursorToCell()
        local selSize = sprSize * sprites.selectionSize

        LG.rectangle("fill", selX * sprSize - sprSize, selY * sprSize - sprSize, selSize, selSize)
    end

    ---@param s sheet|table
    local function drawUnscaled(s, x, y, scale)
        local selSize = sprSize * sprites.selectionSize
        local selX, selY = indexToCell(sprites.selectedSprite)

        LG.setLineWidth(3)
        LG.rectangle("line", x + selX * scale, y + selY * scale, selSize * scale, selSize * scale)
        LG.setLineWidth(1)
    end

    return createSheet({
        width = w,
        height = h,
        cellSize = sprSize,
        mousemoved = mousemoved,
        mousepressed = mousepressed,
        mousereleased = mousereleased,
        draw = draw,
        drawUnscaled = drawUnscaled
    })
end

return create