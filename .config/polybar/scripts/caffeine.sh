#!/bin/bash

STATE_FILE="/tmp/.caffeine_enabled"

toggle_caffeine() {
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
        xset +dpms
        xset s on
    else
        touch "$STATE_FILE"
        xset -dpms
        xset s off
    fi
}

get_status() {
    if [ -f "$STATE_FILE" ]; then
        # Green for active caffeine
        echo "%{F#50fa7b}  %{F-}"
    else
        # Red for sleep mode 
        echo "%{F#bd93f9}󰅶 %{F-}"
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
