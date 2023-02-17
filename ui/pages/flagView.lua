local m = {}

function m.createFlagView(root,flagInfo)

    flagInfo.flagName = {}
    flagInfo.flagName.text = ""
    flagInfo.list = {}

    function flagInfo.createFlag()

        if flagInfo.flagName.text == "" then
            return
        end

        for i = 1, #flagInfo.list.items do
            if flagInfo.list.items[i].data == flagInfo.flagName.text then
                return
            end
        end

        flagInfo.list.addItem(flagInfo.flagName.text)
        flagInfo.flagName.text = ""
        flagInfo.flagName.setText("")
    end

    return {
        DUI.newText({sizeFactor = 0.04, text = "Flags"}),
        DUI.newHorizontalContainer({
            sizeFactor = 0.06,
            padding = 2,
            children = {
                DUI.newTextInput({sizeFactor = 0.5, alignmet = "center", placeholder = "flag name", outVar = flagInfo.flagName},STYLE.STYLEDTEXTINPUT),
                DUI.newButton({text = "Create", onClick = flagInfo.createFlag}, STYLE.STYLEDBUTTON)
            }
        }),
        DUI.newListContainer({
            bg_color = COLOR.PRIMARY,
            outVar = flagInfo.list,
            item_highlight_color = COLOR.BUTTON_HIGHLIGHT,
            item = function(data) 
                return DUI.newHorizontalContainer({
                    bg_color = COLOR.WHITE,
                    margin = {3,3,3,2},
                    children = {
                        DUI.newText({alignmet = "center", text = data})
                    }
                })
            
            end
        })
        
    }
end

return m