#!/bin/bash

echo "Restarting BSPWM..."

# Kill processes
killall sxhkd polybar dunst 2>/dev/null

# Wait
sleep 2

# Restart
sxhkd &
bspc wm -r
~/.config/polybar/launch.sh &

echo "Done!"