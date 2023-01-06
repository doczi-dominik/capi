local m = {}

function m.createWindow()
    return DUI.newMainContainer({
        child = DUI.newHorizontalContainer({ -- Background
            bg_color = COLOR.PRIMARY,
            children = {
                DUI.newHorizontalContainer({ -- Main Content
                    margin = 50,
                    bg_color = COLOR.BUTTON_HIGHLIGHT
                })
            }
        })
    })
end

return m