#!/bin/bash

STATE_FILE="/tmp/.caffeine_enabled"

toggle_caffeine() {
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
        xset +dpms
        xset s on
        notify-send -u low -i "preferences-desktop-screensaver" "Caffeine Disabled" "Screen blanking and power saving re-enabled."
    else
        touch "$STATE_FILE"
        xset -dpms
        xset s off
        notify-send -u low -i "coffee" "Caffeine Enabled" "Screen will stay awake (DPMS off)."
    fi
}

get_status() {
    if [ -f "$STATE_FILE" ]; then
        # Green icon for caffeine enabled
        echo "%{F#50fa7b}󰈈%{F-}"
    else
        # Purple icon for caffeine disabled (sleep mode)
        echo "%{F#bd93f9}󰅶%{F-}"
    fi
}

case "$1" in
    --toggle)
        toggle_caffeine
        ;;
    *)
        get_status
        ;;
esac
