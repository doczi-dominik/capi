local m = {}

function m.createFlagView()

    local function export()
        
    end


    return {
        DUI.newText({sizeFactor = 0.05, text = "Flags"}),
        DUI.newListContainer({})
    }
end

return m