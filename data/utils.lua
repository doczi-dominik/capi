local m = {}

---@param s string
---@param delim string
---@return string[]
function m.split(s, delim)
    local result = {}

    for match in (s..delim):gmatch("(.-)"..delim) do
        table.insert(result, match)
    end

    return result
end

return m