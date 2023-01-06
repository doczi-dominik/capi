local m = {}

function m.createFlagView(root,flagInfo)

    flagInfo.flagName = {}

    function flagInfo.createFlag()
    end

    function flagInfo.removeFlag()
    end

    return {
        DUI.newText({sizeFactor = 0.05, text = "Flags"}),
        DUI.newHorizontalContainer({
            sizeFactor = 0.06,
            bg_color = COLOR.PRIMARY,
            children = {
                DUI.newTextInput({sizeFactor = 0.5, alignmet = "center", placeholder = "flag name", outVar = flagInfo.flagName},STYLE.STYLEDTEXTINPUT),
                DUI.newButton({text = "Create", onClick = flagInfo.createFlag}, STYLE.STYLEDBUTTON)
            }
        }),
        DUI.newListContainer({bg_color = COLOR.PRIMARY})
        
    }
end

return m