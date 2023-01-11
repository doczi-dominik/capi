local m = {}

function m.createExportView(root)

    local function export()
        
    end


    return {
        DUI.newButton({sizeFactor = 0.09, text = "Open project", onClick=export}, STYLE.STYLEDBUTTON),
        DUI.newButton({sizeFactor = 0.09, text = "Export", onClick=export}, STYLE.STYLEDBUTTON),
    }
end

return m