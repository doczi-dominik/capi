local m = {}

function m.createFlagView()

    local function export()
        
    end


    return {
        DUI.newButton({sizeFactor = 0.09, text = "Flag", onClick=export}, STYLE.STYLEDBUTTON)
    }
end

return m