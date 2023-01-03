local m = {}

function m.createFlagView(flagInfo)

    

    return {
        DUI.newText({sizeFactor = 0.05, text = "Flags"}),
        DUI.newListContainer({})
    }
end

return m