local m = {}

-- Returns the filepath
function m.fileDialoge()
    local fileHandle = io.popen("open.bat")
    return fileHandle:read("*a")
end

function m.readFileData()
    local filepath = m.fileDialoge()
    return love.filesystem.newFileData(filepath)
end

return m