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

-- time constants
local TIME = {}
TIME.SECHOND= 5
TIME.MINUTE = 60
TIME.HOUR = TIME.MINUTE * 60
TIME.DAY = TIME.HOUR * 24
TIME.WEEK = TIME.DAY * 7

function obj:init()
    obj:start()
end




local timer = nil


local function runOnFiles(path, watchDirectory,callback)
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
               runOnFiles(basePath,watchDirectory,value.action)
            end
    end
end

function obj.start()
  timer = hs.timer.new(TIME.SECHOND, checkPaths)
  timer:start()
end

function obj.stop()
  if timer then timer:stop() end
  timer = nil
end
return obj
