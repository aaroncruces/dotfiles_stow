#! /bin/bash

HORIZONTAL=${1:-640}
VERTICAL=${2:-240}
REFRESH=${3:-60}
SCREEN=${4:-VGA-1}
SCALEHORIZONTAL=${5:-1}
SCALEVERTICAL=${6:-2}

echo "cvt..."
CVT_RES=$(cvt $HORIZONTAL $VERTICAL $REFRESH | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
#CVT_RES=$(cvt 640 241 120 | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
MODE_NAME=$(echo $CVT_RES | grep -Eo '\".+\"')
echo "xrandr --newmode"
xrandr --newmode $CVT_RES 
echo "xrandr --addmode"
xrandr --addmode $SCREEN $MODE_NAME
echo "xrandr --output"
SCALE=$SCALEHORIZONTAL"x"$SCALEVERTICAL
xrandr --output $SCREEN --mode $MODE_NAME --verbose  --scale $SCALE