
--多久执行一次定时任务,单位为秒,如不写默认为60*60秒，即一小时
time_scheduled = 5

-------------------------------
-- 在此处添加自定义函数
-- 函数中的第一个参数必须为srcFilePath 代表的是要监控的目录
-------------------------------

-- 监控Downloads文件夹
function watchDownloads(srcFilePath,files)

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
    print("watchDownloads")
end





-------------------------------
--以下为开关，每监控一个目录写一行
-------------------------------
watchContent = { 
    --路径从用户目录开始，比如以下定义即表示~/Downloads 目录
    { filePath = "Downloads", action = watchDownloads }
}



--- Hazel:stop()
--- Method
--- Stops Hazel
---
--- Parameters:
---  * None
---
--- Returns:
---  * The Hazel object
---- callback for watching the dump directory
--local function watchDump(files)
--  -- obj.log.d('watchDump ----')
--  watchPath(obj.cfg.path.dump, files, function(data)
--    -- obj.log.d('watchDump processing', hs.inspect(data))
--
--    -- for files older than six weeks
--    if ufile.isOlderThan(data.file, TIME.WEEK * 6) then
--      -- tag the file
--      ufile.setTag(data.file, 'Needs Attention')
--      -- move it to the desktop
--      moveFileToPath(data.file, obj.cfg.path.desktop)
--      -- send a notification
--      uapp.notify(obj.name, data.filename..' has been ignored for 6 weeks!')
--    end
--  end)
--end
--
---- callback for watching the desktop
--local function watchDesktop(files)
--  -- obj.log.d('watchDesktop ----')
--  watchPath(obj.cfg.path.desktop, files, function(data)
--    -- obj.log.d('watchDesktop processing', hs.inspect(data))
--
--    -- unhide extensions for files written here (notably, screenshots)
--    ufile.unhideExtension(data.file, data.ext, obj.cfg.hiddenExtensions)
--  end)
--end
--
---- callback for watching the documents directory
--local function watchDocuments(files)
--  -- obj.log.d('watchDocuments ----')
--  watchPath(obj.cfg.path.documents, files, function(data)
--    -- obj.log.d('watchDocuments processing', hs.inspect(data))
--
--    -- unhide extensions for files written here
--    ufile.unhideExtension(data.file, data.ext, obj.cfg.hiddenExtensions)
--  end)
--end

