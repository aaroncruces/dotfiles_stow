-- =============================================
-- monitors.lua
-- Hyprland Lua Monitor Configuration (Hyprland >= 0.55)
-- Full file containing everything related to your three monitors:
--   • Variable definitions (monitors, resolutions, positions, scales)
--   • Normal work layout (exactly your current setup)
--   • Gaming mode toggle (only BenQ at 1920x1080@60, others disabled)
--   • mpvpaper + mpvpaper-stop management
--   • Workspace rules (unchanged)
--   • Keybinds: SUPER + G → Gaming mode
--               SUPER + SHIFT + G → Normal mode
-- =============================================

-- ========================
-- 1. MONITOR IDENTIFIERS (exact strings from hyprctl monitors)
-- ========================
-- BenQ is your primary/gaming monitor
local primary_monitor   = "desc:BNQ BenQ EX2780Q 32M01997019"

-- Lenovo (Secondary 1) - EXACT string with the three spaces after "Wide" as you requested
local secondary1_monitor = "desc:Lenovo Group Limited L1951p Wide   6V6A4410"

-- HP (Secondary 2)
local secondary2_monitor = "desc:Hewlett Packard HP L1950 CNK8260PLG"

-- ========================
-- 2. RESOLUTIONS / MODES / POSITIONS / SCALES
--    (all values taken directly from your current configuration)
-- ========================
-- Primary (BenQ) modes
local primary_work_mode   = "2560x1440@144"
local primary_gaming_mode = "1920x1080@60"
local primary_position    = "0x0"

-- Secondary 1 - Lenovo
local secondary1_mode     = "1440x900@60.00Hz"
local secondary1_position = "-1440x350"

-- Secondary 2 - HP
local secondary2_mode     = "1280x1024@75.00Hz"
local secondary2_position = "2560x150"

-- Scale (same for all monitors)
local default_scale = 1

-- ========================
-- 3. HELPER FUNCTIONS (documented)
-- ========================

-- Kills mpvpaper and mpvpaper-stop on all monitors
-- Called when entering gaming mode
local function killWallpapers()
    hl.exec_cmd("pkill -f mpvpaper")      -- kills the wallpaper players
    hl.exec_cmd("pkill -f mpvpaper-stop") -- kills the stop helper processes
end

-- Launches mpvpaper with a random video + the mpvpaper-stop helper
-- on a specific monitor. Uses your exact original command.
local function start_mpvpaper(monitor_desc, socket_name)
    -- Random video selection + mpvpaper launch (exactly your original sh -c)
    local video_cmd = string.format(
        [[sh -c 'VIDEO=$(find "/home/aaron/Videos/wallpapers" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" -o -iname "*.gif" \) | shuf -n 1); [ -n "$VIDEO" ] && mpvpaper -o "--loop --no-audio --hwdec=auto --input-ipc-server=/tmp/mpvsocket-%s --panscan=1.0" "%s" "$VIDEO"']],
        socket_name, monitor_desc
    )
    hl.exec_cmd(video_cmd)

    -- Start the stop helper after a short delay (exactly your original logic)
    hl.exec_cmd(string.format("sleep 5 && ~/gits/mpvpaper-stop/build/mpvpaper-stop -p /tmp/mpvsocket-%s --fork", socket_name))
end

-- Starts wallpapers on ALL three monitors (re-usable)
local function startWallpapers()
    start_mpvpaper(secondary1_monitor, "lenovo")
    start_mpvpaper(primary_monitor,   "benq")
    start_mpvpaper(secondary2_monitor, "hp")
end

-- Applies the normal multi-monitor work layout (your original config)
local function applyNormalConfig()
    -- Lenovo (Secondary 1)
    hl.monitor({
        output   = secondary1_monitor,
        mode     = secondary1_mode,
        position = secondary1_position,
        scale    = default_scale,
    })

    -- BenQ (Primary - work resolution)
    hl.monitor({
        output   = primary_monitor,
        mode     = primary_work_mode,
        position = primary_position,
        scale    = default_scale,
    })

    -- HP (Secondary 2)
    hl.monitor({
        output   = secondary2_monitor,
        mode     = secondary2_mode,
        position = secondary2_position,
        scale    = default_scale,
    })
end

-- Applies gaming mode: only BenQ active at 1920x1080@60, others disabled
local function applyGamingConfig()
    -- BenQ (gaming resolution, position 0x0)
    hl.monitor({
        output   = primary_monitor,
        mode     = primary_gaming_mode,
        position = "0x0",
        scale    = default_scale,
    })

    -- Disable Lenovo
    hl.monitor({
        output   = secondary1_monitor,
        disabled = true,
    })

    -- Disable HP
    hl.monitor({
        output   = secondary2_monitor,
        disabled = true,
    })
end

-- ========================
-- 4. MODE SWITCHING FUNCTIONS (the core of your request)
-- ========================

-- Called by SUPER + G
-- → Switches to single-monitor gaming setup and kills wallpapers
local function enterGamingMode()
    killWallpapers()
    applyGamingConfig()
    -- You can add extra gaming tweaks here in the future (e.g. disable animations, change refresh rate, etc.)
end

-- Called by SUPER + SHIFT + G
-- → Restores full multi-monitor layout and restarts mpvpaper
local function restoreNormalMode()
    applyNormalConfig()
    killWallpapers()           -- clean up any leftovers first
    startWallpapers()          -- relaunch wallpapers on all three monitors
end

-- ========================
-- 5. INITIAL SETUP (runs when the config is loaded)
-- ========================

-- Set the normal monitor configuration immediately
applyNormalConfig()

-- ========================
-- 6. WORKSPACE RULES (exactly as you had them)
-- ========================

-- Lenovo workspaces
hl.workspace_rule({
    workspace = "1",
    monitor   = secondary1_monitor,
    default   = true,
})
hl.workspace_rule({
    workspace = "6",
    monitor   = secondary1_monitor,
})

-- BenQ (primary) workspaces
hl.workspace_rule({
    workspace = "2",
    monitor   = primary_monitor,
    default   = true,
})
hl.workspace_rule({
    workspace = "7",
    monitor   = primary_monitor,
})

-- HP workspaces
hl.workspace_rule({
    workspace = "3",
    monitor   = secondary2_monitor,
    default   = true,
})
hl.workspace_rule({
    workspace = "8",
    monitor   = secondary2_monitor,
})

-- ========================
-- 7. STARTUP: mpvpaper on every Hyprland start
-- ========================
hl.on("hyprland.start", function()
    startWallpapers()
end)

-- ========================
-- 8. KEYBINDS (mod + g and mod + shift + g)
-- ========================
local mainMod = "SUPER"   -- Change this if your main modifier is different (e.g. "ALT")

-- mod + g          → Gaming mode
hl.bind(mainMod .. " + G", enterGamingMode)

-- mod + shift + g  → Back to normal work layout + wallpapers
hl.bind(mainMod .. " + SHIFT + G", restoreNormalMode)

-- =============================================
-- END OF FILE
-- =============================================