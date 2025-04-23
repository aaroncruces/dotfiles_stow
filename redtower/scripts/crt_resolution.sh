#! /bin/bash

# Default values
SCREEN="VGA-1"
HORIZONTAL_VIEWPORT=640
VERTICAL_VIEWPORT=240
INTERLACED="n"
LEFT_MARGIN=12
RIGHT_MARGIN=28
TOP_MARGIN=8
BOTTOM_MARGIN=8
SCALEHORIZONTAL=1
SCALEVERTICAL=1
REFRESH_RATE=60
RUN_MODE="y"
CUSTOM_MODE_NAME=""

# Parse command-line flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --screen)
            SCREEN="$2"
            shift 2
            ;;
        --horizontal)
            HORIZONTAL_VIEWPORT="$2"
            shift 2
            ;;
        --vertical)
            VERTICAL_VIEWPORT="$2"
            shift 2
            ;;
        --interlaced)
            INTERLACED="$2"
            shift 2
            ;;
        --left-margin)
            LEFT_MARGIN="$2"
            shift 2
            ;;
        --right-margin)
            RIGHT_MARGIN="$2"
            shift 2
            ;;
        --top-margin)
            TOP_MARGIN="$2"
            shift 2
            ;;
        --bottom-margin)
            BOTTOM_MARGIN="$2"
            shift 2
            ;;
        --scale-horizontal)
            SCALEHORIZONTAL="$2"
            shift 2
            ;;
        --scale-vertical)
            SCALEVERTICAL="$2"
            shift 2
            ;;
        --refresh)
            REFRESH_RATE="$2"
            shift 2
            ;;
        --custom-mode-name)
            CUSTOM_MODE_NAME="$2"
            shift 2
            ;;
        --run-mode)
            RUN_MODE="$2"
            shift 2
            ;;
        *)
            echo "Error: Unknown option $1"
            echo "Usage: $0 [--screen <name>] [--horizontal <pixels>] [--vertical <lines>] [--interlaced y|n] [--left-margin <pixels>] [--right-margin <pixels>] [--top-margin <lines>] [--bottom-margin <lines>] [--scale-horizontal <factor>] [--scale-vertical <factor>] [--refresh <hz>]"
            exit 1
            ;;
    esac
done
# Input validation
if ! [[ "$HORIZONTAL_VIEWPORT" =~ ^[0-9]+$ ]] || ! [[ "$VERTICAL_VIEWPORT" =~ ^[0-9]+$ ]] || \
   ! [[ "$LEFT_MARGIN" =~ ^[0-9]+$ ]] || ! [[ "$RIGHT_MARGIN" =~ ^[0-9]+$ ]] || \
   ! [[ "$TOP_MARGIN" =~ ^[0-9]+$ ]] || ! [[ "$BOTTOM_MARGIN" =~ ^[0-9]+$ ]]; then
    echo "Error: Resolutions and margins must be non-negative integers"
    exit 1
