#!/usr/bin/env bash

   # Add a small delay to ensure display server is ready
   sleep 2

   # Log for debugging
   echo "Running select-monitor-config.sh on $(hostname) at $(date)" >> ~/.config/hypr/monitor-config.log

   HOSTNAME=$(hostname)

   if [ "$HOSTNAME" = "whitetower" ]; then
       hyprctl keyword monitor "desc:BNQ BenQ EX2780Q 32M01997019,2560x1440@144,0x0,1"
       hyprctl keyword monitor "desc:Lenovo Group Limited L1951p Wide 6V6A4410,1440x900@60,2560x420,1"
       hyprctl keyword monitor "desc:Hewlett Packard HP L1950 CNK8260PLG,1280x1024@75,-1280x350,1"
       echo "Applied whitetower monitor config" >> ~/.config/hypr/monitor-config.log
   elif [ "$HOSTNAME" = "nixdev" ]; then
       hyprctl keyword monitor "eDP-1,1920x1080@144,0x0,1"
       hyprctl keyword monitor "desc:Samsung Electric Company LS27C33xG H9TWB00353,1920x1080@100,1920x70,1"
       hyprctl keyword monitor "desc:ASUSTek COMPUTER INC PA248QV N1LMQS146369,1920x1200@75,3840x250,1"
       echo "Applied nixdev monitor config" >> ~/.config/hypr/monitor-config.log
   else
       hyprctl keyword monitor "preferred,auto,1"
       echo "Applied fallback monitor config" >> ~/.config/hypr/monitor-config.log
   fi
