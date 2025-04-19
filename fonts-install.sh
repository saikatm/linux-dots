#!/bin/bash

set -euo pipefail  # Enable strict error handling

echo "Installing fonts..."

# Navigate to parent directory
echo "Going to parent directory"
cd .. || { echo "Failed to change directory"; exit 1; }

# Clone font repository
echo "Cloning the font repository"
if ! git clone --depth 1 https://github.com/saikatm/fonts.git; then
    echo "Failed to clone repository"
    exit 1
fi

# Install fonts
echo "Moving font files"
cd fonts || { echo "Failed to enter fonts directory"; exit 1; }
cp -r .fonts ~/ || { echo "Failed to copy fonts"; exit 1; }

# Clear font cache
echo "Clearing font cache"
if ! fc-cache -fv; then
    echo "Warning: Failed to clear font cache (command exited with error)"
fi

echo "Font installation complete! Please reboot for changes to take effect."