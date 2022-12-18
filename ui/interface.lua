
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
                self.w = self.tw + self.parent.padding * 2
            end
        end,
    }

    local barButtonOnClick = function(b)
        panelInfo.setChild(PAGES[b.dependencyIndex])
        ROOT.computeLayout()
    end

    return DUI.newMainContainer({
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
                                DUI.newButton({dependencyIndex = 1,text = "draw", onClick = barButtonOnClick, defaultOn = true}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 2,text = "spritesheet", onClick = barButtonOnClick}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 3,text = "spritesheet", onClick = barButtonOnClick}, barButtonStyle),
                            }
                        }),
                        DUI.newVerticalContainer({
                            bg_color = COLOR.BUTTON_HIGHLIGHT,
                            margin = 5,
                            debug_name = "mukodj",
                            padding = 6,
                            outVar = panelInfo
                        })
                    }
                }),
                DUI.newContainer({outVar = sheetInfo})
            }
        })})
end

return m