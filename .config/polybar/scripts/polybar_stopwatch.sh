#!/bin/bash

# Polybar Stopwatch Module
# Uses Dracula color scheme with dynamic colors

# State files to track stopwatch
STATE_FILE="/tmp/polybar_stopwatch_state"
START_FILE="/tmp/polybar_stopwatch_start"
PAUSE_FILE="/tmp/polybar_stopwatch_pause"
ELAPSED_FILE="/tmp/polybar_stopwatch_elapsed"

# Colors from Dracula palette
BG="#282a36"
FG="#f8f8f2"
GREEN="#50fa7b"
CYAN="#8be9fd"
YELLOW="#f1fa8c"
ORANGE="#ffb86c"
RED="#ff5555"
PURPLE="#bd93f9"
PINK="#ff79c6"

# Function to format time as hh:mm:ss
format_time() {
    local total_seconds=$1
    local hours=$((total_seconds / 3600))
    local minutes=$(((total_seconds % 3600) / 60))
    local seconds=$((total_seconds % 60))
    printf "%02d:%02d:%02d" $hours $minutes $seconds
}

# Function to get dynamic color based on elapsed time
get_dynamic_color() {
    local elapsed=$1
    local minutes=$((elapsed / 60))
    
    if [ $minutes -lt 5 ]; then
        echo $GREEN
    elif [ $minutes -lt 15 ]; then
        echo $CYAN
    elif [ $minutes -lt 30 ]; then
        echo $YELLOW
    elif [ $minutes -lt 60 ]; then
        echo $ORANGE
    elif [ $minutes -lt 120 ]; then
        echo $PINK
    else
        echo $RED
    fi
}

# Handle click actions
case "$1" in
    "toggle")
        if [ ! -f "$STATE_FILE" ]; then
            # Start stopwatch
            echo "running" > "$STATE_FILE"
            date +%s > "$START_FILE"
            echo "0" > "$ELAPSED_FILE"
            rm -f "$PAUSE_FILE"
        elif [ -f "$PAUSE_FILE" ]; then
            # Resume from pause
            echo "running" > "$STATE_FILE"
            date +%s > "$START_FILE"
            rm -f "$PAUSE_FILE"
        else
            # Pause stopwatch
            echo "paused" > "$STATE_FILE"
            current_time=$(date +%s)
            start_time=$(cat "$START_FILE")
            previous_elapsed=$(cat "$ELAPSED_FILE" 2>/dev/null || echo "0")
            total_elapsed=$((previous_elapsed + current_time - start_time))
            echo "$total_elapsed" > "$ELAPSED_FILE"
            echo "1" > "$PAUSE_FILE"
        fi
        ;;
    "reset")
        # Stop and reset everything
        rm -f "$STATE_FILE" "$START_FILE" "$PAUSE_FILE" "$ELAPSED_FILE"
        ;;
esac

# Display stopwatch
if [ -f "$STATE_FILE" ]; then
    state=$(cat "$STATE_FILE")
    
    if [ "$state" = "running" ]; then
        # Stopwatch is running
        start_time=$(cat "$START_FILE")
        current_time=$(date +%s)
        previous_elapsed=$(cat "$ELAPSED_FILE" 2>/dev/null || echo "0")
        elapsed=$((previous_elapsed + current_time - start_time))
        
        # Get dynamic color
        color=$(get_dynamic_color $elapsed)
        
        # Format and display with running icon
        formatted_time=$(format_time $elapsed)
        echo "%{F$color}󱎫 $formatted_time%{F-}"
        
    elif [ "$state" = "paused" ]; then
        # Stopwatch is paused
        elapsed=$(cat "$ELAPSED_FILE" 2>/dev/null || echo "0")
        
        # Get dynamic color
        color=$(get_dynamic_color $elapsed)
        
        # Format and display with paused icon
        formatted_time=$(format_time $elapsed)
        echo "%{F$color}󰏤 $formatted_time%{F-}"
    fi
else
    # Stopwatch is stopped
    echo "%{F$FG}󱫍 00:00:00%{F-}"
fi