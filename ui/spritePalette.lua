
---@param spriteCollection spriteCollection
---@return table
local function create(spriteCollection)
    local p = {}

    function p.mousepressed()
    end

    function p.mousemoved()
    end

    function p.draw(t)
        LG.setColor(COLOR.BLACK)
        LG.rectangle("fill",t.x ,t.y,t.w,t.h)

        LG.setColor(COLOR.WHITE)

        local colCount = math.floor(t.w / 48)
        local rowCount = math.floor(t.h / 48)

        for i = 1, math.min(#spriteCollection.data, colCount * rowCount) do
            local s = spriteCollection.data[i]
            local ii = i -1

            s.drawForPalette(t.x + ii % colCount * 48, t.y + math.floor(ii / colCount) * 48)
        end
    end

    return p
end

return create