-- =============================================
-- monitors.lua
-- Hyprland Lua Monitor Configuration (Hyprland 0.55.2+)
-- Connector names are used for the side monitors because both HP panels report
-- the same EDID description, making desc: rules ambiguous.
--   • SUPER + G          → Gaming mode (only primary at 1920x1080@60, others disabled)
--   • SUPER + SHIFT + G  → Full config reload (hyprctl reload) + wallpapers restored
--     (this is the reliable way to bring secondaries back with correct resolution/position)
-- =============================================

-- ========================
-- 1. MONITOR IDENTIFIERS
-- ========================
local primary_monitor    = "DP-1"
local secondary1_monitor = "HDMI-A-1"
local secondary2_monitor = "DP-2"

-- Generic socket names for mpvpaper (no brand names)
local primary_socket   = "primary"
local secondary1_socket = "sec1"
local secondary2_socket = "sec2"

-- ========================
-- 2. RESOLUTIONS / MODES / POSITIONS / SCALES
--    Side monitor modes match the connectors detected in Hyprland's log.
-- ========================
local primary_work_mode   = "2560x1440@144"
local primary_gaming_mode = "1920x1080@60"
local primary_position    = "0x0"

local secondary1_mode     = "1024x768@60.00Hz"
local secondary1_position = "-1024x336"

local secondary2_mode     = "1280x1024@75.03Hz"
local secondary2_position = "2560x208"

local default_scale       = 1

-- ========================
-- 3. HELPER FUNCTIONS
-- ========================

-- Kills mpvpaper + mpvpaper-stop on every monitor
local function killWallpapers()
    hl.exec_cmd("pkill -f mpvpaper")
    hl.exec_cmd("pkill -f mpvpaper-stop")
end

-- Starts mpvpaper + mpvpaper-stop on one monitor (your exact original command)
local function start_mpvpaper(monitor_desc, socket_name)
    local video_cmd = string.format(
        [[sh -c 'VIDEO=$(find "/home/aaron/Videos/wallpapers" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" -o -iname "*.gif" \) | shuf -n 1); [ -n "$VIDEO" ] && mpvpaper -o "--loop --no-audio --hwdec=auto --input-ipc-server=/tmp/mpvsocket-%s --panscan=1.0" "%s" "$VIDEO"']],
        socket_name, monitor_desc
    )
   -- hl.exec_cmd(video_cmd)
    hl.exec_cmd(string.format("sleep 5 && ~/gits/mpvpaper-stop/build/mpvpaper-stop -p /tmp/mpvsocket-%s --fork", socket_name))
end

-- Starts wallpapers on ALL three monitors
local function startWallpapers()
    start_mpvpaper(secondary1_monitor, secondary1_socket)
    start_mpvpaper(primary_monitor,   primary_socket)
    start_mpvpaper(secondary2_monitor, secondary2_socket)
end

-- ========================
-- 4. MONITOR CONFIG FUNCTIONS
-- ========================

-- Normal work layout (exactly your original config)
local function applyNormalConfig()
    -- Primary BenQ (work mode)
    hl.monitor({
        output   = primary_monitor,
        mode     = primary_work_mode,
        position = primary_position,
        scale    = default_scale,
    })

    -- Left HP
    hl.monitor({
        output   = secondary1_monitor,
        mode     = secondary1_mode,
        position = secondary1_position,
        scale    = default_scale,
    })

    -- Right HP
    hl.monitor({
        output   = secondary2_monitor,
        mode     = secondary2_mode,
        position = secondary2_position,
        scale    = default_scale,
    })
end

-- Gaming mode: only primary active at 1920x1080@60, others disabled
local function applyGamingConfig()
    hl.monitor({
        output   = primary_monitor,
        mode     = primary_gaming_mode,
        position = "0x0",
        scale    = default_scale,
    })

    hl.monitor({ output = secondary1_monitor, disabled = true })
    hl.monitor({ output = secondary2_monitor, disabled = true })
end

-- ========================
-- 5. MODE SWITCHING
-- ========================

-- SUPER + G → Gaming mode
local function enterGamingMode()
    killWallpapers()
    applyGamingConfig()
end

-- SUPER + SHIFT + G → Full config reload (your requested method)
-- This reliably restores ALL monitors with their exact original resolutions + positions
local function restoreNormalMode()
    killWallpapers()
    hl.exec_cmd("hyprctl reload")     -- re-executes the entire monitors.lua (including applyNormalConfig)
    hl.exec_cmd("sleep 1.5")          -- give reload time to finish and monitors to settle
    startWallpapers()                 -- wallpapers do NOT auto-restart on reload, so we launch them manually
end

-- ========================
-- 6. INITIAL SETUP (runs when config loads / on Hyprland start)
-- ========================
applyNormalConfig()

-- ========================
-- 7. WORKSPACE RULES (unchanged)
-- ========================
-- hl.workspace_rule({ workspace = "1", monitor = secondary1_monitor, default = true })
-- hl.workspace_rule({ workspace = "6", monitor = secondary1_monitor })

-- hl.workspace_rule({ workspace = "2", monitor = primary_monitor, default = true })
-- hl.workspace_rule({ workspace = "7", monitor = primary_monitor })

-- hl.workspace_rule({ workspace = "3", monitor = secondary2_monitor, default = true })
-- hl.workspace_rule({ workspace = "8", monitor = secondary2_monitor })

-- ========================
-- 8. STARTUP: mpvpaper on Hyprland start
-- ========================
hl.on("hyprland.start", function()
    startWallpapers()
end)

-- ========================
-- 9. KEYBINDS
-- ========================
local mainMod = "SUPER"

hl.bind(mainMod .. " + G", enterGamingMode)           -- → Gaming mode
hl.bind(mainMod .. " + SHIFT + G", restoreNormalMode) -- → Full config reload + wallpapers

-- =============================================
-- END OF FILE – save as ~/.config/hypr/monitors.lua
-- =============================================
