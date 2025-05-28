#!/bin/bash

# i3 Keyboard Shortcuts Display Script
# Save this as ~/.config/i3/scripts/show_shortcuts.sh and make it executable

SHORTCUTS="
🎯 i3 KEYBOARD SHORTCUTS 🎯

📦 WINDOW MANAGEMENT
Alt + Shift + Q          Kill focused window
Alt + J/K/L/;           Focus left/down/up/right
Alt + ←/↓/↑/→           Focus with arrow keys
Alt + Shift + J/K/L/;   Move window left/down/up/right  
Alt + Shift + ←/↓/↑/→   Move window with arrow keys
Alt + H                 Split horizontal
Alt + V                 Split vertical
Alt + F                 Toggle fullscreen
Alt + Shift + Space     Toggle floating
Alt + Space             Focus floating/tiling
Alt + A                 Focus parent container
Alt + B                 Toggle window border

📐 LAYOUTS
Alt + S                 Stacking layout
Alt + W                 Tabbed layout  
Alt + E                 Toggle split layout

🖥️  WORKSPACES
Alt + 1-9,0            Switch to workspace 1-10
Alt + Shift + 1-9,0    Move container to workspace 1-10

🚀 APPLICATIONS
Alt + Enter            Open terminal (kitty)
Alt + D                Application launcher (rofi)
Alt + Tab              Window switcher (rofi)

🔧 SYSTEM CONTROLS
Alt + Shift + C        Reload i3 config
Alt + Shift + R        Restart i3
Alt + Shift + E        Exit i3 (with confirmation)

📏 GAPS & RESIZE
Alt + G                Increase inner gaps (+5)
Alt + Shift + G        Decrease inner gaps (-5)
Alt + Ctrl + G         Reset gaps to 0
Alt + R                Enter resize mode

🎵 MEDIA CONTROLS
Vol+/Vol-              Volume up/down (10%)
Mute                   Toggle audio mute
Mic Mute               Toggle microphone mute

💡 RESIZE MODE (when active)
J/K/L/;                Resize window
←/↓/↑/→               Resize with arrows
Enter/Escape/Alt+R     Exit resize mode

📋 CUSTOM SHORTCUTS
Alt + ?                Show this help (NEW!)
"

# Display the shortcuts using rofi in a readable format
echo "$SHORTCUTS" | rofi -dmenu -i -p "i3 Shortcuts" \
    -theme-str 'window {width: 50%; height: 70%;}' \
    -theme-str 'listview {lines: 30;}' \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -no-custom -no-select
