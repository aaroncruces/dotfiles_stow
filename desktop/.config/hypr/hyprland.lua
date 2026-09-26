-- Hyprland Lua entrypoint.
--
-- Hyprland loads this file first. Keep it deliberately small so the real
-- configuration can stay split across focused files in modules/.
--
-- require("modules") resolves to modules/init.lua, and that loader imports
-- every sibling .lua file except itself.
require("modules")
