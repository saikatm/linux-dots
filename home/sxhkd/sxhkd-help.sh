#!/bin/bash

# Simple working sxhkd help script
SXHKDRC="$HOME/.config/sxhkd/sxhkdrc"

if [[ ! -f "$SXHKDRC" ]]; then
    notify-send "Error" "sxhkdrc not found"
    exit 1
fi

# Extract shortcuts and comments
temp_file=$(mktemp)
{
    echo "=== SXHKD KEYBOARD SHORTCUTS ==="
    echo ""
    
    comment=""
    while read -r line; do
        # Skip empty lines
        if [[ -z "$line" ]]; then
            comment=""  # Reset comment on empty line
            continue
        fi
        
        # Check for comment lines
        if [[ "$line" =~ ^#[[:space:]]*(.*) ]]; then
            comment="${BASH_REMATCH[1]}"
        # Check for keybinding lines (not indented)
        elif [[ "$line" =~ ^[a-zA-Z] ]] && [[ ! "$line" =~ ^[[:space:]] ]]; then
            if [[ -n "$comment" ]]; then
                printf "%-25s → %s\n" "$line" "$comment"
            else
                printf "%-25s → %s\n" "$line" "No description"
            fi
            comment=""  # Reset comment after using it
        else
            comment=""  # Reset comment if line doesn't match patterns
        fi
    done < "$SXHKDRC"
} > "$temp_file"

# Display with available tool
if command -v rofi >/dev/null 2>&1; then
    cat "$temp_file" | rofi -dmenu -i -p "SXHKD Shortcuts" -theme-str 'window {width: 80%;}'
elif command -v alacritty >/dev/null 2>&1; then
    alacritty --title "SXHKD Shortcuts" -e less "$temp_file"
elif command -v xterm >/dev/null 2>&1; then
    xterm -title "SXHKD Shortcuts" -e less "$temp_file"
else
    cat "$temp_file"
fi

rm "$temp_file"