fi
if ! [[ "$REFRESH_RATE" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: Refresh rate must be a number"
    exit 1
fi
if [[ "$INTERLACED" != "y" && "$INTERLACED" != "n" ]]; then
    echo "Error: --interlaced must be 'y' or 'n'"
    exit 1
fi
if ! [[ "$SCALEHORIZONTAL" =~ ^[0-9]+(\.[0-9]+)?$ ]] || ! [[ "$SCALEVERTICAL" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: Scale factors must be numbers"
    exit 1
fi
if [[ "$RUN_MODE" != "y" && "$RUN_MODE" != "n" ]]; then
    echo "Error: --run-mode must be 'y' or 'n'"
    exit 1
fi

# --- Calculate the non-expanded cvt resolution ---
echo "--- Calculate the non-expanded cvt resolution ---"
if [[ "$INTERLACED" == "y" ]]; then
    CVT_RES_ORIGINAL=$(cvt -i $HORIZONTAL_VIEWPORT $VERTICAL_VIEWPORT $REFRESH_RATE | grep -E 'Modeline (.*)' | sed -E 's/Modeline//g')
else
    CVT_RES_ORIGINAL=$(cvt $HORIZONTAL_VIEWPORT $VERTICAL_VIEWPORT $REFRESH_RATE | grep -E 'Modeline (.*)' | sed -E 's/Modeline//g')
fi
if [[ -z "$CVT_RES_ORIGINAL" ]]; then
    echo "Error: Failed to generate CVT modeline"
    exit 1
fi
echo "CVT_RES_ORIGINAL=$CVT_RES_ORIGINAL"

echo 
echo "Extract parameters..."
if [[ "$INTERLACED" == "y" ]]; then
    read MODE_NAME_ORIGINAL PIXEL_CLOCK_ORIGINAL H_ACTIVE_ORIGINAL H_SYNC_START_ORIGINAL H_SYNC_END_ORIGINAL H_TOTAL_ORIGINAL \
         V_ACTIVE_ORIGINAL V_SYNC_START_ORIGINAL V_SYNC_END_ORIGINAL V_TOTAL_ORIGINAL INTERLACE_FLAG HSYNC_POLARITY_ORIGINAL VSYNC_POLARITY_ORIGINAL \
         <<< $(echo "$CVT_RES_ORIGINAL" | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}')
    [[ "$INTERLACE_FLAG" != "interlace" ]] && { echo "Error: Expected 'interlace' flag in CVT output"; exit 1; }
else
    read MODE_NAME_ORIGINAL PIXEL_CLOCK_ORIGINAL H_ACTIVE_ORIGINAL H_SYNC_START_ORIGINAL H_SYNC_END_ORIGINAL H_TOTAL_ORIGINAL \
         V_ACTIVE_ORIGINAL V_SYNC_START_ORIGINAL V_SYNC_END_ORIGINAL V_TOTAL_ORIGINAL HSYNC_POLARITY_ORIGINAL VSYNC_POLARITY_ORIGINAL \
         <<< $(echo "$CVT_RES_ORIGINAL" | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}')
    INTERLACE_FLAG=""
fi
# Print variables to verify
echo "MODE_NAME_ORIGINAL: $MODE_NAME_ORIGINAL"
echo "PIXEL_CLOCK_ORIGINAL: $PIXEL_CLOCK_ORIGINAL"
echo "H_ACTIVE_ORIGINAL: $H_ACTIVE_ORIGINAL"
echo "H_SYNC_START_ORIGINAL: $H_SYNC_START_ORIGINAL"
echo "H_SYNC_END_ORIGINAL: $H_SYNC_END_ORIGINAL"
echo "H_TOTAL_ORIGINAL: $H_TOTAL_ORIGINAL"
echo "V_ACTIVE_ORIGINAL: $V_ACTIVE_ORIGINAL"
echo "V_SYNC_START_ORIGINAL: $V_SYNC_START_ORIGINAL"
echo "V_SYNC_END_ORIGINAL: $V_SYNC_END_ORIGINAL"
echo "V_TOTAL_ORIGINAL: $V_TOTAL_ORIGINAL"
echo "HSYNC_POLARITY_ORIGINAL: $HSYNC_POLARITY_ORIGINAL"
echo "VSYNC_POLARITY_ORIGINAL: $VSYNC_POLARITY_ORIGINAL"
echo "INTERLACE_FLAG: $INTERLACE_FLAG"

echo 
echo "Derived parameters..."
H_FRONT_PORCH_WIDTH_ORIGINAL=$(($H_SYNC_START_ORIGINAL - $H_ACTIVE_ORIGINAL))
H_SYNC_WIDTH_ORIGINAL=$(($H_SYNC_END_ORIGINAL - $H_SYNC_START_ORIGINAL))
H_BACK_PORCH_WIDTH_ORIGINAL=$(($H_TOTAL_ORIGINAL - $H_SYNC_END_ORIGINAL))
echo "H_FRONT_PORCH_WIDTH_ORIGINAL: $H_FRONT_PORCH_WIDTH_ORIGINAL"
echo "H_SYNC_WIDTH_ORIGINAL: $H_SYNC_WIDTH_ORIGINAL"
echo "H_BACK_PORCH_WIDTH_ORIGINAL: $H_BACK_PORCH_WIDTH_ORIGINAL"
V_FRONT_PORCH_WIDTH_ORIGINAL=$(($V_SYNC_START_ORIGINAL - $V_ACTIVE_ORIGINAL))
V_SYNC_WIDTH_ORIGINAL=$(($V_SYNC_END_ORIGINAL - $V_SYNC_START_ORIGINAL))
V_BACK_PORCH_WIDTH_ORIGINAL=$(($V_TOTAL_ORIGINAL - $V_SYNC_END_ORIGINAL))
echo "V_FRONT_PORCH_WIDTH_ORIGINAL: $V_FRONT_PORCH_WIDTH_ORIGINAL"
echo "V_SYNC_WIDTH_ORIGINAL: $V_SYNC_WIDTH_ORIGINAL"
echo "V_BACK_PORCH_WIDTH_ORIGINAL: $V_BACK_PORCH_WIDTH_ORIGINAL"

# --- Calculate the expanded cvt resolution ---
echo
echo "--- Calculate the expanded cvt resolution ---"
HORIZONTAL_RESOLUTION=$(($HORIZONTAL_VIEWPORT + $LEFT_MARGIN + $RIGHT_MARGIN))
VERTICAL_RESOLUTION=$(($VERTICAL_VIEWPORT + $TOP_MARGIN + $BOTTOM_MARGIN))
echo "HORIZONTAL_RESOLUTION: $HORIZONTAL_RESOLUTION"
echo "VERTICAL_RESOLUTION: $VERTICAL_RESOLUTION"

if [[ "$INTERLACED" == "y" ]]; then
    CVT_RES_EXPANDED=$(cvt -i $HORIZONTAL_RESOLUTION $VERTICAL_RESOLUTION $REFRESH_RATE | grep -E 'Modeline (.*)' | sed -E 's/Modeline//g')
else
    CVT_RES_EXPANDED=$(cvt $HORIZONTAL_RESOLUTION $VERTICAL_RESOLUTION $REFRESH_RATE | grep -E 'Modeline (.*)' | sed -E 's/Modeline//g')
fi
if [[ -z "$CVT_RES_EXPANDED" ]]; then
    echo "Error: Failed to generate expanded CVT modeline"
    exit 1
fi
echo "CVT_RES_EXPANDED=$CVT_RES_EXPANDED"

echo "Extract parameters..."
if [[ "$INTERLACED" == "y" ]]; then
    read MODE_NAME_EXPANDED PIXEL_CLOCK_EXPANDED H_ACTIVE_EXPANDED H_SYNC_START_EXPANDED H_SYNC_END_EXPANDED H_TOTAL_EXPANDED \
         V_ACTIVE_EXPANDED V_SYNC_START_EXPANDED V_SYNC_END_EXPANDED V_TOTAL_EXPANDED INTERLACE_FLAG_EXPANDED HSYNC_POLARITY_EXPANDED VSYNC_POLARITY_EXPANDED \
         <<< $(echo "$CVT_RES_EXPANDED" | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13}')
    [[ "$INTERLACE_FLAG_EXPANDED" != "interlace" ]] && { echo "Error: Expected 'interlace' flag in expanded CVT output"; exit 1; }
else
    read MODE_NAME_EXPANDED PIXEL_CLOCK_EXPANDED H_ACTIVE_EXPANDED H_SYNC_START_EXPANDED H_SYNC_END_EXPANDED H_TOTAL_EXPANDED \
         V_ACTIVE_EXPANDED V_SYNC_START_EXPANDED V_SYNC_END_EXPANDED V_TOTAL_EXPANDED HSYNC_POLARITY_EXPANDED VSYNC_POLARITY_EXPANDED \
         <<< $(echo "$CVT_RES_EXPANDED" | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}')
fi
echo "MODE_NAME_EXPANDED: $MODE_NAME_EXPANDED"
echo "PIXEL_CLOCK_EXPANDED: $PIXEL_CLOCK_EXPANDED"
echo "H_ACTIVE_EXPANDED: $H_ACTIVE_EXPANDED"
echo "H_SYNC_START_EXPANDED: $H_SYNC_START_EXPANDED"
echo "H_SYNC_END_EXPANDED: $H_SYNC_END_EXPANDED"
echo "H_TOTAL_EXPANDED: $H_TOTAL_EXPANDED"
echo "V_ACTIVE_EXPANDED: $V_ACTIVE_EXPANDED"
echo "V_SYNC_START_EXPANDED: $V_SYNC_START_EXPANDED"
echo "V_SYNC_END_EXPANDED: $V_SYNC_END_EXPANDED"
echo "V_TOTAL_EXPANDED: $V_TOTAL_EXPANDED"
echo "HSYNC_POLARITY_EXPANDED: $HSYNC_POLARITY_EXPANDED"
echo "VSYNC_POLARITY_EXPANDED: $VSYNC_POLARITY_EXPANDED"

echo "Derived parameters..."
H_FRONT_PORCH_WIDTH_EXPANDED=$(($H_SYNC_START_EXPANDED - $H_ACTIVE_EXPANDED))
H_SYNC_WIDTH_EXPANDED=$(($H_SYNC_END_EXPANDED - $H_SYNC_START_EXPANDED))
H_BACK_PORCH_WIDTH_EXPANDED=$(($H_TOTAL_EXPANDED - $H_SYNC_END_EXPANDED))
echo "H_FRONT_PORCH_WIDTH_EXPANDED: $H_FRONT_PORCH_WIDTH_EXPANDED"
echo "H_SYNC_WIDTH_EXPANDED: $H_SYNC_WIDTH_EXPANDED"
echo "H_BACK_PORCH_WIDTH_EXPANDED: $H_BACK_PORCH_WIDTH_EXPANDED"
V_FRONT_PORCH_WIDTH_EXPANDED=$(($V_SYNC_START_EXPANDED - $V_ACTIVE_EXPANDED))
V_SYNC_WIDTH_EXPANDED=$(($V_SYNC_END_EXPANDED - $V_SYNC_START_EXPANDED))
V_BACK_PORCH_WIDTH_EXPANDED=$(($V_TOTAL_EXPANDED - $V_SYNC_END_EXPANDED))
echo "V_FRONT_PORCH_WIDTH_EXPANDED: $V_FRONT_PORCH_WIDTH_EXPANDED"
echo "V_SYNC_WIDTH_EXPANDED: $V_SYNC_WIDTH_EXPANDED"
echo "V_BACK_PORCH_WIDTH_EXPANDED: $V_BACK_PORCH_WIDTH_EXPANDED"

# --- Final modeline ---
echo
echo "--- Final modeline ---"
MODE_NAME_FINAL=$(echo "${MODE_NAME_ORIGINAL}_ON_${MODE_NAME_EXPANDED}" | tr -d '"')
if [[ "$INTERLACED" == "y" ]]; then
    MODE_NAME_FINAL=$(echo "${MODE_NAME_ORIGINAL}_ON_${MODE_NAME_EXPANDED}_INTERLACED" | tr -d '"')
else
    MODE_NAME_FINAL=$(echo "${MODE_NAME_ORIGINAL}_ON_${MODE_NAME_EXPANDED}" | tr -d '"')
fi
echo "MODE_NAME_FINAL: $MODE_NAME_FINAL"

# Calculate final timings
H_FRONT_PORCH_END_FINAL=$(($H_ACTIVE_ORIGINAL + $H_FRONT_PORCH_WIDTH_EXPANDED + $RIGHT_MARGIN))
H_SYNC_END_FINAL=$(($H_FRONT_PORCH_END_FINAL + $H_SYNC_WIDTH_EXPANDED))
V_FRONT_PORCH_END_FINAL=$(($V_ACTIVE_ORIGINAL + $V_FRONT_PORCH_WIDTH_EXPANDED + $BOTTOM_MARGIN))
V_SYNC_END_FINAL=$(($V_FRONT_PORCH_END_FINAL + $V_SYNC_WIDTH_EXPANDED))

# Build final modeline
CVT_RES_FINAL="$PIXEL_CLOCK_EXPANDED $H_ACTIVE_ORIGINAL $H_FRONT_PORCH_END_FINAL $H_SYNC_END_FINAL $H_TOTAL_EXPANDED $V_ACTIVE_ORIGINAL $V_FRONT_PORCH_END_FINAL $V_SYNC_END_FINAL $V_TOTAL_EXPANDED $INTERLACE_FLAG $HSYNC_POLARITY_EXPANDED $VSYNC_POLARITY_EXPANDED"
echo "CVT_RES_FINAL: $CVT_RES_FINAL"


if [[ -n $CUSTOM_MODE_NAME ]]; then
   MODE_NAME_FINAL="$CUSTOM_MODE_NAME"
fi

# Apply with xrandr
echo "xrandr --newmode \"$MODE_NAME_FINAL\" $CVT_RES_FINAL"
xrandr --newmode "$MODE_NAME_FINAL" $CVT_RES_FINAL || { echo "Error: Failed to create new mode"; exit 1; }
echo "xrandr --addmode $SCREEN \"$MODE_NAME_FINAL\""
xrandr --addmode $SCREEN "$MODE_NAME_FINAL" || { echo "Error: Failed to add mode"; exit 1; }
SCALE="${SCALEHORIZONTAL}x${SCALEVERTICAL}"
if [[ "$RUN_MODE" == "y" ]]; then 
    echo "xrandr --output $SCREEN --mode \"$MODE_NAME_FINAL\" --verbose --scale $SCALE"  
    xrandr --output $SCREEN --mode "$MODE_NAME_FINAL" --verbose --scale $SCALE || { echo "Error: Failed to set mode"; exit 1; }
fi

# ./bcvt.sh --left-margin 12 --right-margin 28 --top-margin 8 --bottom-margin 8 --scale-vertical 2
# ./bcvt.sh --interlaced y --vertical 480 --refresh 30  --left-margin 12 --right-margin 30 --top-margin 18 --bottom-margin 22








