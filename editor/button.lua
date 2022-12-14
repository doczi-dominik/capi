local b = {}

function b.createButton(text,onClickfunc)
    local bt = {}

        bt.Onclick = onClickfunc
        bt.Text = text
        function bt.draw(x, y, w, h,isSelected)
            local tw = w

            if isSelected then
                LG.setColor(COLOR.BUTTON_HIGHLIGHT)
                w = w + w/2
            else
                LG.setColor(COLOR.BUTTON_COLOR)
            end
            LG.rectangle("fill",x,y,w,h)
            LG.setColor(COLOR.BLACK)
            LG.print(bt.Text,
                x + tw/2 + FONT:getHeight(bt.Text)/2,
                y + h/2 - FONT:getWidth(bt.Text)/2,
                math.pi/2,
                1,1)
            LG.setColor(COLOR.WHITE)
        end
         
    return bt
end

return b