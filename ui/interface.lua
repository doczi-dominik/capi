local createMapEditorSheet = require("ui.mapEditorSheet")

local m = {}

---@param projectData projectData
---@param panelInfo table
---@param toolMediator toolMediator
---@return table
function m.createRoot(projectData, panelInfo, toolMediator)
    local icons = {
        gridButton = LG.newImage("assets/icons/grid.png"),
        moveButton = LG.newImage("assets/icons/move.png"),
        paintbrushButton = LG.newImage("assets/icons/paintbrush.png"),
        fillButton = LG.newImage("assets/icons/fill.png")
    }

    ---@class buttonOptions
    local barButtonStyle = {
        bg_color = COLOR.BUTTON_COLOR,
        highlight_color = COLOR.BUTTON_HIGHLIGHT,
        sizeFactor = 1/4,
        alignmet = "+90",
        color = COLOR.BLACK,

        dependencyTable = {},

        drawExt = function (self)
            if self.isOn then
                self.w = self.tw + self.parent.padding[3] * 2+ self.parent.margin[3] * 2
            else 
                self.w = self.tw
            end
        end,
    }

    ---@type buttonOptions
    local tools = {
        bg_color = COLOR.BUTTON_COLOR,
        highlight_color = COLOR.BUTTON_HIGHLIGHT,
        sizeFactor = 0.04,
        margin = 2,
        dependencyTable = {}
    }

    local barButtonOnClick = function(b)
        panelInfo.setChild(PAGES[b.dependencyIndex])
        local p = panelInfo.parent
        p.computeLayout(p.computeX, p.computeY, p.computeW, p.computeH, p.computeFun)
        
    end

    local mapEditorSheet = createMapEditorSheet(projectData, toolMediator)

    local toggleGrid = function()
        mapEditorSheet.showGrid = not mapEditorSheet.showGrid
    end

    return DUI.newMainContainer({ -- Main Window
        child = DUI.newHorizontalContainer({
            children = {
                DUI.newHorizontalContainer({ -- Side panel
                    sizeFactor = 0.26,
                    bg_color = COLOR.PRIMARY,
                    children = {
                        DUI.newVerticalContainer({ -- Actionbar
                            sizeFactor = 0.11,
                            margin = 3,
                            padding = {2,2,0,2},
                            children = {
                                DUI.newButton({dependencyIndex = 1,text = "Spritesheet", onClick = barButtonOnClick, defaultOn = true}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 2,text = "Sprites", onClick = barButtonOnClick}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 3,text = "Flags", onClick = barButtonOnClick}, barButtonStyle),
                                DUI.newButton({dependencyIndex = 4,text = "Project", onClick = barButtonOnClick}, barButtonStyle),
                            }
                        }),
                        DUI.newVerticalContainer({ -- Panel BG
                            bg_color = COLOR.BUTTON_HIGHLIGHT,
                            margin = 5,
                            padding = 1,
                            children = {
                                DUI.newVerticalContainer({ -- Panel Content
                                    margin = 4,
                                    padding = 1,
                                    outVar = panelInfo
                                })
                            }
                        })
                    }
                }),
                DUI.newVerticalContainer({ -- Editor winow
                    children = {
                        DUI.newContainer({outVar = mapEditorSheet, sizeFactor = 0.948}),
                        DUI.newHorizontalContainer({
                            bg_color = COLOR.PRIMARY,
                            padding = {0,1,0,1},
                            children = {  -- Bottom bar buttons
                                DUI.newButton({sprite = icons.gridButton, toggleable = true, onClick = toggleGrid, defaultOn = true}, tools),
                                DUI.newButton({sprite = icons.moveButton, defaultOn = true, dependencyIndex = 1, onClick = function() toolMediator.selectedTool = "move" end}, tools),
                                DUI.newButton({sprite = icons.paintbrushButton, dependencyIndex = 2, onClick = function() toolMediator.selectedTool = "paintbrush" end}, tools),
                                DUI.newButton({sprite = icons.fillButton, dependencyIndex = 3, onClick = function() toolMediator.selectedTool = "fill" end}, tools),
                                DUI.newButton({sizeFactor = 0.7}),
                                DUI.newText({text = "Zoom: 100%", outVar = mapEditorSheet.zoomText, color = COLOR.BUTTON_HIGHLIGHT})
                            }
                        })
                    }
                }) 
            }
        })})
end

return m