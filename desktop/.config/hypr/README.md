# Hyprland Lua Config

This directory is the Lua version of the Hyprland configuration.

`hyprland.lua` is intentionally tiny: it requires `modules/init.lua`, and that
loader imports every other Lua file in `modules/`.

## Files

- `modules/appearance.lua` defines curves, animations, gaps, borders, blur,
  shadows, and miscellaneous visual settings.
- `modules/autorun.lua` starts session services and UI pieces when Hyprland
  emits `hyprland.start`.
- `modules/enviroment.lua` exports locale and cursor environment variables to
  applications launched from the session.
- `modules/input.lua` configures keyboard layouts, pointer behavior, and
  global fallback input settings.
- `modules/keybindings.lua` owns workspace movement, focus movement, mouse
  window manipulation, and media keys.
- `modules/programs.lua` owns launcher bindings for terminal, browser, menu,
  screenshots, Steam, and Remmina.
- `lib/monitors.lua` is the shared monitor helper used by host-specific
  `modules/monitors.lua` files.

## Monitor Helper Contract

Host-specific `monitors.lua` files pass plain data into `lib.monitors.setup()`.
The shared helper applies the normal layout, registers workspace rules, starts
wallpapers on compositor startup, and binds:

- `SUPER + G` for single-monitor gaming mode.
- `SUPER + SHIFT + G` for a full reload back into the normal layout.

Keep host-specific EDID strings, connector names, modes, positions, and
workspace rules in the host file. Keep repeated behavior in `lib/monitors.lua`.
