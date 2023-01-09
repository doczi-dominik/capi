local m = {}

local titleImage = LG.newImage("assets/image/happybara.png")
local githubImage = LG.newImage("assets/icons/github-mark.png")

function m.createWindow()
    return DUI.newMainContainer({
        child = DUI.newHorizontalContainer({ -- Background
            bg_color = COLOR.PRIMARY,
            debug_name= "bg",
            padding = 15,
            children = {
                DUI.newVerticalContainer({ -- Main Content
                    bg_color = COLOR.BUTTON_HIGHLIGHT,
                    debug_name= "main conent",
                    children = {
                        DUI.newContainer({sizeFactor=0.15}),
                        DUI.newHorizontalContainer({
                            sizeFactor=0.15,
                            children = {
                                DUI.newText({sizeFactor=0.5,alignmet = "right",text = "Capi",font = STYLE.FONTS.H1}),
                                DUI.newButton({sizeFactor=0.07,sprite=titleImage})
                            }
                        }),
                        DUI.newText({sizeFactor=0.01,text="v.01"}),
                        DUI.newText({sizeFactor=0.1}), -- BreakLine
                        DUI.newHorizontalContainer({
                            sizeFactor = 0.5,
                            padding = {40,0,40,30},
                            margin = {100,0,100,0},
                            children = {
                                DUI.newVerticalContainer({
                                    sizeFactor = 0.5,
                                    children = {
                                        DUI.newText({sizeFactor = 0.25}),
                                        DUI.newButton({sizeFactor=0.25, text = "Open project"},STYLE.STYLEDBUTTON)
                                    }
                                }),
                                DUI.newVerticalContainer({
                                    debug_name = "buttons",
                                    children = {
                                        DUI.newText({sizeFactor = 0.1}),
                                        DUI.newVerticalContainer({
                                            sizeFactor = 0.5,
                                            children = {
                                                DUI.newHorizontalContainer({
                                                    sizeFactor = 0.3,
                                                    padding = 1,
                                                    debug_name = "fields",
                                                    children = {
                                                        DUI.newTextInput({alignmet = "center",sizeFactor = 0.5,placeholder = "Project Name:"},STYLE.STYLEDTEXTINPUT),
                                                        DUI.newTextInput({alignmet = "center",placeholder = "Sprite size:",filter="number",max_characters=3},STYLE.STYLEDTEXTINPUT)
                                                    }
                                                }),
                                                DUI.newButton({sizeFactor = 0.5,text = "Create project"},STYLE.STYLEDBUTTON)
                                            }
                                        })
                                    }
                                }),
                            }
                        }),
                        DUI.newHorizontalContainer({
                            children = {DUI.newButton({
                                sprite = githubImage,
                                debug_name = "balls",
                                bg_color = COLOR.WHITE,
                                onClick=function ()
                                    print("balls")
                                    love.system.openURL("https://github.com/doczi-dominik/capi" )
                                end
                        })}
                        })
                    }
                })
            }
        })
    })
end

return m