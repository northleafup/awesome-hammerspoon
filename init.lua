hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

--get user home dir
local function getUserHomeDir()
    return hs.fs.pathToAbsolute(os.getenv("HOME"))
end
--combine tow path 
local function getPathAbsolute(path1, path2)
    return hs.fs.pathToAbsolute(string.format("%s/%s",path1,path2))
end
-- get file in user home directory
local function getUserFilePathhAbsolute(path)
    return getPathAbsolute(base_path,path)
end
--get hommerspoon home dir
local function getHommerSpoonDir()
    return getUserFilePathhAbsolute(".hammerspoon")
end

-- get user customer config,there is no '.lua' in path 
local function getUserConfig(path)
    return getPathAbsolute(getHommerSpoonDir(),string.format("%s%s%s","/",path,".lua"))
end

--load user file
local function loadfile(path)
    if getUserConfig(path) then
        require(path)
    end
end

hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", function() hs.reload() end)
end

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

loadfile('private/load_which_spoon')
loadfile('private/global_key')

-- Define default Spoons which will be loaded later
if not hspoon_list then
    print('no===============')
    hspoon_list = {
        "Caffeine",
        "SpeedMenu",
        "WinWin",
    }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end


----------------------------------------------------------------------------------------------------
-- appM modal environment
spoon.ModalMgr:new("appM")
local cmodal = spoon.ModalMgr.modal_list["appM"]
cmodal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
if not hsapp_list then
  hsapp_list = {
        {key = 'f', name = 'Finder'},
        {key = 's', name = 'Safari'},
        {key = 't', name = 'Terminal'},
        {key = 'v', id = 'com.apple.ActivityMonitor'},
        {key = 'y', id = 'com.apple.systempreferences'},
    }
end
for _, v in ipairs(hsapp_list) do
    if v.id then
        local located_name = hs.application.nameForBundleID(v.id)
        if located_name then
            cmodal:bind('', v.key, located_name, function()
                hs.application.launchOrFocusByBundleID(v.id)
                spoon.ModalMgr:deactivate({"appM"})
            end)
        end
    elseif v.name then
        cmodal:bind('', v.key, v.name, function()
            hs.application.launchOrFocus(v.name)
            spoon.ModalMgr:deactivate({"appM"})
        end)
    end
end

spoon.ModalMgr.supervisor:enter()
