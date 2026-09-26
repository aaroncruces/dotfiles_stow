-- nixdev monitor layout.
--
-- This host keeps only machine-specific monitor data here and delegates the
-- common behavior to lib.monitors: normal layout, gaming mode, wallpaper
-- startup, workspace rules, and SUPER+G / SUPER+SHIFT+G bindings.
local monitors = require("lib.monitors")

-- Stable Hyprland monitor selectors. These desc: strings come from EDID data
-- and are preferred here because the physical connector names may change.
local primary_monitor = "desc:Samsung Electric Company S24R35A H4TT303101"
local secondary1_monitor = "desc:AU Optronics 0x7EAD 0x00007EAD"
local secondary2_monitor = "desc:Samsung Electric Company S22F350 HCNT201138"

monitors.setup({
    -- Three-monitor work layout. The primary monitor sits between the two
    -- secondaries; gaming_mode is used only when SUPER+G is pressed.
    monitors = {
        primary = {
            output = primary_monitor,
            mode = "1920x1080@75",
            gaming_mode = "1920x1080@60",
            position = "1920x0",
            socket = "primary",
        },
        secondary1 = {
            output = secondary1_monitor,
            mode = "1920x1080@144",
            position = "0x0",
            socket = "sec1",
        },
        secondary2 = {
            output = secondary2_monitor,
            mode = "1920x1080@60",
            position = "3840x0",
            socket = "sec2",
        },
    },
    -- Workspace defaults pair each monitor with one primary workspace and one
    -- alternate workspace. The default flag tells Hyprland where new windows
    -- should prefer to land for that workspace.
    workspace_rules = {
        { workspace = "1", monitor = secondary1_monitor, default = true },
        { workspace = "6", monitor = secondary1_monitor },
        { workspace = "2", monitor = primary_monitor, default = true },
        { workspace = "7", monitor = primary_monitor },
        { workspace = "3", monitor = secondary2_monitor, default = true },
        { workspace = "8", monitor = secondary2_monitor },
    },
})
