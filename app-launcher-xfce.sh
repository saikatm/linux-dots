#!/usr/bin/env bash

# === Step 1: Create the launch-my-apps.sh ===
LAUNCH_SCRIPT="$HOME/launch-apps.sh"

cat > "$LAUNCH_SCRIPT" << 'EOF'
#!/usr/bin/env bash

# Directory containing AppImages
APPDIR="$HOME/Applications"

# Locate AppImages
TODOIST_IMG=$(ls "$APPDIR"/Todoist*.AppImage 2>/dev/null | tail -n1)
NOTION_IMG=$(ls "$APPDIR"/Notion*.AppImage 2>/dev/null | tail -n1)

# Ensure they're executable
for IMG in "$TODOIST_IMG" "$NOTION_IMG"; do
  [[ -n "$IMG" && ! -x "$IMG" ]] && chmod +x "$IMG"
done

# Launch Todoist
if [[ -n "$TODOIST_IMG" ]]; then
  nohup "$TODOIST_IMG" > /dev/null 2>&1 & disown
else
  echo "⚠️ Todoist AppImage not found."
fi

sleep 1

# Launch Notion
if [[ -n "$NOTION_IMG" ]]; then
  nohup "$NOTION_IMG" > /dev/null 2>&1 & disown
else
  echo "⚠️ Notion AppImage not found."
fi

sleep 1

# Launch Firefox
if command -v firefox &>/dev/null; then
  nohup firefox > /dev/null 2>&1 & disown
else
  echo "⚠️ Firefox not found in PATH."
fi

sleep 1

# Launch Google Chrome
if command -v google-chrome &>/dev/null; then
  nohup google-chrome > /dev/null 2>&1 & disown
else
  echo "⚠️ Google Chrome not found in PATH."
fi

exit 0
EOF

# Make the main launcher script executable
chmod +x "$LAUNCH_SCRIPT"

# === Step 2: Create the .desktop file ===
DESKTOP_FILE="$HOME/.local/share/applications/launch-apps.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Launch My Apps
Comment=Start Todoist, Notion, Firefox and Chrome
Exec=$LAUNCH_SCRIPT
Icon=utilities-terminal
Terminal=false
Categories=Utility;
EOF

chmod +x "$DESKTOP_FILE"

# === Step 3: User Prompt to Add to XFCE Panel ===
echo -e "\n✅ Setup complete!"
echo "➡️  To finish setup:"
echo "   1. Right-click XFCE panel > Panel > Add New Items > Launcher"
echo "   2. Right-click the new launcher > Properties"
echo "   3. Click '+' and select:"
echo "      $DESKTOP_FILE"
echo
