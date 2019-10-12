--组合两个路径
function getPathAbsolute(path1, path2)
    return hs.fs.pathToAbsolute(string.format("%s/%s",path1,path2))
end
--获取用户路径下的某个文件
function getUserFilePathhAbsolute(path)
    return hs.fs.pathToAbsolute(string.format("%s/%s",os.getenv('HOME'),path))
end
