local m = {}

-- Returns the filepath
function m.fileDialoge()
    local fileHandle = io.popen("open.bat")
    return fileHandle:read("*a")
end

return m