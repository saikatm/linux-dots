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

# Check if GDM is installed
echo "🔍 Checking for existing display managers..."
GDM_INSTALLED=false

if command -v gdm >/dev/null 2>&1 || command -v gdm3 >/dev/null 2>&1; then
    GDM_INSTALLED=true
    echo "✅ GDM detected - skipping LightDM installation"
elif systemctl list-unit-files | grep -q "gdm\|gdm3"; then
    GDM_INSTALLED=true
    echo "✅ GDM service detected - skipping LightDM installation"
elif dpkg -l | grep -q "gdm3\|gdm" 2>/dev/null; then
    GDM_INSTALLED=true
    echo "✅ GDM package detected - skipping LightDM installation"
elif rpm -qa | grep -q "gdm" 2>/dev/null; then
    GDM_INSTALLED=true
    echo "✅ GDM package detected - skipping LightDM installation"
elif pacman -Qs gdm >/dev/null 2>&1; then
    GDM_INSTALLED=true
    echo "✅ GDM package detected - skipping LightDM installation"
else
    echo "❌ No GDM found - will install LightDM"
fi

sleep 1

# Define distro-specific package lists
if [[ "$OS" =~ ^(arch|manjaro|endeavouros)$ ]]; then
    PACKAGES="bspwm sxhkd polybar feh dunst parcellite network-manager-applet"
    if [ "$GDM_INSTALLED" = false ]; then
        PACKAGES="$PACKAGES lightdm lightdm-gtk-greeter"
    fi
    INSTALL_CMD="sudo pacman -Syu --needed $PACKAGES"
    
elif [[ "$OS" =~ ^(ubuntu|debian|pop)$ ]]; then
    PACKAGES="bspwm sxhkd polybar feh dunst parcellite network-manager-gnome"
    if [ "$GDM_INSTALLED" = false ]; then
        PACKAGES="$PACKAGES lightdm lightdm-gtk-greeter"
    fi
    INSTALL_CMD="sudo apt update && sudo apt install -y $PACKAGES"
    
elif [[ "$OS" == "fedora" ]]; then
    PACKAGES="bspwm sxhkd polybar feh dunst parcellite NetworkManager-gnome"
    if [ "$GDM_INSTALLED" = false ]; then
        PACKAGES="$PACKAGES lightdm lightdm-gtk-greeter"
    fi
    INSTALL_CMD="sudo dnf install -y $PACKAGES"
    
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

echo "📦 Packages to install: $PACKAGES"
echo "🚀 Running install command..."
sleep 1

eval "$INSTALL_CMD"

if [ $? -eq 0 ]; then
    echo "✅ All packages installed successfully (or already present)."
    
    # Configure LightDM if it was installed
    if [ "$GDM_INSTALLED" = false ]; then
        echo "⚙️  Configuring LightDM..."
        
        # Enable LightDM service
        sudo systemctl enable lightdm
        
        # Set GTK greeter as default if config exists
        if [ -f /etc/lightdm/lightdm.conf ]; then
            sudo sed -i 's/^#greeter-session=.*/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf
            echo "✅ LightDM configured with GTK greeter"
        else
            echo "⚠️  LightDM config not found at /etc/lightdm/lightdm.conf"
        fi
        
        echo "📝 Note: You may need to reboot for LightDM to take effect"
    fi
else
    echo "❌ Package installation failed!"
    exit 1
fi