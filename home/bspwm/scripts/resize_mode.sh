#!/bin/bash
# ~/.config/bspwm/scripts/resize_mode.sh
# Resize mode implementation for BSPWM

# Configuration
RESIZE_STEP=20
NOTIFICATION_TIME=2000

# Show notification
notify-send -t $NOTIFICATION_TIME "Resize Mode" "Arrow keys to resize, ESC/Enter/r to exit"

# Create temporary config for resize mode
TEMP_CONFIG=$(mktemp --suffix=_bspwm_resize)
SCRIPT_PID=$$

cat > "$TEMP_CONFIG" << EOF
# BSPWM Resize Mode - Temporary keybindings
# Arrow keys for resizing
Left
    bspc node -z left -$RESIZE_STEP 0 || bspc node -z right -$RESIZE_STEP 0

Down
    bspc node -z bottom 0 $RESIZE_STEP || bspc node -z top 0 $RESIZE_STEP

Up
    bspc node -z top 0 -$RESIZE_STEP || bspc node -z bottom 0 -$RESIZE_STEP

Right
    bspc node -z right $RESIZE_STEP 0 || bspc node -z left $RESIZE_STEP 0

# Vim-like keys (optional)
h
    bspc node -z left -$RESIZE_STEP 0 || bspc node -z right -$RESIZE_STEP 0

j
    bspc node -z bottom 0 $RESIZE_STEP || bspc node -z top 0 $RESIZE_STEP

k
    bspc node -z top 0 -$RESIZE_STEP || bspc node -z bottom 0 -$RESIZE_STEP

l
    bspc node -z right $RESIZE_STEP 0 || bspc node -z left $RESIZE_STEP 0

# Exit resize mode
Escape
    kill $SCRIPT_PID

Return
    kill $SCRIPT_PID

r
    kill $SCRIPT_PID
EOF

# Function to cleanup on exit
cleanup() {
    if [[ -n $SXHKD_PID ]] && kill -0 $SXHKD_PID 2>/dev/null; then
        kill $SXHKD_PID
    fi
    rm -f "$TEMP_CONFIG"
    notify-send -t 1000 "Resize Mode" "Exited"
    exit 0
}

# Set up signal handlers
trap cleanup EXIT INT TERM

# Start temporary sxhkd instance for resize mode
sxhkd -c "$TEMP_CONFIG" &
SXHKD_PID=$!

# Wait for sxhkd to exit or for script to be killed
wait $SXHKD_PID 2>/dev/null