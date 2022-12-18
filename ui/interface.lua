local root = DUI.newMainContainer({
    child = DUI.newHorizontalContainer({
        children = {
            DUI.newHorizontalContainer({ -- sidebar container
                sizeFactor = 0.3,
                bg_color = COLOR.PRIMARY,
                children = {
                    DUI.newVerticalContainer({-- actionbar
                        sizeFactor = 0.13,
                        padding = 5,
                        children = {
                            DUI.newButton({dependencyIndex = 1,text = "draw",defaultOn = true},STYLE.ACTIONBARBUTTON),
                            DUI.newButton({dependencyIndex = 2,text = "spritesheet"},STYLE.ACTIONBARBUTTON),
                            DUI.newButton({dependencyIndex = 3,text = "spritesheet"},STYLE.ACTIONBARBUTTON),
                        }
                    }),
                    DUI.newVerticalContainer({
                        bg_color = COLOR.BUTTON_HIGHLIGHT,
                        margin = 5,
                        debug_name = "mukodj",
                        padding = 6,
                        outVar = PANELINFO
                    }) 
                }
            }),
            DUI.newContainer({outVar = SHEETINFO})            
        }
    })
})
return root