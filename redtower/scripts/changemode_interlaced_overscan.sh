#! /bin/bash

HORIZONTAL=${1:-640}
VERTICAL=${2:-480}
REFRESH=${3:-30}
SCREEN=${4:-VGA-1}
SCALEHORIZONTAL=${5:-1}
SCALEVERTICAL=${6:-1}
OVERSCANX=${7:-45}
OVERSCANY=${8:-10}
TRANSLATIONX=${9:-45}
TRANSLATIONY=${10:-19}

NEWRESX=$((HORIZONTAL-OVERSCANX))
NEWRESY=$((VERTICAL-OVERSCANY))
PANRES=$NEWRESX"x"$NEWRESY
SCALETRX=$(echo "scale=6; $HORIZONTAL / $NEWRESX" | bc)
SCALETRY=$(echo "scale=6; $VERTICAL / $NEWRESY" | bc)
SCALE=$SCALEHORIZONTAL"x"$SCALEVERTICAL

echo "cvt..."
CVT_RES=$(cvt -i $HORIZONTAL $VERTICAL $REFRESH | grep -E 'Modeline (.*)'| sed -E 's/Modeline//g')
MODE_NAME=$(echo $CVT_RES | grep -Eo '\".+\"')
echo "xrandr --newmode"
xrandr --newmode $CVT_RES 
echo "xrandr --addmode"
xrandr --addmode $SCREEN $MODE_NAME
echo "xrandr --output"
xrandr --output $SCREEN --mode $MODE_NAME --verbose --scale $SCALE --fb $PANRES --panning $PANRES  --transform $SCALETRX,0,-$TRANSLATIONX,0,$SCALETRY,-$TRANSLATIONY,0,0,1
