local m = {}

local titleImage = LG.newImage("assets/image/happybara.png")
local githubImage = LG.newImage("assets/icons/github-mark.png")



function m.createWindow()

    local function createProject()
        CURRENT_WINDOW = WINDOWS.EDITOR
        WINDOWS.EDITOR.computeLayout()
    end

    local function openProject()
        CURRENT_WINDOW = WINDOWS.EDITOR
        WINDOWS.EDITOR.computeLayout()
    end

    return DUI.newMainContainer({
        child = DUI.newHorizontalContainer({ -- Background
            bg_color = COLOR.PRIMARY,
            padding = 15,
            children = {
                DUI.newVerticalContainer({ -- Main Content
                    bg_color = COLOR.BUTTON_HIGHLIGHT,
                    children = {
                        DUI.newContainer({sizeFactor=0.15}),
                        DUI.newHorizontalContainer({
                            sizeFactor=0.15,
                            children = {
                                DUI.newText({sizeFactor=0.5,alignmet = "right",text = "Capi",font = STYLE.FONTS.H1}),
                                DUI.newButton({sizeFactor=0.07,sprite=titleImage})
                            }
                        }),
                        DUI.newText({sizeFactor=0.01,text="v.0.0.80085"}),
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
                                        DUI.newButton({sizeFactor=0.25, text = "Open project", onClick = openProject},STYLE.STYLEDBUTTON)
                                    }
                                }),
                                DUI.newVerticalContainer({
                                    children = {
                                        DUI.newText({sizeFactor = 0.1}),
                                        DUI.newVerticalContainer({
                                            sizeFactor = 0.5,
                                            children = {
                                                DUI.newHorizontalContainer({
                                                    sizeFactor = 0.3,
                                                    padding = 1,
                                                    children = {
                                                        DUI.newTextInput({alignmet = "center",sizeFactor = 0.5,placeholder = "Project Name"},STYLE.STYLEDTEXTINPUT),
                                                        DUI.newTextInput({alignmet = "center",placeholder = "Sprite size",filter="number",max_characters=3},STYLE.STYLEDTEXTINPUT)
                                                    }
                                                }),
                                                DUI.newButton({sizeFactor = 0.5,text = "Create project",onClick=createProject},STYLE.STYLEDBUTTON)
                                            }
                                        })
                                    }
                                }),
                            }
                        }),
                        DUI.newHorizontalContainer({
                            children = {DUI.newButton({
                                sprite = githubImage,
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