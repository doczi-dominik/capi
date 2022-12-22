local m = {}

function m.createExportView()

    local function export()
        
    end


    return {
        DUI.newButton({sizeFactor = 0.09, text = "Export", onClick=export}, STYLE.STYLEDBUTTON)
    }
end

return m