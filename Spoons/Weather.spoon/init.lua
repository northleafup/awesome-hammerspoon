--- === Caffeine ===
---
--- Prevent the screen from going to sleep
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Caffeine.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Caffeine.spoon.zip)
local obj = { __gc = true }
obj.__index = obj
--setmetatable(obj, obj)
obj.__gc = function(t)
    --t:stop()
end

-- Metadata
obj.name = "Weather"
obj.version = "1.0"
obj.author = "Chris Jones <cmsj@tenshu.net>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menuBarItem = nil
obj.hotkeyToggle = nil


function obj:init()
    self.menubar = hs.menubar.new()
    obj:start()
end





--local urlApi = 'https://www.tianqiapi.com/api'
local urlApi = ''
local menubar = hs.menubar.new()
local menuData = {}
local cityWeather = ''
local weaEmoji = {
   lei = '⛈',
   qing = '☀️',
   shachen = '😷',
   wu = '🌫',
   xue = '❄️',
   yu = '🌧',
   yujiaxue = '🌨',
   yun = '☁️',
   zhenyu = '🌧',
   yin = '⛅️',
   default = ''
}

function obj:start()
    getUrl()
    getWeather()
    hs.timer.doEvery(3600, getWeather)
    return self
end

--用于读取URL，需要读取private/weather_api_uri.lua中的内容
--示例：weatherurl = 'https://www.tianqiapi.com/api?version=v1&appid=1111111111&&appsecret=nN1u'
function getUrl()
    custom_config = hs.fs.pathToAbsolute(os.getenv("HOME") .. '/.hammerspoon/private/weather_api_url.lua')
    if custom_config then
        print("Loading weather_api_url.lua")
        require('private/weather_api_url')
        urlApi = weatherurl
    else
        print("There is no weather_api_url.lua")
        return
    end

end


function getWeather()
   hs.http.asyncGet(urlApi, tab, function(code, body,htable)
	  menubar:setTooltip(body)
      if code ~= 200 then
         print('get weather error:'..code)
	     menubar:setTooltip(code)
         return
      end
      rawjson = hs.json.decode(body)
      city = rawjson.city
      menuData = {}
      for k, v in pairs(rawjson.data) do
         if k == 1 then
            menubar:setTitle(weaEmoji[v.wea_img])
            titlestr = string.format("%s %s %s 🌡️%s 💧%s 💨%s 🌬 %s %s", city,weaEmoji[v.wea_img],v.day, v.tem, v.humidity, v.air, v.win_speed, v.wea)
            cityWeather = string.format("%s %s %s 🌡️%s 💧%s 💨%s 🌬 %s %s", city,weaEmoji[v.wea_img],v.day, v.tem, v.humidity, v.air, v.win_speed, v.wea)
            item = { title = titlestr }
            table.insert(menuData, item)
            table.insert(menuData, {title = '-'})
         else
            -- titlestr = string.format("%s %s %s %s", v.day, v.wea, v.tem, v.win_speed)
            titlestr = string.format("%s %s %s 🌡️%s 🌬%s %s", city, weaEmoji[v.wea_img],v.day, v.tem, v.win_speed, v.wea)
            item = { title = titlestr }
            table.insert(menuData, item)
         end
      end
      updateMenubar()
   end)
end

function updateMenubar()
    menubar:setTooltip(string.format("%s天气" , cityWeather))
    menubar:setMenu(menuData)
end







-------------------------------------------------
----- Caffeine:bindHotkeys(mapping)
----- Method
----- Binds hotkeys for Caffeine
-----
----- Parameters:
-----  * mapping - A table containing hotkey modifier/key details for the following items:
-----   * toggle - This will toggle the state of display sleep prevention, and update the menubar graphic
-----
----- Returns:
-----  * The Caffeine object
--function obj:bindHotkeys(mapping)
--    if (self.hotkeyToggle) then
--        self.hotkeyToggle:delete()
--    end
--    local toggleMods = mapping["toggle"][1]
--    local toggleKey = mapping["toggle"][2]
--    self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)
--
--    return self
--end
--
----- Caffeine:start()
----- Method
----- Starts Caffeine
-----
----- Parameters:
-----  * None
-----
----- Returns:
-----  * The Caffeine object
--function obj:start()
--    if self.menuBarItem then self:stop() end
--    self.menuBarItem = hs.menubar.new()
--    self.menuBarItem:setClickCallback(self.clicked)
--    if (self.hotkeyToggle) then
--        self.hotkeyToggle:enable()
--    end
--    self.setDisplay(hs.caffeinate.get("displayIdle"))
--
--    return self
--end
--
----- Caffeine:stop()
----- Method
----- Stops Caffeine
-----
----- Parameters:
-----  * None
-----
----- Returns:
-----  * The Caffeine object
--function obj:stop()
--    if self.menuBarItem then self.menuBarItem:delete() end
--    if (self.hotkeyToggle) then
--        self.hotkeyToggle:disable()
--    end
--    self.menuBarItem = nil
--    return self
--end
--
--function obj.setDisplay(state)
--    local result
--    if state then
--        result = obj.menuBarItem:setIcon(obj.spoonPath.."/caffeine-on.pdf")
--    else
--        result = obj.menuBarItem:setIcon(obj.spoonPath.."/caffeine-off.pdf")
--    end
--end
--
--function obj.clicked()
--    obj.setDisplay(hs.caffeinate.toggle("displayIdle"))
--end
--
return obj
