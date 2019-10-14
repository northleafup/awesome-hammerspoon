-- appM environment keybindings. Bundle `id` is prefered, but application `name` will be ok.
hsapp_list = {
    {key = 'a', name = 'Atom'},
    {key = 'c', id = 'com.google.Chrome'},
    {key = 'd', name = 'ShadowsocksX'},
    {key = 'e', name = 'Emacs'},
    {key = 'f', name = 'Finder'},
    {key = 'i', name = 'iTerm'},
    {key = 'k', name = 'KeyCastr'},
    {key = 'l', name = 'Sublime Text'},
    {key = 'm', name = 'MacVim'},
    {key = 'o', name = 'LibreOffice'},
    {key = 'p', name = 'mpv'},
    {key = 'r', name = 'VimR'},
    {key = 's', name = 'Safari'},
    {key = 't', name = 'Terminal'},
    {key = 'v', id = 'com.apple.ActivityMonitor'},
    {key = 'w', name = 'Mweb'},
    {key = 'y', id = 'com.apple.systempreferences'},
}

obj = {}
function obj.reKey1()
    print("this Is rekey1")
    
----------------------------------------------------------------------------------------------------
-- appM modal environment
spoon.ModalMgr:new("appM")
local cmodal = spoon.ModalMgr.modal_list["appM"]
cmodal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
if not hsapp_list then
    print('aaaaaaa')
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

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Register windowHints (Register a keybinding which is NOT modal environment with modal supervisor)
hswhints_keys = hswhints_keys or {"alt", "tab"}
if string.len(hswhints_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(hswhints_keys[1], hswhints_keys[2], 'Show Window Hints', function()
        spoon.ModalMgr:deactivateAll()
        hs.hints.windowHints()
    end)
end

------ Then we register some keybindings with modal supervisor
hsappM_keys = hsappM_keys or {"alt", "A"}
if string.len(hsappM_keys[2]) > 0 then
    print("this is keyboard")
    spoon.ModalMgr.supervisor:bind(hsappM_keys[1], hsappM_keys[2], "Enter AppM Environment", function()
        spoon.ModalMgr:deactivateAll()
        -- Show the keybindings cheatsheet once appM is activated
        spoon.ModalMgr:activate({"appM"}, "#FFBD2E", true)
    end)
end
end
return obj

--k-- Modal supervisor keybinding, which can be used to temporarily disable ALL modal environments.
--khsupervisor_keys = {{"cmd", "shift", "ctrl"}, "Q"}
--k
--k-- Reload Hammerspoon configuration
--khsreload_keys = {{"cmd", "shift", "ctrl"}, "R"}
--k
--k-- Toggle help panel of this configuration.
--khshelp_keys = {{"alt", "shift"}, "/"}
--k
--k-- aria2 RPC host address
--khsaria2_host = "http://localhost:6800/jsonrpc"
--k-- aria2 RPC host secret
--khsaria2_secret = "token"
--k
--k----------------------------------------------------------------------------------------------------
--k-- Those keybindings below could be disabled by setting to {"", ""} or {{}, ""}
--k
--k-- Window hints keybinding: Focuse to any window you want
--khswhints_keys = {"alt", "tab"}
--k
--k-- appM environment keybinding: Application Launcher
--khsappM_keys = {"alt", "A"}
--k
--k-- clipshowM environment keybinding: System clipboard reader
--khsclipsM_keys = {"alt", "C"}
--k
--k-- Toggle the display of aria2 frontend
--khsaria2_keys = {"alt", "D"}
--k
--k-- Launch Hammerspoon Search
--khsearch_keys = {"alt", "G"}
--k
--k-- Read Hammerspoon and Spoons API manual in default browser
--khsman_keys = {"alt", "H"}
--k
--k-- countdownM environment keybinding: Visual countdown
--khscountdM_keys = {"alt", "I"}
--k
--k-- Lock computer's screen
--khslock_keys = {"alt", "L"}
--k
--k-- resizeM environment keybinding: Windows manipulation
--khsresizeM_keys = {"alt", "R"}
--k
--k-- cheatsheetM environment keybinding: Cheatsheet copycat
--khscheats_keys = {"alt", "S"}
--k
--k-- Show digital clock above all windows
--khsaclock_keys = {"alt", "T"}
--k
--k-- Type the URL and title of the frontmost web page open in Google Chrome or Safari.
--khstype_keys = {"alt", "V"}
--k
--k-- Toggle Hammerspoon console
--khsconsole_keys = {"alt", "Z"}
--k
--
