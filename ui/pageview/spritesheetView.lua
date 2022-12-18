local spritesheet = {
    DUI.newButton({sizeFactor = 0.10, text = "Import spritesheet"}, STYLE.STYLEDBUTTON),
    DUI.newHorizontalContainer({
        debug_name = "edit buttons",
        sizeFactor = 0.08,
        children = {
            DUI.newButton({sizeFactor = 0.2, text = "<"},STYLE.STYLEDBUTTON),
            DUI.newVerticalContainer({
                sizeFactor = 0.6,
                children = {
                    DUI.newText({sizeFactor = 0.5,text = "Selection size"}),
                    DUI.newText({text = "80"})
                }
            }),
            DUI.newButton({text = ">"},STYLE.STYLEDBUTTON)
        }
    }),
    DUI.newHorizontalContainer({
        sizeFactor = 0.08,
        children = {
            DUI.newButton({sizeFactor = 0.2, text = "<"},STYLE.STYLEDBUTTON),
            DUI.newVerticalContainer({
                sizeFactor = 0.6,
                children = {
                    DUI.newText({sizeFactor = 0.5,text = "Sprite size"}),
                    DUI.newText({text = "80"})
                }
            }),
            DUI.newButton({text = ">"},STYLE.STYLEDBUTTON)
        }
    })
    

}
return spritesheet