hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

local obj = {}
require('utils/path')

hsreload_keys = hsreload_keys or {{"cmd", "shift", "ctrl"}, "R"}
if string.len(hsreload_keys[2]) > 0 then
    hs.hotkey.bind(hsreload_keys[1], hsreload_keys[2], "Reload Configuration", function() hs.reload() end)
end

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

--obj.path_util.loadfile('private/load_which_spoon')
loadfile('private/load_which_spoon')

    print('no===============')
--loadfile('private/global_key')

-- Define default Spoons which will be loaded later
if not hspoon_list then
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



--obj.reKey()

spoon.ModalMgr.supervisor:enter()
