#!/bin/bash

# -----------------------------------------
# BSPWM + Essentials Installer (Cross-Distro)
# -----------------------------------------

echo "🔍 Detecting your Linux distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "❌ Cannot detect OS. Exiting."
    exit 1
fi

echo "🎯 Detected OS: $OS"
sleep 1

# Define distro-specific package lists
if [[ "$OS" =~ ^(arch|manjaro|endeavouros)$ ]]; then
    PACKAGES="bspwm sxhkd polybar feh dunst parcellite network-manager-applet"
    INSTALL_CMD="sudo pacman -Syu --needed $PACKAGES"

elif [[ "$OS" =~ ^(ubuntu|debian|pop)$ ]]; then
    PACKAGES="bspwm sxhkd polybar feh dunst parcellite network-manager-gnome"
    INSTALL_CMD="sudo apt update && sudo apt install -y $PACKAGES"

elif [[ "$OS" == "fedora" ]]; then
    PACKAGES="bspwm sxhkd polybar feh dunst parcellite NetworkManager-gnome"
    INSTALL_CMD="sudo dnf install -y $PACKAGES"

else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

echo "📦 Packages to install: $PACKAGES"
echo "🚀 Running install command..."
sleep 1

eval "$INSTALL_CMD"

echo "✅ All packages installed successfully (or already present)."
