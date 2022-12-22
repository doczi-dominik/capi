local m = {}
local fileManager = require("file_manager")

function m.createSpriteSheet(spriteInfo)
    local spriteSizeText = {}

    spriteInfo.selectionSize = 1
    spriteInfo.spriteSize = 2
    spriteInfo.importedFileData = nil
    
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
        DUI.newButton({sizeFactor = 0.09, text = "Import spritesheet", onClick = importFileData}, STYLE.STYLEDBUTTON),
        DUI.newHorizontalContainer({
            sizeFactor = 0.07,
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
