#!/bin/bash
# List of options — no icons for max compatibility
options="Lock\nLogout\nPoweroff\nReboot\nSleep"

# Show menu with One Dark colors - positioned to avoid polybar
choice=$(echo -e "$options" | dmenu -i -p "Select Action:" \
-fn "monospace-11" \
-nb "#282c34" -nf "#abb2bf" \
-sb "#61afef" -sf "#282c34" \
-b)

# Alternative positions if -b doesn't work:
# Top with monitor specification: add -m 0
# Bottom: use -b flag
# If still overlapping, try rofi instead:
# choice=$(echo -e "$options" | rofi -dmenu -i -p "Select Action:" -theme-str 'window {location: center;}')

# Act based on choice
case "$choice" in
    Lock) dm-tool lock ;;
    Logout) loginctl terminate-user $USER ;;
    # bspc quit # bspwm
    Poweroff) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Sleep) dm-tool lock & systemctl suspend ;;
    *) exit 1 ;;
esac