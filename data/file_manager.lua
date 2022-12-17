
local m = {}

---@return love.FileData|nil
function m.fileDialogue()
    if love.system.getOS() ~= "Windows" then
        return
    end

    local fileHandle = io.popen("open.bat")

    if fileHandle == nil then
        return
    end

    local output = fileHandle:read("*a")
    local path = string.sub(output, 2, #output - 1)

    local f = io.open(path, "rb")

    if f == nil then
        return
    end

    local data = f:read("*a")
    f:close()

    return love.filesystem.newFileData(data, path)
end

return m