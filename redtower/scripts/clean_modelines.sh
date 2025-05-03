#! /bin/bash

for mode in $(xrandr | grep -E '_ON_|_INTERLACED' | awk '{print $1}'); do          
    echo "Removing mode: $mode"
    xrandr --delmode {HDMI-0,VGA-1,DP-3} "$mode" 2>/dev/null
    xrandr --rmmode "$mode" 2>/dev/null
done

for mode in $(xrandr | grep -E '240p' | awk '{print $1}'); do          
    echo "Removing mode: $mode"
    xrandr --delmode {HDMI-0,VGA-1,DP-3} "$mode" 2>/dev/null

    xrandr --rmmode "$mode" 2>/dev/null
done

for mode in $(xrandr | grep -E '480i' | awk '{print $1}'); do          
    echo "Removing mode: $mode"
    xrandr --delmode {HDMI-0,VGA-1,DP-3} "$mode" 2>/dev/null

    xrandr --rmmode "$mode" 2>/dev/null
done