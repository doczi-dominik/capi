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

return b