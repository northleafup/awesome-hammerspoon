--- === Hazel ===
---
--- Prevent the screen from going to sleep
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Hazel.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Hazel.spoon.zip)
local obj = { __gc = true }
--obj.__index = obj
--setmetatable(obj, obj)
obj.__gc = function(t)
    t:stop()
end

-- Metadata
obj.name = "Hazel"
obj.version = "1.0"
obj.author = "Chris Jones <cmsj@tenshu.net>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.waitTime = 10   -- seconds to wait after file changed, before running rules

obj.time_scheduled = 60 * 60 
--加载工具类，不能使用require
-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()
dofile(obj.spoonPath.."/util.lua")
--------------------
--  基础paths 定义  --
--------------------
obj.paths = {}
obj.paths.base  = os.getenv('HOME')
obj.paths.hs    = getPathAbsolute(obj.paths.base, '.hammerspoon')

--读取参数，取自于文件private/hazel_config
dofile(getPathAbsolute(obj.paths.hs ,'private/hazel_config.lua'))

if time_scheduled  then 
 obj.time_scheduled = time_scheduled
end


function obj:init()
    obj:start()
end




local timer = nil


----------------------------------------------------------------------
----------------------------------------------------------------------
-- NOTE: Be careful not to modify a file each time it is watched.
-- This will cause the watch* function to be re-run every obj.cfg.waitTime
-- seconds, since the file gets modified each time, which triggers the
-- watch* function again.
----------------------------------------------------------------------
----------------------------------------------------------------------

-- callback for watching a given directory
-- process_cb is given a single argument that is a table consisting of:
--   {file: the full file path, parent: the file's parent directory full path,
--   filename: the basename of the file with extension, ext: the extension}
local function watchPath(path, files, process_cb)

  -- wait a little while before doing anything, to give files a chance to
  -- settle down.
  -- 10 可以自定义
  hs.timer.doAfter(obj.waitTime, function()
    -- loop through the files and call the process_cb function on any that are
    -- not ignored, still exist, and are found in the given path.
    for _,file in ipairs(files) do
      if not ignored(file) and exists(file) then
        local parent, filename, ext = splitPath(file)
        local data = {file=file, parent=parent, filename=filename, ext=ext}
        if parent == path then process_cb(data) end
      end
    end
  end):start()
end

-- callback by hazel module 
local function watchDirectory(srcFilePath,files,processDirectory)
  watchPath(srcFilePath, files, function(data)
   processDirectory(srcFiePath,files)
  end)
end

local function runOnFiles(path,callback)
  local files = {}
   local iterFn, dirObj = hs.fs.dir(path)
   if iterFn then
      for file in iterFn, dirObj do
        table.insert(files, getPathAbsolute(path, file)) 
      end
   else
      print(string.format("The following error occurred: %s", dirObj))
   end
  if #files > 0 then watchDirectory(path,files,callback) end
end



local function checkPaths()
    if watchContent then
        for _,value in ipairs(watchContent)
            do
               basePath  = getUserFilePathhAbsolute(value.filePath)
               runOnFiles(basePath,value.action)
            end
    end
end

function obj.start()

  timer = hs.timer.new(obj.time_scheduled, checkPaths)
  timer:start()
end

function obj.stop()
  if timer then timer:stop() end
  timer = nil
end
return obj
