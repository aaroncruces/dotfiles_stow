-- Monitor configuration for Hyprland (Lua)

-- Monitor 1 - Lenovo
hl.monitor({
    output = "desc:Lenovo Group Limited L1951p Wide   6V6A4410",
    mode = "1440x900@60.00Hz",
    position = "-1440x350",
    scale = 1,
})

hl.workspace_rule({
    workspace = "1",
    monitor = "desc:Lenovo Group Limited L1951p Wide   6V6A4410",
    default = true,
})

hl.workspace_rule({
    workspace = "6",
    monitor = "desc:Lenovo Group Limited L1951p Wide   6V6A4410",
})

-- Monitor 2 - BenQ
hl.monitor({
    output = "desc:BNQ BenQ EX2780Q 32M01997019",
    mode = "2560x1440@144",
    position = "0x0",
    scale = 1,
})

hl.workspace_rule({
    workspace = "2",
    monitor = "desc:BNQ BenQ EX2780Q 32M01997019",
    default = true,
})

hl.workspace_rule({
    workspace = "7",
    monitor = "desc:BNQ BenQ EX2780Q 32M01997019",
})

-- Monitor 3 - HP
hl.monitor({
    output = "desc:Hewlett Packard HP L1950 CNK8260PLG",
    mode = "1280x1024@75.00Hz",
    position = "2560x150",
    scale = 1,
})

hl.workspace_rule({
    workspace = "3",
    monitor = "desc:Hewlett Packard HP L1950 CNK8260PLG",
    default = true,
})

hl.workspace_rule({
    workspace = "8",
    monitor = "desc:Hewlett Packard HP L1950 CNK8260PLG",
})

-- Startup: launch mpvpaper on each monitor with random video
hl.on("hyprland.start", function()
    -- Lenovo
    hl.exec_cmd([[sh -c 'VIDEO=$(find "/home/aaron/Videos/wallpapers" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" -o -iname "*.gif" \) | shuf -n 1); [ -n "$VIDEO" ] && mpvpaper -o "--loop --no-audio --hwdec=auto --input-ipc-server=/tmp/mpvsocket-lenovo --panscan=1.0" "desc:Lenovo Group Limited L1951p Wide   6V6A4410" "$VIDEO"']])
    hl.exec_cmd("sleep 5 && ~/gits/mpvpaper-stop/build/mpvpaper-stop -p /tmp/mpvsocket-lenovo --fork")

    -- BenQ
    hl.exec_cmd([[sh -c 'VIDEO=$(find "/home/aaron/Videos/wallpapers" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" -o -iname "*.gif" \) | shuf -n 1); [ -n "$VIDEO" ] && mpvpaper -o "--loop --no-audio --hwdec=auto --input-ipc-server=/tmp/mpvsocket-benq --panscan=1.0" "desc:BNQ BenQ EX2780Q 32M01997019" "$VIDEO"']])
    hl.exec_cmd("sleep 5 && ~/gits/mpvpaper-stop/build/mpvpaper-stop -p /tmp/mpvsocket-benq --fork")

    -- HP
    hl.exec_cmd([[sh -c 'VIDEO=$(find "/home/aaron/Videos/wallpapers" -type f \( -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" -o -iname "*.gif" \) | shuf -n 1); [ -n "$VIDEO" ] && mpvpaper -o "--loop --no-audio --hwdec=auto --input-ipc-server=/tmp/mpvsocket-hp --panscan=1.0" "desc:Hewlett Packard HP L1950 CNK8260PLG" "$VIDEO"']])
    hl.exec_cmd("sleep 5 && ~/gits/mpvpaper-stop/build/mpvpaper-stop -p /tmp/mpvsocket-hp --fork")
end)


