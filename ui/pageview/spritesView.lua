local m = {}


function m.createSprite(spriteInfo)
    local spriteSelectText = {}
    
    local function reduceGrid()
        spriteInfo.selectionSize = (spriteInfo.selectionSize - 2) % 5 + 1
        spriteSelectText.setText(spriteInfo.selectionSize)
    end
    
    local function increaseGrid()
        spriteInfo.selectionSize = (spriteInfo.selectionSize) % 5 + 1
        spriteSelectText.setText(spriteInfo.selectionSize)
    end

    return {
        DUI.newHorizontalContainer({
            sizeFactor = 0.08,
            children = {
                DUI.newButton({sizeFactor = 0.2, text = "<", onClick = reduceGrid},STYLE.STYLEDBUTTON),
                DUI.newVerticalContainer({
                    sizeFactor = 0.6,
                    children = {
                        DUI.newText({sizeFactor = 0.5,text = "Selection size"}),
                        DUI.newText({text = tostring(spriteInfo.selectionSize),outVar = spriteSelectText})
                    }
                }),
                DUI.newButton({text = ">", onClick = increaseGrid},STYLE.STYLEDBUTTON)
            }
        }),
        DUI.newTextInput({sizeFactor = 0.1}, STYLE.STYLEDTEXTINPUT)
    }
end


return m