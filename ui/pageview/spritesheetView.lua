local m = {}
local fileManager = require("file_manager")

function m.createSpriteSheet(spriteInfo)
    local spriteSelectText = {}
    local spriteSizeText = {}

    spriteInfo.selectionSize = 1
    spriteInfo.spriteSize = 2
    spriteInfo.importedFileData = nil


    local function reduceGrid()
        spriteInfo.selectionSize = (spriteInfo.selectionSize - 2) % 5 + 1
        spriteSelectText.setText(spriteInfo.selectionSize)
    end
    
    local function increaseGrid()
        spriteInfo.selectionSize = (spriteInfo.selectionSize) % 5 + 1
        spriteSelectText.setText(spriteInfo.selectionSize)
    end
    
    local function reduceSprite()
        spriteInfo.spriteSize = (spriteInfo.spriteSize - 3) % 17 + 1
        spriteSizeText.setText(spriteInfo.spriteSize)
    end
    
    local function increaseSprite()
        spriteInfo.spriteSize = (spriteInfo.spriteSize) % 17 + 1
        spriteSizeText.setText(spriteInfo.spriteSize)
    end

    local function importFileData()
        spriteInfo.importedFileData = fileManager.fileDialogue()
    end

    return {
        DUI.newButton({sizeFactor = 0.10, text = "Import spritesheet", onClick = importFileData}, STYLE.STYLEDBUTTON),
        DUI.newHorizontalContainer({
            debug_name = "edit buttons",
            sizeFactor = 0.08,
            children = {
                DUI.newButton({sizeFactor = 0.2, text = "<", onClick = reduceGrid},STYLE.STYLEDBUTTON),
                DUI.newVerticalContainer({
                    sizeFactor = 0.6,
                    children = {
                        DUI.newText({sizeFactor = 0.5,text = "Selection size"}),
                        DUI.newText({text = spriteInfo.selectionSize,outVar = spriteSelectText})
                    }
                }),
                DUI.newButton({text = ">", onClick = increaseGrid},STYLE.STYLEDBUTTON)
            }
        }),
        DUI.newHorizontalContainer({
            sizeFactor = 0.08,
            children = {
                DUI.newButton({sizeFactor = 0.2, text = "<", onClick = reduceSprite},STYLE.STYLEDBUTTON),
                DUI.newVerticalContainer({
                    sizeFactor = 0.6,
                    children = {
                        DUI.newText({sizeFactor = 0.5,text = "Sprite size"}),
                        DUI.newText({text = spriteInfo.spriteSize, outVar = spriteSizeText})
                    }
                }),
                DUI.newButton({text = ">", onClick = increaseSprite},STYLE.STYLEDBUTTON)
            }
        })            
    }
end

return m
