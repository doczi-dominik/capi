local spritesheet = {
    DUI.newButton({sizeFactor = 0.10, text = "Import spritesheet"}, STYLE.STYLEDBUTTON),
    DUI.newHorizontalContainer({
        debug_name = "edit buttons",
        sizeFactor = 0.10,
        children = {
            DUI.newButton({sizeFactor = 0.2, text = "<"},STYLE.STYLEDBUTTON),
            DUI.newButton({sizeFactor = 0.6}, STYLE.STYLEDBUTTON),
            DUI.newButton({sizeFactor = 1, text = ">"},STYLE.STYLEDBUTTON)
        }
    })

}
return spritesheet