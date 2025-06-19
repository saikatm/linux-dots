#!/bin/bash

# Polybar Stopwatch — Clean Dracula Mode
STATE="/tmp/polybar_stopwatch_state"
START="/tmp/polybar_stopwatch_start"
PAUSE="/tmp/polybar_stopwatch_pause"
ELAPSED="/tmp/polybar_stopwatch_elapsed"

# Dracula fixed colors
GREEN="#50fa7b"
ORANGE="#ffb86c"
GRAY="#6272a4"

format_time() {
    local t=$1
    printf "%02d:%02d:%02d" $((t/3600)) $(( (t%3600)/60 )) $((t%60))
}

# Click handling
case "$1" in
    toggle)
        if [ ! -f "$STATE" ]; then
            echo running > "$STATE"
            date +%s > "$START"
            echo 0 > "$ELAPSED"
            rm -f "$PAUSE"
        elif [ -f "$PAUSE" ]; then
            echo running > "$STATE"
            date +%s > "$START"
            rm -f "$PAUSE"
        else
            echo paused > "$STATE"
            now=$(date +%s)
            start=$(<"$START")
            prev=$(<"$ELAPSED" 2>/dev/null || echo 0)
            echo $((prev + now - start)) > "$ELAPSED"
            touch "$PAUSE"
        fi
        ;;
    reset)
        rm -f "$STATE" "$START" "$PAUSE" "$ELAPSED"
        ;;
esac

# Output
if [ -f "$STATE" ]; then
    state=$(<"$STATE")
    if [ "$state" = "running" ]; then
        now=$(date +%s)
        start=$(<"$START")
        prev=$(<"$ELAPSED" 2>/dev/null || echo 0)
        time=$((prev + now - start))
        icon="󱎫"
        color="$GREEN"
    else
        time=$(<"$ELAPSED" 2>/dev/null || echo 0)
        icon="󰏤"
        color="$ORANGE"
    fi
    echo "%{F$color}$icon $(format_time $time)%{F-}"
else
    echo "%{F$GRAY}󱫍 00:00:00%{F-}"
fi
