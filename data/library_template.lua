local m = {}

m.libs_raw_flags = [[

---@class sprite
---@field flags string[]
---@field draw fun(x: number, y: number)

---@return sprite
local function createSprite(image, sx, sy, sw, sh, flags)
    local s = {}
    local quad = love.graphics.newQuad(sx, sy, spriteSize, spriteSize, image:getDimensions())

    s.flags = flags or {}

    function s.draw(x, y)
        LG.draw(image, quad, x, y)
    end

    return s
end

local raw = {}
local flags = {}
]]

m.decompress = [[

local sprites = {}

for i, v in ipairs(raw) do
    local fdata = love.filesystem.newFileData(v, tostring(i)..".png")
    local idata = love.image.newImageData(fd)
    local img = love.graphics.newImage(idata)
    local sw, sh = img:getDimensions()

    for y = 0, sh, spriteSize do
        for x = 0, sw, spriteSize do
            local index = #sprites+1
            sprites[index] = createSprite(img, x, y, sw, sh, flags[index])
        end
    end
end

]]

return m