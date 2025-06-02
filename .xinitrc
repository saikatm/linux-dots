#!/bin/sh

# Source system-wide xinitrc scripts
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Merge Xresources
xrdb -merge ~/.Xresources

# Keyboard and repeat settings
xset r rate 300 50
setxkbmap us

# Start background apps
dunst &          # Notification daemon
copyq &          # Clipboard manager
megasync &       # Mega sync client
polybar &        # Status bar
~/.config/polybar/launch.sh &

# Enable touchpad tap-to-click and natural scrolling
sleep 1
TOUCHPAD_NAME=$(xinput list --name-only | grep -i 'touchpad')
DEVICE_ID=$(xinput list | grep "$TOUCHPAD_NAME" | grep -o 'id=[0-9]*' | cut -d= -f2)

if [ -n "$DEVICE_ID" ]; then
    xinput set-prop "$DEVICE_ID" "libinput Tapping Enabled" 1
    xinput set-prop "$DEVICE_ID" "libinput Natural Scrolling Enabled" 1
fi

# Start i3 window manager (don't put '&' here)
exec i3
