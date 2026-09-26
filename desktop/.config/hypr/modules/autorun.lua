-- Hyprland startup commands.
--
-- This event runs once when the compositor starts. Put long-running services
-- here only when they should be tied to this Hyprland session.
hl.on("hyprland.start", function()
    -- PolicyKit authentication agent for GUI privilege prompts.
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Cursor theme and size are set here so they apply after Hyprland starts.
    hl.exec_cmd("hyprctl setcursor BreezeX-RosePineDawn-Linux 24")

    -- Main status bar for the session.
    hl.exec_cmd("waybar")
end)
