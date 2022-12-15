local b = {}

function b.createButton(text, onclick)
    local bt = {}

    bt.text = text
    bt.onclick = onclick

    function bt.draw(x, y)
        LG.print(bt.text, x, y)
    end

    return bt
end

function b.createStyledButton(text, onclick)
    local bt = b.createButton(text, onclick)

    ---@diagnostic disable-next-line: duplicate-set-field
    function bt.draw(x, y, w, h)
        local border = 2 * SCALE

        LG.setColor(COLOR.PRIMARY)
        LG.rectangle("fill",x,y,w,h)
        LG.setColor(COLOR.BUTTON_COLOR)
        LG.rectangle("fill",x + border,y + border,w - border * 2,h - border * 2)
        LG.setColor(COLOR.BLACK)
        LG.print(bt.text,x + w/2 - FONT:getWidth(bt.text)/2,y + h/2 - FONT:getHeight()/2)
    end

    return bt
end

return b