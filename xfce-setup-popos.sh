#!/bin/bash

# Define color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Log function for consistent output with color
log() {
    echo -e "${YELLOW}$(date '+%Y-%m-%d %H:%M:%S') - $1${NC}"
}

# Error log function with red color
error_log() {
    echo -e "${RED}$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1${NC}"
}

# Success log function with green color
success_log() {
    echo -e "${GREEN}$(date '+%Y-%m-%d %H:%M:%S') - $1${NC}"
}

# Error handling function
handle_error() {
    error_log "An error occurred at line $1"
    exit 1
}

# Set up error handling
trap 'handle_error $LINENO' ERR

# Check if script is run as root and refuse if so
if [ "$(id -u)" = "0" ]; then
    error_log "This script should not be run as root or with sudo directly."
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
sudo apt update || { error_log "Failed to update package lists"; exit 1; }
sudo apt upgrade -y || { error_log "Failed to upgrade packages"; exit 1; }

# Install minimal XFCE setup without unnecessary applications
log "Installing minimal XFCE desktop environment..."
sudo apt install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xfce4-whiskermenu-plugin \
    flameshot \
    thunar || { error_log "Failed to install XFCE packages"; exit 1; }

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

# Install Materia theme and Papirus icon theme from repositories
log "Installing Materia theme and Papirus icon theme from official repositories..."
sudo apt install -y \
    materia-gtk-theme \
    papirus-icon-theme || { error_log "Failed to install themes"; exit 1; }

# Create directory for XFCE config if needed
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml/

# Cleanup
log "Cleaning up..."
sudo apt autoremove -y || log "Warning: autoremove failed."
sudo apt autoclean || log "Warning: autoclean failed."

success_log "XFCE installation and configuration complete!"
log "Please log out and select XFCE session at the login screen."
log "You will need to manually configure Alt key behavior and panel shadows after login."

exit 0