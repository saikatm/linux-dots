#!/bin/bash
# List of options — no icons for max compatibility
options="Poweroff\nSleep\nLock\nLogout\nReboot"

# Show menu with Dracula colors - positioned to avoid polybar
choice=$(echo -e "$options" | dmenu -i -p "Select Action:" \
-fn "monospace-16:bold" \
-nb "#282a36" -nf "#f8f8f2" \
-sb "#bd93f9" -sf "#282a36" \
-b)

# Act based on choice
case "$choice" in
    Poweroff) systemctl poweroff ;;
    Sleep) dm-tool lock & systemctl suspend ;;
    Lock) dm-tool lock ;;
    Logout) loginctl terminate-user $USER ;;
    # bspc quit # bspwm
    Reboot) systemctl reboot ;;
    *) exit 1 ;;
esac

