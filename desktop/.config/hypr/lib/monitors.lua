-- Shared monitor layout helper for Hyprland Lua configs.
--
-- Host-specific monitor modules pass plain data into M.setup(). This file owns
-- the repeated behavior: applying the normal layout, switching into a
-- single-monitor gaming layout, restarting wallpaper processes, and registering
-- the mode-switch keybindings.

local M = {}

-- Stop any wallpaper process created by this config before monitor topology
-- changes. mpvpaper can otherwise keep old outputs or IPC sockets alive.
local function kill_wallpapers()
    hl.exec_cmd("pkill -f mpvpaper")
    hl.exec_cmd("pkill -f mpvpaper-stop")
end

-- Start one mpvpaper instance and its companion mpvpaper-stop controller.
--
-- monitor_desc can be a Hyprland output name such as DP-1 or a desc: selector.
-- socket_name is intentionally short because it becomes part of /tmp/mpvsocket-*.
-- start_video=false keeps the stop controller behavior while skipping mpvpaper;
-- whitetower currently uses that for a quieter startup.
local function start_mpvpaper(monitor_desc, socket_name, start_video)
    -- Pick a random local video wallpaper each time Hyprland starts or the
    -- normal layout is restored.
    local video_cmd = string.format(
        [[sh -c 'VIDEO=$(find "/home/aaron/Videos/wallpapers" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" -o -iname "*.gif" \) | shuf -n 1); [ -n "$VIDEO" ] && mpvpaper -o "--loop --no-audio --hwdec=auto --input-ipc-server=/tmp/mpvsocket-%s --panscan=1.0" "%s" "$VIDEO"']],
        socket_name,
        monitor_desc
    )

    if start_video ~= false then
        hl.exec_cmd(video_cmd)
    end

    hl.exec_cmd(string.format("sleep 5 && ~/gits/mpvpaper-stop/build/mpvpaper-stop -p /tmp/mpvsocket-%s --fork", socket_name))
end

-- Apply one monitor definition from the host config. Per-monitor scale wins;
-- otherwise the shared default scale is used.
local function apply_monitor(definition, scale)
    hl.monitor({
        output = definition.output,
        mode = definition.mode,
        position = definition.position,
        scale = definition.scale or scale,
    })
end

-- Register workspace pinning rules when a host provides them. Hosts without
-- explicit rules can omit config.workspace_rules entirely.
local function apply_workspace_rules(rules)
    for _, rule in ipairs(rules or {}) do
        hl.workspace_rule(rule)
    end
end

-- Configure one three-monitor host.
--
-- Expected config shape:
--   {
--     default_scale = 1,          -- optional, defaults to 1
--     main_mod = "SUPER",         -- optional, defaults to SUPER
--     gaming_position = "0x0",    -- optional primary position in gaming mode
--     start_mpvpaper = true,      -- optional, false skips mpvpaper launch
--     monitors = {
--       primary = { output, mode, gaming_mode, position, socket, scale? },
--       secondary1 = { output, mode, position, socket, scale? },
--       secondary2 = { output, mode, position, socket, scale? },
--     },
--     workspace_rules = { ... },  -- optional hl.workspace_rule tables
--   }
function M.setup(config)
    local monitors = config.monitors
    local primary = monitors.primary
    local secondary1 = monitors.secondary1
    local secondary2 = monitors.secondary2
    local default_scale = config.default_scale or 1
    local main_mod = config.main_mod or "SUPER"

    -- Start wallpapers in left-to-right visual order where possible, with the
    -- primary in the middle for the desktop/nixdev layout.
    local function start_wallpapers()
        start_mpvpaper(secondary1.output, secondary1.socket, config.start_mpvpaper)
        start_mpvpaper(primary.output, primary.socket, config.start_mpvpaper)
        start_mpvpaper(secondary2.output, secondary2.socket, config.start_mpvpaper)
    end

    -- Normal work layout: all three configured monitors are active.
    local function apply_normal_config()
        apply_monitor(primary, default_scale)
        apply_monitor(secondary1, default_scale)
        apply_monitor(secondary2, default_scale)
    end

    -- Gaming layout: the primary monitor moves to origin and the side monitors
    -- are disabled so fullscreen games see a simple single-output setup.
    local function apply_gaming_config()
        hl.monitor({
            output = primary.output,
            mode = primary.gaming_mode,
            position = config.gaming_position or "0x0",
            scale = primary.scale or default_scale,
        })

        hl.monitor({ output = secondary1.output, disabled = true })
        hl.monitor({ output = secondary2.output, disabled = true })
    end

    -- SUPER+G path: stop wallpapers first so disabled outputs are not held open.
    local function enter_gaming_mode()
        kill_wallpapers()
        apply_gaming_config()
    end

    -- SUPER+SHIFT+G path: a full Hyprland reload is the most reliable way to
    -- restore side monitors with exact modes, positions, and workspace rules.
    local function restore_normal_mode()
        kill_wallpapers()
        hl.exec_cmd("hyprctl reload")
        -- Give Hyprland a moment to settle outputs before wallpaper processes
        -- bind to monitor names and IPC sockets again.
        hl.exec_cmd("sleep 1.5")
        start_wallpapers()
    end

    -- Apply the normal layout immediately when this module is loaded.
    apply_normal_config()
    apply_workspace_rules(config.workspace_rules)

    -- Wallpapers are started on compositor startup and manually restarted by
    -- restore_normal_mode() after a reload.
    hl.on("hyprland.start", function()
        start_wallpapers()
    end)

    -- Shared mode-switch bindings for every host using this helper.
    hl.bind(main_mod .. " + G", enter_gaming_mode)
    hl.bind(main_mod .. " + SHIFT + G", restore_normal_mode)
end

return M
