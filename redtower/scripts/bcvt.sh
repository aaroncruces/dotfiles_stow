#! /bin/bash

# parameters 1 screen. default VGA-1
SCREEN=${1:-VGA-1}
# parameter 1 horizontal resolution. default 640
HORIZONTAL_VIEWPORT=${2:-640}
# parameter 2 vertical resolution. default 480
VERTICAL_VIEWPORT=${3:-480}
# parameter 3  : interlaced. default no
INTERLACED=${3:-n}
# parameter 4: left margin. default 0
LEFT_MARGIN=${4:-30}
# parameter 5: right margin. default 0
RIGHT_MARGIN=${5:-10}
# parameter 6: top margin. default 0
TOP_MARGIN=${6:-0}
# parameter 7: bottom margin. default 0 
BOTTOM_MARGIN=${7:-0}
# parameter 8: horizontal scale. default 1
SCALEHORIZONTAL=${8:-1}
# parameter 9: vertical scale. default 1
SCALEVERTICAL=${9:-1}
# parameter 10: refresh rate. default 60
REFRESH_RATE=${10:-60}

# calculate the resolution including the margins
HORIZONTAL_RESOLUTION=$(($HORIZONTAL_VIEWPORT + $LEFT_MARGIN + $RIGHT_MARGIN))
VERTICAL_RESOLUTION=$(($VERTICAL_VIEWPORT + $TOP_MARGIN + $BOTTOM_MARGIN))  


# --- calculate the cvt resolution ---
echo "--- calculate the cvt resolution ---"
CVT_RES=$(cvt $HORIZONTAL_RESOLUTION $VERTICAL_RESOLUTION $REFRESH_RATE | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
echo "CVT_RES=\$(cvt $HORIZONTAL_RESOLUTION $VERTICAL_RESOLUTION $REFRESH_RATE | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')"
echo "CVT_RES=$CVT_RES"
# --- extract the mode name ---
echo "--- extract the mode name ---"

read MODE_NAME PIXEL_CLOCK H_ACTIVE H_FRONT_PORCH_START H_SYNC_START H_TOTAL \
     V_ACTIVE V_FRONT_PORCH_START V_SYNC_START V_TOTAL HSYNC_POLARITY VSYNC_POLARITY \
     <<< $(echo "$CVT_RES" | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}')


# Print variables to verify
echo "MODE_NAME: $MODE_NAME"
echo "PIXEL_CLOCK: $PIXEL_CLOCK"
echo "H_ACTIVE: $H_ACTIVE"
echo "H_FRONT_PORCH_START: $H_FRONT_PORCH_START"
echo "H_SYNC_START: $H_SYNC_START"
echo "H_TOTAL: $H_TOTAL"
echo "V_ACTIVE: $V_ACTIVE"
echo "V_FRONT_PORCH_START: $V_FRONT_PORCH_START"
echo "V_SYNC_START: $V_SYNC_START"
echo "V_TOTAL: $V_TOTAL"
echo "HSYNC_POLARITY: $HSYNC_POLARITY"
echo "VSYNC_POLARITY: $VSYNC_POLARITY"

exit 0

# add the new mode to xrandr
echo "xrandr --newmode $CVT_RES"
xrandr --newmode $CVT_RES 
echo "xrandr --addmode $SCREEN $MODE_NAME"
xrandr --addmode $SCREEN $MODE_NAME
echo "xrandr --output $SCREEN --mode $MODE_NAME --verbose  --scale $SCALE"
SCALE=$SCALEHORIZONTAL"x"$SCALEVERTICAL
xrandr --output $SCREEN --mode $MODE_NAME --verbose  --scale $SCALE

exit 0






