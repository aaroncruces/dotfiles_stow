-- ~/.config/hypr/modules/init.lua
-- Auto-loads every .lua file in this folder (except init.lua itself)
local dir = debug.getinfo(1).source:match("@?(.*/)") or ""

for filename in io.popen('ls "' .. dir .. '"*.lua 2>/dev/null'):lines() do
    local name = filename:match("([^/]+)%.lua$")
    if name and name ~= "init" then
        require("modules." .. name)
    end
end