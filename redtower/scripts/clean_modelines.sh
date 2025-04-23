#! /bin/bash

for mode in $(xrandr | grep -E '_ON_|_INTERLACED' | awk '{print $1}'); do          
    echo "Removing mode: $mode"
    xrandr --delmode VGA-1 "$mode" 2>/dev/null
    xrandr --rmmode "$mode" 2>/dev/null
done

for mode in $(xrandr | grep -E '240' | awk '{print $1}'); do          
    echo "Removing mode: $mode"
    xrandr --delmode VGA-1 "$mode" 2>/dev/null
    xrandr --rmmode "$mode" 2>/dev/null
done

for mode in $(xrandr | grep -E '480' | awk '{print $1}'); do          
    echo "Removing mode: $mode"
    xrandr --delmode VGA-1 "$mode" 2>/dev/null
    xrandr --rmmode "$mode" 2>/dev/null
done