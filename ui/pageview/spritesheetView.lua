local m = {}
local fileManager = require("file_manager")

function m.createSpriteSheet(spriteInfo)
        
    local function importFileData()
        spriteInfo.importedFileData = fileManager.fileDialogue()
    end

    local paletteName = {}
    local paletteSpriteSize = {}
    paletteName.text = ""
    paletteSpriteSize.text = ""

    local function removePalette(button)
        local list = button.parent.parent
        local name = button.parent.debug_name
        for i = 1, #list.children do
            if list.children[i].debug_name == name then
                table.remove(list.children, i)
                break
            end
        end

        ROOT.computeLayout()
    end

    local function createPalette()
        if paletteName.text == "" or paletteSpriteSize.text == "" then
            return
        end
        
        for i = 1, #spriteInfo.children do
            if spriteInfo.children[i].debug_name == paletteName.text then
                return
            end
        end

        spriteInfo.addChild(DUI.newHorizontalContainer({ 
            debug_name = paletteName.text,
            sizeFactor = 0.1,
            margin = {3,3,3,2},
            bg_color = COLOR.BUTTON_COLOR,
            children = {
                DUI.newText({sizeFactor = 0.83, text = paletteName.text}),
                DUI.newButton({color = COLOR.WHITE,sprite = LG.newImage("assets/icons/trash.png"),onClick = removePalette, margin = {0,3,0,0}})
            }
        }))
        ROOT.computeLayout()

        paletteName.text = ""
        paletteSpriteSize.text = ""
        paletteName.setText("")
        paletteSpriteSize.setText("")
    end

    return { 
        DUI.newHorizontalContainer({
            sizeFactor = 0.07,
            padding = 2,
            children = {
                DUI.newText({sizeFactor = 0.5,text = "Palette name:", alignmet = "left"}),
                DUI.newTextInput({alignmet ="center", filter ="any", max_characters = 20, outVar = paletteName, placeholder = "name", onEnter=createPalette},STYLE.STYLEDTEXTINPUT)

            }
        }),   
        DUI.newHorizontalContainer({
            sizeFactor = 0.07,
            padding = 2,
            children = {
                DUI.newText({sizeFactor = 0.65,text = "Sprite dimension:", alignmet = "left"}),
                DUI.newTextInput({alignmet ="center", filter ="number", max_characters = 3, outVar = paletteSpriteSize, placeholder = "16", onEnter = createPalette},STYLE.STYLEDTEXTINPUT)

            }
        }),
        DUI.newHorizontalContainer({
            sizeFactor = 0.08,
            children = {
                DUI.newButton({sizeFactor = 0.6, margin = 2, text = "Import image", onClick = importFileData}, STYLE.STYLEDBUTTON),
                DUI.newButton({sizeFactor = 0.4, margin = 2, text = "Create", onClick = createPalette}, STYLE.STYLEDBUTTON),
            }
        }),  
        DUI.newVerticalContainer({bg_color = COLOR.PRIMARY, outVar = spriteInfo})    
    }
end

return m
