#!/bin/bash

# Log function for consistent output
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Error handling function
handle_error() {
    log "ERROR: An error occurred at line $1"
    exit 1
}

# Set up error handling
trap 'handle_error $LINENO' ERR

# Check if script is run as root and refuse if so
if [ "$(id -u)" = "0" ]; then
    log "This script should not be run as root or with sudo directly."
    log "It will use sudo for commands that require elevated privileges."
    exit 1
fi

# Check if we're on Pop OS
if ! grep -q "Pop!_OS" /etc/os-release 2>/dev/null; then
    log "Warning: This script was designed for Pop OS. Some commands might not work on your distro."
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo    # Move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "Aborted by user."
        exit 1
    fi
fi

log "Starting XFCE minimal installation on Pop OS..."

# Update system first
log "Updating system packages..."
sudo apt update || { log "Failed to update package lists"; exit 1; }
sudo apt upgrade -y || { log "Failed to upgrade packages"; exit 1; }

# Install minimal XFCE setup without unnecessary applications
log "Installing minimal XFCE desktop environment..."
sudo apt install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    thunar \
    lightdm || { log "Failed to install XFCE packages"; exit 1; }

# Remove some unnecessary applications that might be installed
log "Removing unnecessary XFCE applications..."
sudo apt remove -y \
    xfce4-screensaver \
    parole \
    xfce4-notes \
    xfce4-dict \
    xfce4-mailwatch-plugin \
    xfce4-weather-plugin \
    xfce4-taskmanager \
    --purge || log "Some packages couldn't be removed, they might not be installed. Continuing..."

# Install dependencies for Materia theme
log "Installing dependencies for Materia theme..."
sudo apt install -y \
    git \
    sassc \
    libglib2.0-dev \
    libxml2-utils || { log "Failed to install theme dependencies"; exit 1; }

# Install latest Materia theme from GitHub
log "Installing latest Materia theme from GitHub..."
cd /tmp || { log "Failed to cd to /tmp"; exit 1; }
rm -rf materia-theme 2>/dev/null || true
git clone https://github.com/nana-4/materia-theme.git || { log "Failed to clone Materia theme repository"; exit 1; }
cd materia-theme || { log "Failed to cd to materia-theme"; exit 1; }
./install.sh || { log "Failed to install Materia theme"; exit 1; }

# Install Papirus icon theme as it goes well with Materia
log "Installing Papirus icon theme..."
sudo apt install -y papirus-icon-theme || { log "Failed to install Papirus icon theme"; exit 1; }

# Check if XFCE is actually installed and running
log "Checking XFCE installation..."
if ! command -v xfconf-query &> /dev/null; then
    log "xfconf-query not found. XFCE might not be installed correctly."
    log "Please install XFCE4 manually and run this script again."
    exit 1
fi

# Try to configure XFCE settings, but don't fail if not running in XFCE session
log "Attempting to configure XFCE settings..."
# We use || true to prevent script from exiting if these fail
(xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false) || log "Warning: Could not set dock shadow. You'll need to do this manually."
(xfconf-query -c xfwm4 -p /general/show_frame_shadow -s false) || log "Warning: Could not set frame shadow. You'll need to do this manually."
(xfconf-query -c xfwm4 -p /general/easy_click -s "") || log "Warning: Could not set easy_click. You'll need to do this manually."
(xfconf-query -c xsettings -p /Net/ThemeName -s "Materia") || log "Warning: Could not set theme. You'll need to do this manually."
(xfconf-query -c xfwm4 -p /general/theme -s "Materia") || log "Warning: Could not set window manager theme. You'll need to do this manually."
(xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus") || log "Warning: Could not set icon theme. You'll need to do this manually."

# Create a desktop entry for the settings if unable to set them now
log "Creating instructions for manual configuration if needed..."
mkdir -p ~/Desktop
cat > ~/Desktop/xfce-finish-setup.sh << 'EOF'
#!/bin/bash
# Run this script after logging into your XFCE session to complete configuration

# Fix shadow under panels in compositor settings
xfconf-query -c xfwm4 -p /general/show_dock_shadow -s false
xfconf-query -c xfwm4 -p /general/show_frame_shadow -s false

# Fix Alt/Super key issue
xfconf-query -c xfwm4 -p /general/easy_click -s ""

# Set Materia theme as default
xfconf-query -c xsettings -p /Net/ThemeName -s "Materia"
xfconf-query -c xfwm4 -p /general/theme -s "Materia"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"

echo "XFCE configuration completed!"
EOF
chmod +x ~/Desktop/xfce-finish-setup.sh

# Uninstall build dependencies as requested
log "Uninstalling build dependencies..."
sudo apt remove -y \
    sassc \
    libglib2.0-dev \
    libxml2-utils || log "Warning: Could not remove some build dependencies."

# Cleanup
log "Cleaning up..."
sudo apt autoremove -y || log "Warning: autoremove failed."
sudo apt autoclean || log "Warning: autoclean failed."

log "XFCE installation and configuration complete!"
log "Please log out and select XFCE session at the login screen."
log "If some settings were not applied automatically, run the script on your desktop after logging into XFCE."

exit 0
