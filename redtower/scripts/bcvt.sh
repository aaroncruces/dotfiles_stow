#! /bin/bash

# parameter 1 horizontal resolution. default 640
HORIZONTAL_RESOLUTION=${1:-640}
# parameter 2 vertical resolution. default 480
VERTICAL_RESOLUTION=${2:-480}
# parameter 3: refresh rate. default 60
REFRESH_RATE=${3:-60}
# parameter 4: interlaced. default no
INTERLACED=${4:-n}
# parameter 5: left margin. default 0
LEFT_MARGIN=${5:-0}
# parameter 6: right margin. default 0
RIGHT_MARGIN=${6:-0}
# parameter 7: top margin. default 0
TOP_MARGIN=${7:-0}
# parameter 8: bottom margin. default 0 
BOTTOM_MARGIN=${8:-0}
# parameter 9: horizontal scale. default 1
SCALEHORIZONTAL=${9:-1}
# parameter 10: vertical scale. default 1
SCALEVERTICAL=${10:-1}

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

exit 0






