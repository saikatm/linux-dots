#!/bin/bash

# Script to set Papirus icon theme for BSPWM/Polybar system tray (no installation step)

set -e

echo "[+] Configuring Papirus Icon Theme..."

# GTK2
echo "[+] Setting GTK2 icon theme..."
mkdir -p ~/.config/gtk-2.0/
echo 'gtk-icon-theme-name="Papirus"' > ~/.gtkrc-2.0

# GTK3
echo "[+] Setting GTK3 icon theme..."
mkdir -p ~/.config/gtk-3.0/
cat > ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-icon-theme-name=Papirus
EOF

# GTK4
echo "[+] Setting GTK4 icon theme..."
mkdir -p ~/.config/gtk-4.0/
cat > ~/.config/gtk-4.0/settings.ini <<EOF
[Settings]
gtk-icon-theme-name=Papirus
EOF

# X profile environment (for BSPWM)
echo "[+] Updating ~/.xprofile..."
touch ~/.xprofile
grep -qxF 'export XDG_CURRENT_DESKTOP=BSPWM' ~/.xprofile || echo 'export XDG_CURRENT_DESKTOP=BSPWM' >> ~/.xprofile
grep -qxF 'export GTK_THEME=Papirus' ~/.xprofile || echo 'export GTK_THEME=Papirus' >> ~/.xprofile

echo "[✔] Papirus icon theme configuration applied!"
echo "ℹ️  Restart your session or run 'pkill polybar && polybar yourbar &' to see the changes."
