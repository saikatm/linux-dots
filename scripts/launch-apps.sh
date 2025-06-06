#!/usr/bin/env bash

# === Configuration ===
APPDIR="$HOME/Applications"
SCRIPT_PATH="$(realpath "$0")"
DESKTOP_FILE="$HOME/.local/share/applications/launch-apps.desktop"

# === Helper: Install dependency if missing ===
require() {
  command -v "$1" &>/dev/null && return
  echo "$1 not found. Install it? (y/n)"
  read -r choice
  [[ "$choice" =~ ^[Yy]$ ]] || { echo "Cannot proceed without $1"; exit 1; }
  if command -v sudo &>/dev/null; then
    sudo apt install "$2" -y 2>/dev/null || sudo pacman -S "$2" --noconfirm
  else
    echo "No sudo or package manager found. Please install $1 manually."; exit 1
  fi
}

# === Check dependencies ===
require zenity zenity

# === Locate AppImages ===
TODOIST=$(find "$APPDIR" -name "Todoist*.AppImage" | sort | tail -n1)
NOTION=$(find "$APPDIR" -name "Notion*.AppImage" | sort | tail -n1)

# === Make AppImages executable ===
chmod +x "$TODOIST" "$NOTION" 2>/dev/null

# === Smooth Progress Animation Only ===
(
  for i in {1..20}; do
    echo $((i * 5))
    sleep 0.15
  done
) | zenity --progress \
  --title="Launching Apps..." \
  --text="Please wait..." \
  --percentage=0 \
  --auto-close \
  --width=300

# === Launch Apps Silently ===
[[ -x "$TODOIST" ]] && nohup "$TODOIST" >/dev/null 2>&1 &
[[ -x "$NOTION"  ]] && nohup "$NOTION"  >/dev/null 2>&1 &
command -v firefox        &>/dev/null && nohup firefox        >/dev/null 2>&1 &
command -v google-chrome  &>/dev/null && nohup google-chrome  >/dev/null 2>&1 &

# === Create Desktop Entry ===
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Launch My Apps
Comment=Start your favorite apps
Exec=$SCRIPT_PATH
Icon=utilities-terminal
Terminal=false
Categories=Utility;
EOF
chmod +x "$DESKTOP_FILE"

# === Done Message ===
echo -e "\n✅ All done!"
echo "➡️  To add this to your XFCE panel:"
echo "   1. Right-click panel > Panel > Add New Items > Launcher"
echo "   2. Right-click new launcher > Properties"
echo "   3. Click '+' and choose: $DESKTOP_FILE"
echo
