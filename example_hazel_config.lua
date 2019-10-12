-------------------------------
-- 以下函数请不要修改或删除
-------------------------------
waitTime = 10   -- seconds to wait after file changed, before running rules
--函数
-- Returns true if the file has any default OS X color tag enabled.
local function isColorTagged(file)
  local colors = {
    Red = true,
    Orange = true,
    Yellow = true,
    Green = true,
    Blue = true,
    Purple = true,
    Gray = true,
  }
  local tags = hs.fs.tagsGet(file)

  if tags ~= nil then
    for _,tag in ipairs(tags) do
      if colors[tag] then return true end
    end
  end
  return false
end

-- If the given file is older than the given time (in epoch seconds), return
-- true. This checks the inode change time, not the original file creation
-- time.
local function isOlderThan(file, seconds)
  local age = os.time() - hs.fs.attributes(file, 'change')
  if age > seconds then return true end
  return false
end


-- Return the last modified time of a file in epoch seconds.
local function lastModified(file)
  local when = os.time()
  if lib.exists(file) then when = hs.fs.attributes(file, 'modification') end
  return when
end


-- move a given file to toPath, overwriting the destination, with logging
local function moveFileToPath(file, toPath)
  local function onFileMoveSuccess(_)
    obj.log.i('Moved '..file..' to '..toPath)
  end

  local function onFileMoveFailure(stdErr)
    obj.log.e('Error moving '..file..' to '..toPath..': '..stdErr)
  end

  ufile.move(file, toPath, true, onFileMoveSuccess, onFileMoveFailure)
end
-- Splits a string by '/', returning the parent dir, filename (with extension),
-- and the extension alone.
local function splitPath(file)
  local parent = file:match('(.+)/[^/]+$')
  if parent == nil then parent = '.' end
  local filename = file:match('/([^/]+)$')
  if filename == nil then filename = file end
  local ext = filename:match('%.([^.]+)$')
  return parent, filename, ext
end

-- a filter that returns true if the given file should be ignored
local function ignored(file)
  if file == nil then return true end
  local _, filename, _ = splitPath(file)
  -- ignore dotfiles
  if filename:match('^%.') then return true end
  return false
end

-- Return true if the file exists, else false
local function exists(name)
  local f = io.open(name,'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

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
  hs.timer.doAfter(waitTime, function()
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
function watchDirectory(srcFilePath,files,processDirectory)
  watchPath(srcFilePath, files, function(data)
   processDirectory(srcFiePath,fils)
  end)
end

-------------------------------
--以上的函数请不要修改或者做任何改动
-------------------------------


-------------------------------
-------------------------------
-- 在此处添加自定义函数
-- 函数中的第一个参数srcFilePath 代表的是当前路径,即要监控的目录
-------------------------------

-- 监控Downloads文件夹
local function watchDownloads(srcFilePath,files)

    ---- send nzb and torrent files to the transfer directory
    --if data.ext == 'nzb' or data.ext == 'torrent' then
    --  moveFileToPath(data.file, obj.cfg.path.transfer)
    --else
    --  -- ignore files with color tags
    --  if not isColorTagged(data.file) then
    --    -- move files older than a week into the dump directory
    --    if isOlderThan(data.file, TIME.WEEK) then
    --      moveFileToPath(data.file, obj.cfg.path.dump)
    --    end
    --  end
    --end
    --
    --请在此处填写您要对本目录做的事情
    print("我要对Doloads目录做操作")
end





-------------------------------
--以下为开关，每监控一个目录写一行
-------------------------------
watchContent = { 
    --路径从用户目录开始，比如以下定义即表示~/Downloads 目录
    { filePath = "Downloads", action = watchDownloads }
}

