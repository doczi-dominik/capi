local m = {}

function m.createSprite(root, spriteInfo, spritePalette)
	local spriteSelectText = {}
	spriteInfo.selectionSize = 1

	return {
		DUI.newContainer({ outVar = spritePalette }), --- sprite palette container
	}
end

return m
