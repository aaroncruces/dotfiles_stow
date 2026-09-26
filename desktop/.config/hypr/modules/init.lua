-- ~/.config/hypr/modules/init.lua
--
-- Auto-loads every .lua file in this folder except init.lua itself. This keeps
-- hyprland.lua as a tiny entrypoint while allowing appearance, keybindings,
-- inputs, programs, and host-specific modules to be maintained separately.

-- Resolve the directory that contains this loader. debug.getinfo returns the
-- current chunk path prefixed with "@", so the pattern strips that prefix while
-- keeping the trailing slash needed by the ls command below.
local dir = debug.getinfo(1).source:match("@?(.*/)") or ""

-- Hyprland Lua modules are loaded for their side effects: each required module
-- calls hl.config(), hl.bind(), hl.env(), or similar APIs during evaluation.
for filename in io.popen('ls "' .. dir .. '"*.lua 2>/dev/null'):lines() do
    local name = filename:match("([^/]+)%.lua$")
    if name and name ~= "init" then
        -- Module names are relative to ~/.config/hypr because hyprland.lua
        -- requires this directory as "modules".
        require("modules." .. name)
    end
end
