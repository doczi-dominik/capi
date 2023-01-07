local m = {}
local fileManager = require("file_manager")

function m.createSpriteSheet(root,spriteInfo)
        
    local function importFileData()
        spriteInfo.importedFileData = fileManager.fileDialogue()
    end

    local paletteName = {}
    local paletteSpriteSize = {}

    spriteInfo.list = {}
    paletteName.text = ""
    paletteSpriteSize.text = ""

    function spriteInfo.addItem()
        if paletteName.text == "" then return end

        spriteInfo.list.addItem(paletteName.text)
        paletteName.text = ""; paletteName.setText("")
    end

    return { 
        DUI.newHorizontalContainer({
            sizeFactor = 0.07,
            padding = 2,
            children = {
                DUI.newText({sizeFactor = 0.5,text = "Palette name:", alignmet = "left"}),
                DUI.newTextInput({alignmet ="center", filter ="any", max_characters = 20, outVar = paletteName, placeholder = "name", onEnter=spriteInfo.addItem},STYLE.STYLEDTEXTINPUT)

            }
        }),   
        DUI.newHorizontalContainer({
            sizeFactor = 0.08,
            children = {
                DUI.newButton({sizeFactor = 0.6, margin = 2, text = "Import image", onClick = importFileData}, STYLE.STYLEDBUTTON),
                DUI.newButton({sizeFactor = 0.4, margin = 2, text = "Create", onClick = spriteInfo.addItem}, STYLE.STYLEDBUTTON),
            }
        }),  
        DUI.newListContainer({
            bg_color = COLOR.PRIMARY, 
            outVar = spriteInfo.list,
            item_height = 70,
            item = function(data)
                return DUI.newHorizontalContainer({
                    bg_color = COLOR.BUTTON_COLOR,
                    margin = {4,4,4,2},
                    children = DUI.newText({text = "data",bg_color = COLOR.BLACK})
                })
            end
        })    
    }
end

return m
