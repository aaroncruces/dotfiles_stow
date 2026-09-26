-- whitetower monitor layout.
--
-- This host keeps machine-specific monitor data here and delegates common
-- behavior to lib.monitors. Unlike nixdev, this machine disables the mpvpaper
-- launch step while still sharing the same monitor mode-switching logic.
local monitors = require("lib.monitors")

-- Stable Hyprland monitor selectors from EDID descriptions. If two panels ever
-- report identical descriptions, switch those entries to connector names such
-- as DP-1 or HDMI-A-1 to remove ambiguity.
local primary_monitor = "desc:BNQ BenQ EX2780Q 32M01997019"
local secondary1_monitor = "desc:Lenovo Group Limited L1951p Wide   6V6A4410"
local secondary2_monitor = "desc:Hewlett Packard HP L1950 CNK8260PLG"

monitors.setup({
    -- Keep video wallpaper startup disabled on this host. The shared helper
    -- still registers mode-switch bindings and monitor application behavior.
    start_mpvpaper = false,
    -- Physical layout: Lenovo on the left, BenQ primary at origin, HP on the
    -- right. The primary gaming mode simplifies fullscreen game behavior.
    monitors = {
        primary = {
            output = primary_monitor,
            mode = "2560x1440@144",
            gaming_mode = "1920x1080@60",
            position = "0x0",
            socket = "primary",
        },
        secondary1 = {
            output = secondary1_monitor,
            mode = "1440x900@59.89Hz",
            position = "-1440x336",
            socket = "sec1",
        },
        secondary2 = {
            output = secondary2_monitor,
            mode = "1280x1024@75.03Hz",
            position = "2560x208",
            socket = "sec2",
        },
    },
})
