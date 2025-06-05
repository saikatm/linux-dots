#!/bin/bash
# ~/.config/bspwm/scripts/resize_mode.sh
# Resize mode implementation for BSPWM

# Show notification
notify-send "Resize Mode" "h/j/k/l or arrows to resize, ESC/Enter to exit"

# Create temporary config for resize mode
TEMP_CONFIG=$(mktemp)
cat > "$TEMP_CONFIG" << 'EOF'
# Resize mode keybindings
# Vim-like keys
h
    bspc node -z left -20 0 || bspc node -z right -20 0
j  
    bspc node -z bottom 0 20 || bspc node -z top 0 20
k
    bspc node -z top 0 -20 || bspc node -z bottom 0 -20
l
    bspc node -z right 20 0 || bspc node -z left 20 0

# Arrow keys
Left
    bspc node -z left -20 0 || bspc node -z right -20 0
Down
    bspc node -z bottom 0 20 || bspc node -z top 0 20
Up
    bspc node -z top 0 -20 || bspc node -z bottom 0 -20
Right
    bspc node -z right 20 0 || bspc node -z left 20 0

# Exit resize mode
Escape
    pkill -f "sxhkd.*$TEMP_CONFIG"
Return
    pkill -f "sxhkd.*$TEMP_CONFIG"
r
    pkill -f "sxhkd.*$TEMP_CONFIG"
EOF

# Start temporary sxhkd instance for resize mode
sxhkd -c "$TEMP_CONFIG" &
SXHKD_PID=$!

# Wait for sxhkd to exit, then cleanup
wait $SXHKD_PID
rm -f "$TEMP_CONFIG"
notify-send "Resize Mode" "Exited"