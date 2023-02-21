local createSheet = require("ui.sheet")

---@param projectData projectData
---@param toolMediator toolMediator
local function createMapEditorSheet(projectData, toolMediator)
    local cells = projectData.cells
    local sprites = projectData.sprites

    local cellW = cells.width
    local cellH = cells.height
    local sprSize = sprites.spriteSize

    local drawFilter, eraseFilter
    local drawEnabled = false
    local eraseEnabled = false

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

    local function floodFill(cellX, cellY, spriteToReplace)
        if cellX < 1 or cellX > cellW then return end
        if cellY < 1 or cellY > cellH then return end

        local spr = cells.data[cellY][cellX].sprites

        if spr[#spr] ~= spriteToReplace then
            return
        end

        spr[math.max(1, #spr)] = sprites.selectedSprite

        floodFill(cellX - 1, cellY, spriteToReplace)
        floodFill(cellX + 1, cellY, spriteToReplace)
        floodFill(cellX, cellY - 1, spriteToReplace)
        floodFill(cellX, cellY + 1, spriteToReplace)
    end

    ---@param s sheet
    ---@param x integer
    ---@param y integer
    local function updateDraw(s, x, y)
        if not drawEnabled then
            return
        end

        local cellX, cellY, _ = s.screenToCell(x, y)
        local offsetCount = sprites.selectionSize - 1

        local spriteX, spriteY = s.indexToCell(sprites.selectedSprite)

        for offsetY = 0, offsetCount do
            for offsetX = 0, offsetCount do
                local cx, cy = cellX + offsetX, cellY + offsetY

                if s.isCellValid(cx, cy) and not drawFilter[cy][cx] then
                    local cell = cells.data[cy][cx].sprites

                    cell[#cell+1] = s.cellToIndex(spriteX + offsetX, spriteY + offsetY)

                    print(cx, cy, cell[#cell])
                    drawFilter[cy][cx] = true
                end
            end
        end
    end

    ---@param s sheet
    ---@param x integer
    ---@param y integer
    local function updateErase(s, x, y)
        if not eraseEnabled then
            return
        end

        local cellX, cellY, isValid = s.screenToCell(x, y)

        if isValid and not eraseFilter[cellY][cellX] then
            local cell = cells.data[cellY][cellX].sprites

            table.remove(cell, #cell)
            eraseFilter[cellY][cellX] = true
        end
    end

    local function onPaintbrushLeftClick(s, x, y)
        drawEnabled = true
        eraseEnabled = false

        drawFilter = createLayerFilter()

        updateDraw(s, x, y)
    end

    ---@param s sheet
    ---@param x integer
    ---@param y integer
    local function onFillLeftClick(s, x, y)
        local cellX, cellY, isValid = s.screenToCell(x, y)

        if not isValid then return end

        local spr = cells.data[cellY][cellX].sprites
        local spriteToReplace = spr[#spr]

        if spriteToReplace == sprites.selectedSprite then
            return
        end

        floodFill(cellX, cellY, spriteToReplace)
    end

    local function onPaintbrushLeftRelease(x, y)
        drawEnabled = false
    end

    local function onPaintbrushRightClick(s, x, y)
        eraseEnabled = true
        drawEnabled = false

        eraseFilter = createLayerFilter()

        updateErase(s, x, y)
    end

    local function onPaintbrushRightRelease(x, y)
        eraseEnabled = false
    end

    ---@param s sheet
    ---@param x integer
    ---@param y integer
    local function onLeftClick(s, x, y)
        if toolMediator.selectedTool == "move" then
            s.startDrag(x, y)
        elseif toolMediator.selectedTool == "paintbrush" then
            onPaintbrushLeftClick(s, x, y)
        elseif toolMediator.selectedTool == "fill" then
            onFillLeftClick(s, x, y)
        end
    end

    ---@param s sheet
    ---@param x integer
    ---@param y integer
    local function onLeftRelease(s, x, y)
        if toolMediator.selectedTool == "move" then
            s.finishDrag()
        elseif toolMediator.selectedTool == "paintbrush" then
            onPaintbrushLeftRelease(x, y)
        end
    end

    local function onRightClick(s, x, y)
        if toolMediator.selectedTool == "paintbrush" then
            onPaintbrushRightClick(s, x, y)
        end
    end

    local function onRightRelease(x, y)
        if toolMediator.selectedTool == "paintbrush" then
            onPaintbrushRightRelease(x, y)
        end
    end

    ---@param x integer
    ---@param y integer
    ---@param s sheet
    local function mousemoved(x, y, s)
        s.updateCursor(x, y)

        s.updateDrag(x, y)
        updateDraw(s, x, y)
        updateErase(s, x, y)
    end

    ---@param x integer
    ---@param y integer
    ---@param button integer
    ---@param s sheet
    local function mousepressed(x, y, button, s)
        if button == 1 then
            onLeftClick(s, x, y)
        elseif button == 2 then
            onRightClick(s, x, y)
        end
    end

    ---@param x integer
    ---@param y integer
    ---@param button integer
    ---@param s sheet
    local function mousereleased(x, y, button, s)
        if button == 1 then
            onLeftRelease(s, x, y)
        elseif button == 2 then
            onRightRelease(x, y)
        end
    end

    ---@param s sheet
    local function draw(s)
        for y = 0, cellH - 1 do
            for x = 0, cellW - 1 do
                local cell = cells.data[y + 1][x + 1]

                for _, i in ipairs(cell.sprites) do
                    sprites.data[i].draw(x * sprSize, y * sprSize)
                end
            end
        end

        local selX, selY = s.cursorToCell()
        local selSize = sprSize * sprites.selectionSize

        LG.rectangle("fill", selX * sprSize - sprSize, selY * sprSize - sprSize, selSize, selSize)
    end

    return createSheet({
        width = cellW,
        height = cellH,
        cellSize = sprSize,
        mousemoved = mousemoved,
        mousepressed = mousepressed,
        mousereleased = mousereleased,
        draw = draw
    })
end

return createMapEditorSheet