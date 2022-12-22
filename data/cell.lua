
---@class cell
---@field sprites integer[]
---@field flagOverrides string[]|nil

---@return cell
local function createCell()
    local c = {}  ---@type cell

    c.sprites = {}
    c.flagOverrides = nil

    return c
end

return createCell