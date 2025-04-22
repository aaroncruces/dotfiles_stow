#! /bin/bash

# parameters 1 screen. default VGA-1
SCREEN=${1:-VGA-1}
# parameter 1 horizontal resolution. default 640
HORIZONTAL_RESOLUTION=${2:-640}
# parameter 2 vertical resolution. default 480
VERTICAL_RESOLUTION=${3:-480}
# parameter 3: refresh rate. default 60
REFRESH_RATE=${4:-30}
# parameter 4: interlaced. default no
INTERLACED=${5:-n}
# parameter 5: left margin. default 0
LEFT_MARGIN=${6:-0}
# parameter 6: right margin. default 0
RIGHT_MARGIN=${7:-0}
# parameter 7: top margin. default 0
TOP_MARGIN=${8:-0}
# parameter 8: bottom margin. default 0 
BOTTOM_MARGIN=${9:-0}
# parameter 9: horizontal scale. default 1
SCALEHORIZONTAL=${10:-1}
# parameter 10: vertical scale. default 1
SCALEVERTICAL=${11:-1}

# calculate the cvt resolution
echo "calculate the cvt resolution"
CVT_RES=$(cvt $HORIZONTAL_RESOLUTION $VERTICAL_RESOLUTION $REFRESH_RATE | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
echo "CVT_RES=\$(cvt $HORIZONTAL_RESOLUTION $VERTICAL_RESOLUTION $REFRESH_RATE | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')"
echo "CVT_RES=$CVT_RES"
# extract the mode name
echo "extract the mode name"
MODE_NAME=$(echo $CVT_RES | grep -Eo '\".+\"')
echo "MODE_NAME=\$(echo $CVT_RES | grep -Eo '\".+\"')"
echo "MODE_NAME=$MODE_NAME"

# add the new mode to xrandr
echo "xrandr --newmode $CVT_RES"
xrandr --newmode $CVT_RES 
echo "xrandr --addmode $SCREEN $MODE_NAME"
xrandr --addmode $SCREEN $MODE_NAME
echo "xrandr --output $SCREEN --mode $MODE_NAME --verbose  --scale $SCALE"
SCALE=$SCALEHORIZONTAL"x"$SCALEVERTICAL
xrandr --output $SCREEN --mode $MODE_NAME --verbose  --scale $SCALE

exit 0






