local m = {}

function m.createSprite(root, spriteInfo, spritePalette)
	local spriteSelectText = {}
	spriteInfo.selectionSize = 1

	function spritePalette.draw(t)
		LG.setColor(COLOR.PRIMARY)
		LG.rectangle("fill", t.x, t.y, t.w, t.h)
	end

	return {
		DUI.newContainer({ outVar = spritePalette }), --- sprite palette container
	}
end

return m
