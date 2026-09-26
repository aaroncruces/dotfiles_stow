-- Session environment exported by Hyprland.
--
-- Keep compositor and toolkit variables here so spawned applications inherit
-- the same locale and cursor settings.

-- Force English UI messages even when keyboard layouts are Spanish/US mixed.
hl.env("LC_MESSAGES", "en_US.UTF-8")

-- Cursor sizing for XCursor-aware apps and Hyprcursor-aware components.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Cursor theme used by Hyprland and repeated in autorun.lua via hyprctl.
hl.env("HYPRCURSOR_THEME", "BreezeX-RosePineDawn-Linux")

-- Optional GTK backend override. Leave disabled unless a GTK app needs x11.
-- hl.env("GDK_BACKEND", "x11")
