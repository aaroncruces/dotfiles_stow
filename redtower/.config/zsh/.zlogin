#!/bin/bash

# if not using sddm
#if [ $TTY = "/dev/tty1" ];then
# # export WLR_NO_HARDWARE_CURSORS=1
#  exec Hyprland
#fi
#
#if [ $TTY = "/dev/tty2" ];then
#  #exec startx
#fi

# IF I WANT XORG
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
 exec startx
fi
