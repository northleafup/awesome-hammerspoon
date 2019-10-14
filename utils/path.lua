--get user home dir
function getUserHomeDir()
    return hs.fs.pathToAbsolute(os.getenv("HOME"))
end
--combine tow path 
function getPathAbsolute(path1, path2)
    return hs.fs.pathToAbsolute(string.format("%s/%s",path1,path2))
end
-- get file in user home directory
function getUserFilePathhAbsolute(path)
    return getPathAbsolute(getUserHomeDir(),path)
end
--get hommerspoon home dir
function getHommerSpoonDir()
    return getUserFilePathhAbsolute(".hammerspoon")
end

-- get user customer config,there is no '.lua' in path 
function getUserConfig(path)
    return getPathAbsolute(getHommerSpoonDir(),string.format("%s%s%s","/",path,".lua"))
end
--load user file
function loadfile(path)
    if getUserConfig(path) then
        require(path)
    end
end


