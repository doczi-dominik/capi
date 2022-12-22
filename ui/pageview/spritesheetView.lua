local m = {}
local fileManager = require("file_manager")

function m.createSpriteSheet(spriteInfo)
        
    function m.newPalette(name,size)
        local palette = {}

        palette.name = name or ""
        palette.size = size or ""

        return palette
    end

    local paletteName = {}
    local paletteSpriteSize = {}


    local function importFileData()
        spriteInfo.importedFileData = fileManager.fileDialogue()
    end

    local function createPalette()
        spriteInfo.addItem(m.newPalette(paletteName.text,paletteSpriteSize.text))
        paletteName.text = ""
    end

    function spriteInfo.draw(item,x,y,w,h)
        LG.setColor(COLOR.BUTTON_COLOR)
        LG.rectangle("fill",x + 4,y + 4,w - 8,h - 5)

        LG.setColor(COLOR.BLACK)
        LG.print(item.name,x,y)
        LG.print(item.size,x,y + 10)
    end

   

    return { 
        DUI.newHorizontalContainer({
            sizeFactor = 0.07,
            children = {
                DUI.newText({sizeFactor = 0.5,text = "Palette name:", alignmet = "left"}),
                DUI.newTextInput({alignmet ="center", filter ="any", max_characters = 20, outVar = paletteName},STYLE.STYLEDTEXTINPUT)

            }
        }),   
        DUI.newHorizontalContainer({
            sizeFactor = 0.07,
            children = {
                DUI.newText({sizeFactor = 0.65,text = "Sprite dimension:", alignmet = "left"}),
                DUI.newTextInput({alignmet ="center", filter ="number", max_characters = 3, outVar = paletteSpriteSize},STYLE.STYLEDTEXTINPUT)

            }
        }),
        DUI.newHorizontalContainer({
            sizeFactor = 0.09,
            children = {
                DUI.newButton({sizeFactor = 0.5, margin = 2, text = "Import image", onClick = importFileData}, STYLE.STYLEDBUTTON),
                DUI.newButton({sizeFactor = 0.5, margin = 2, text = "Create", onClick = createPalette}, STYLE.STYLEDBUTTON),
            }
        }),  
        DUI.newListContainer({bg_color = COLOR.PRIMARY, color = COLOR.WHITE, outVar = spriteInfo})    
    }
end

return m
