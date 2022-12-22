
local m = {}

function m.createRoot(panelInfo, sheetInfo)
    local barButtonStyle = {
        bg_color = COLOR.BUTTON_COLOR,
        highlight_color = COLOR.BUTTON_HIGHLIGHT,
        sizeFactor = 1/3,
        alignmet = "+90",
        color = COLOR.BLACK,

        dependencyTable = {},

        drawExt = function (self)
            if self.isOn then
                self.w = self.tw + self.parent.padding[3] * 2+ self.parent.margin[3] * 2
            end
        end,
    }

    local barButtonOnClick = function(b)
        panelInfo.setChild(PAGES[b.dependencyIndex])
        ROOT.computeLayout()
    end

    return DUI.newMainContainer({ -- Main Window
        child = DUI.newHorizontalContainer({
            children = {
                DUI.newHorizontalContainer({ -- Side panel
                    sizeFactor = 0.3,
                    bg_color = COLOR.PRIMARY,
                    children = {
                        DUI.newVerticalContainer({ -- Actionbar
                            sizeFactor = 0.11,
                            margin = 3,
                            padding = {2,2,0,2},
                            children = {
                                DUI.newButton({dependencyIndex = 1,text = "draw", onClick = barButtonOnClick, defaultOn = true}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 2,text = "spritesheet", onClick = barButtonOnClick}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 3,text = "spritesheet", onClick = barButtonOnClick}, barButtonStyle),
                            }
                        }),
                        DUI.newVerticalContainer({ -- Panel
                            bg_color = COLOR.BUTTON_HIGHLIGHT,
                            margin = 5,
                            padding = 6,
                            outVar = panelInfo
                        })
                    }
                }),
                DUI.newVerticalContainer({ -- Editor winow
                    children = {
                        DUI.newContainer({outVar = sheetInfo, sizeFactor = 0.95}),
                        DUI.newHorizontalContainer({
                            bg_color = COLOR.PRIMARY
                        })
                    }
                }) 
            }
        })})
end

return m