local m = {}

-- Returns the filepath
function m.fileDialoge()
    local fileHandle = io.popen("open.bat")
    local path = fileHandle:read("*a")
    return string.sub(path,2,#path - 1)
end

function m.readFileData()
    local filepath = m.fileDialoge()

    local f = assert(io.open(filepath, "rb"))
    local data = f:read("*all")
    f:close()
    return love.image.newImageData(love.filesystem.newFileData(data, "image.png"))
end

return m