local m = {}

function m.createExportView(root)
	local function export() end

	return {
		DUI.newButton({ sizeFactor = 0.07, text = "Options", onClick = export }, STYLE.STYLEDBUTTON),
		DUI.newButton({ sizeFactor = 0.07, text = "Save project", onClick = export }, STYLE.STYLEDBUTTON),
		DUI.newText({ sizeFactor = 0.045, text = "Last saved XY minutes ago" }),
		DUI.newButton({ sizeFactor = 0.07, text = "Export", onClick = export }, STYLE.STYLEDBUTTON),
		DUI.newButton({ sizeFactor = 0.07, text = "Open folder", onClick = export }, STYLE.STYLEDBUTTON),
	}
end

return m
