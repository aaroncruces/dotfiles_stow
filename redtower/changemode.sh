#! /bin/bash
echo "cvt..."
CVT_RES=$(cvt $1 $2 $3 | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
#CVT_RES=$(cvt 640 241 120 | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
MODE_NAME=$(echo $CVT_RES | grep -Eo '\".+\"')
echo "xrandr --newmode"
xrandr --newmode $CVT_RES 
echo "xrandr --addmode"
xrandr --addmode $4 $MODE_NAME
echo "xrandr --output"
xrandr --output $4 --mode $MODE_NAME --verbose