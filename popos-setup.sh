#!/bin/bash

# Complete Pop!_OS System Setup Script - Optimized Version
# This script configures a Pop!_OS system with optimized settings and applications

# Record start time
start_time=$(date +%s)

# Color and formatting definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Create log file
LOG_FILE="/home/$SUDO_USER/Downloads/log.txt"
touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/popos_setup_log.txt"
echo "=== POP!_OS SYSTEM SETUP LOG - $(date) ===" > "$LOG_FILE"

# Array to track failures
declare -a failed_items=()

# Functions for display and logging
print_success() {
  local msg=$(echo "$1" | tr '[:lower:]' '[:upper:]')
  echo -e "${GREEN}[SUCCESS] $msg${NC}"
  echo "[SUCCESS] $msg" >> "$LOG_FILE"
}

print_error() {
  echo -e "${RED}[ERROR] $1${NC}"
  echo "[ERROR] $1" >> "$LOG_FILE"
}

print_info() {
  echo -e "${YELLOW}[INFO] $1${NC}"
  echo "[INFO] $1" >> "$LOG_FILE"
}

print_warning() {
  echo -e "${YELLOW}[WARNING] $1${NC}"
  echo "[WARNING] $1" >> "$LOG_FILE"
}

# Function to create a loading animation
show_loading() {
  local message="$1"
  local pid=$!
  
  echo -ne "${YELLOW}$message... ${NC}"
  echo "$message..." >> "$LOG_FILE"
  
  while kill -0 $pid 2>/dev/null; do
    echo -ne "${YELLOW}.${NC}"
    sleep 0.5
  done
  
  wait $pid
  if [ $? -eq 0 ]; then
    echo -e " ${GREEN}[DONE]${NC}"
    echo "[DONE]" >> "$LOG_FILE"
    return 0
  else
    echo -e " ${RED}[FAILED]${NC}"
    echo "[FAILED]" >> "$LOG_FILE"
    return 1
  fi
}

# Function to check if a package is already installed
is_package_installed() {
  local pkg_name="$1"
  if dpkg -l | grep -q "^ii  $pkg_name "; then
    return 0 # Package is installed
  else
    return 1 # Package is not installed
  fi
}

# Function to create autostart entry
create_autostart() {
  local name="$1"
  local exec_cmd="$2"
  local comment="$3"
  
  mkdir -p /etc/xdg/autostart || return 1
  cat > "/etc/xdg/autostart/${name}.desktop" << EOF
[Desktop Entry]
Name=$name
Exec=$exec_cmd
Terminal=false
Type=Application
Comment=$comment
Categories=Utility;
X-GNOME-Autostart-enabled=true
EOF
  if [ $? -eq 0 ]; then
    print_success "created autostart entry for $name"
    return 0
  else
    print_error "Failed to create autostart entry for $name"
    return 1
  fi
}

# Function to install packages with error handling
install_packages() {
  local pkg_list=("$@")
  local failed_pkgs=()
  
  for pkg in "${pkg_list[@]}"; do
    # Skip lsd package - we'll handle it separately
    if [ "$pkg" = "lsd" ]; then
      continue
    fi
    
    # Check if package is already installed
    if is_package_installed "$pkg"; then
      print_info "Package $pkg is already installed - skipping"
      continue
    fi
    
    print_info "Installing $pkg..."
    if apt-get install -y "$pkg" &>/dev/null; then
      print_success "$pkg installed"
    else
      print_error "Failed to install $pkg - skipping"
      failed_items+=("Package: $pkg")
      failed_pkgs+=("$pkg")
    fi
  done
  
  if [ ${#failed_pkgs[@]} -gt 0 ]; then
    print_warning "The following packages failed to install: ${failed_pkgs[*]}"
  fi
}

# Function to install lsd from GitHub releases
install_lsd_from_github() {
  # Check if lsd is already installed
  if is_package_installed "lsd"; then
    print_info "Package lsd is already installed - skipping"
    return 0
  fi
  
  print_info "Installing lsd from GitHub releases..."
  
  # Get the latest release version using GitHub API
  local latest_version=""
  if command -v curl &>/dev/null; then
    latest_version=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
  elif command -v wget &>/dev/null; then
    latest_version=$(wget -qO- https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
  else
    print_error "Neither curl nor wget is available. Installing curl..."
    apt-get install -y curl &>/dev/null
    if [ $? -eq 0 ]; then
      latest_version=$(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    else
      print_error "Failed to install curl. Using default lsd version."
      latest_version="v1.1.5"
    fi
  fi
  
  # Remove 'v' prefix if present
  latest_version=${latest_version#v}
  
  if [ -z "$latest_version" ]; then
    print_warning "Could not determine latest lsd version. Using default v1.1.5"
    latest_version="1.1.5"
  fi
  
  print_info "Latest lsd version: $latest_version"
  local lsd_url="https://github.com/lsd-rs/lsd/releases/download/v${latest_version}/lsd-musl_${latest_version}_amd64.deb"
  local lsd_deb="/tmp/lsd-musl_${latest_version}_amd64.deb"
  
  print_info "Downloading lsd from: $lsd_url"
  if wget -q "$lsd_url" -O "$lsd_deb" 2>/dev/null; then
    if apt-get install -y "$lsd_deb" &>/dev/null; then
      print_success "lsd $latest_version installed from GitHub"
      rm -f "$lsd_deb"
      return 0
    else
      print_error "Failed to install lsd package"
      failed_items+=("Package: lsd (GitHub)")
      rm -f "$lsd_deb"
      return 1
    fi
  else
    print_error "Failed to download lsd package from GitHub"
    failed_items+=("Package: lsd (GitHub download)")
    return 1
  fi
}

# Function to install flatpak apps with error handling
install_flatpak() {
  local app_id="$1"
  local app_name="$2"
  
  # Check if flatpak app is already installed
  if flatpak list | grep -q "$app_id"; then
    print_info "Flatpak $app_name ($app_id) is already installed - skipping"
    return 0
  fi
  
  print_info "Installing $app_name..."
  if flatpak install -y flathub "$app_id" &>/dev/null; then
    print_success "$app_name installed"
  else
    print_error "Failed to install $app_name - skipping"
    failed_items+=("Flatpak: $app_name ($app_id)")
  fi
}

# Function to download AppImages (without making them executable)
download_appimage() {
  local url="$1"
  local filename="$2"
  local downloads_dir="/home/$SUDO_USER/Downloads"
  
  # Ensure Downloads directory exists with correct permissions
  mkdir -p "$downloads_dir" 2>/dev/null || { 
    print_error "Failed to create $downloads_dir"
    return 1
  }
  
  # Check if AppImage already exists
  if [ -f "$downloads_dir/$filename" ]; then
    print_info "$filename already exists - skipping download"
    return 0
  fi
  
  print_info "Downloading $filename AppImage..."
  if wget -q "$url" -O "$downloads_dir/$filename" 2>/dev/null; then
    print_success "$filename downloaded"
    return 0
  else
    print_error "Failed to download $filename"
    failed_items+=("AppImage: $filename")
    return 1
  fi
}

# Function to detect Ubuntu version
detect_ubuntu_version() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" || "$ID" == "pop" || "$ID_LIKE" == *"ubuntu"* ]]; then
      echo "$VERSION_ID"
    else
      echo "unknown"
    fi
  else
    echo "unknown"
  fi
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  print_error "Please run this script with sudo privileges."
  exit 1
fi

# Welcome message
echo -e "===== POP!_OS SYSTEM SETUP SCRIPT ====="
print_info "Starting system configuration..."

# Get user choices with default values
read -p "Install development tools? (y/n): " -n 1 -r install_dev_tools
echo
dev_tools_confirmed=$([ "${install_dev_tools,,}" = "y" ] && echo true || echo false)

read -p "Remove default GNOME applications? (y/n): " -n 1 -r remove_gnome_apps
echo
remove_apps_confirmed=$([ "${remove_gnome_apps,,}" = "y" ] && echo true || echo false)

read -p "Install Flatpak applications? (y/n): " -n 1 -r install_flatpak_apps
echo
flatpak_confirmed=$([ "${install_flatpak_apps,,}" = "y" ] && echo true || echo false)

# Read a key to determine if lsd should be installed from GitHub
read -p "Press any key to install lsd from GitHub instead of the official repo (press Enter to install from the official repo): " -n 1 -r install_lsd_github
echo
lsd_github_confirmed=$([ -n "$install_lsd_github" ] && echo true || echo false)

# Update package lists
print_info "Updating package lists..."
{ apt-get update & } 2>/dev/null
show_loading "Updating package lists"
[ $? -eq 0 ] && print_success "package lists updated" || { 
  print_error "Package list update had issues, continuing with setup..."
  failed_items+=("Package list update")
}

# Configure APT
print_info "Configuring APT for optimal performance..."
cat > /etc/apt/apt.conf.d/99custom << EOF
APT::Install-Recommends "false";
APT::Install-Suggests "false";
APT::Get::Assume-Yes "true";
APT::Get::Fix-Broken "true";
APT::Acquire::Retries "3";
EOF
print_success "apt configuration complete"

# Update system first
print_info "Checking for updates..."
{ apt-get upgrade -y & } 2>/dev/null
show_loading "Updating system packages"
[ $? -eq 0 ] && print_success "system update complete" || { 
  print_error "System update had issues, continuing with setup..."
  failed_items+=("System updates")
}

# Install development tools (if confirmed)
if [ "$dev_tools_confirmed" = true ]; then
  print_info "Installing development tools..."
  
  # Check if build-essential is already installed
  if is_package_installed "build-essential"; then
    print_info "build-essential is already installed - skipping"
  else
    { apt-get install -y build-essential linux-headers-$(uname -r) & } 2>/dev/null
    show_loading "Installing build-essential and kernel headers"
  fi
  
  # Check for git and build tools
  dev_tools=("git" "cmake" "automake" "autoconf" "libtool" "pkg-config")
  missing_tools=()
  
  for tool in "${dev_tools[@]}"; do
    if ! is_package_installed "$tool"; then
      missing_tools+=("$tool")
    fi
  done
  
  if [ ${#missing_tools[@]} -gt 0 ]; then
    { apt-get install -y ${missing_tools[@]} & } 2>/dev/null
    show_loading "Installing ${missing_tools[*]}"
  else
    print_info "All build tools are already installed - skipping"
  fi
  
  print_success "development tools installation complete"
fi

# Remove default GNOME applications if requested
if [ "$remove_apps_confirmed" = true ]; then
  print_info "Removing default GNOME applications..."
  
  gnome_apps=(
    "gnome-calendar" "gnome-contacts" "gnome-maps" "gnome-photos" 
    "gnome-music" "gnome-weather" "cheese" "simple-scan" 
    "gnome-characters" "gnome-font-viewer" "evince"
    "totem" "rhythmbox" "shotwell"
  )
  
  for app in "${gnome_apps[@]}"; do
    if is_package_installed "$app"; then
      { apt-get remove -y "$app" & } 2>/dev/null 
      show_loading "Removing $app"
    else
      print_info "$app is not installed - skipping"
    fi
  done
  
  print_success "gnome applications removal complete"
fi

# Remove LibreOffice
print_info "Removing LibreOffice..."
libreoffice_pkgs=(
  "libreoffice-calc" "libreoffice-core" "libreoffice-common" 
  "libreoffice-draw" "libreoffice-impress" "libreoffice-math" 
  "libreoffice-writer" "libreoffice-gnome" "libreoffice-gtk3"
  "libreoffice-help-common" "libreoffice-help-en-us" "libreoffice-l10n-en-us"
  "libreoffice-style-*"
)

for pkg in "${libreoffice_pkgs[@]}"; do
  # Using dpkg-query instead of is_package_installed for wildcard support
  if dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -q "install ok installed"; then
    { apt-get remove -y $pkg & } 2>/dev/null
    show_loading "Removing $pkg"
  else
    print_info "$pkg is not installed - skipping"
  fi
done
print_success "libreoffice removal complete"

# Enable Flathub repo
print_info "Enabling Flathub repository..."
if flatpak remotes | grep -q "flathub"; then
  print_info "Flathub repository already enabled - skipping"
else
  { flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo & } 2>/dev/null
  show_loading "Adding Flathub repository"
fi
print_success "flathub repository enabled"

# Install additional repositories
print_info "Installing additional repositories and package sources..."

# Enable universe repository
if ! grep -q "^deb.*universe" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
  { apt-add-repository -y universe & } 2>/dev/null
  show_loading "Enabling Universe repository"
else
  print_info "Universe repository already enabled - skipping"
fi

# Enable multiverse repository
if ! grep -q "^deb.*multiverse" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
  { apt-add-repository -y multiverse & } 2>/dev/null
  show_loading "Enabling Multiverse repository"
else
  print_info "Multiverse repository already enabled - skipping"
fi

# Enable restricted repository
if ! grep -q "^deb.*restricted" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
  { apt-add-repository -y restricted & } 2>/dev/null
  show_loading "Enabling Restricted repository"
else
  print_info "Restricted repository already enabled - skipping"
fi

print_success "additional repositories enabled"

# Install media codecs
print_info "Installing media codecs..."
if ! is_package_installed "ubuntu-restricted-extras"; then
  { apt-get install -y ubuntu-restricted-extras & } 2>/dev/null
  show_loading "Installing Ubuntu restricted extras"
else
  print_info "ubuntu-restricted-extras already installed - skipping"
fi

gstreamer_pkgs=("gstreamer1.0-plugins-bad" "gstreamer1.0-plugins-ugly" "gstreamer1.0-plugins-good" "libavcodec-extra")
missing_gstreamer=()

for pkg in "${gstreamer_pkgs[@]}"; do
  if ! is_package_installed "$pkg"; then
    missing_gstreamer+=("$pkg")
  fi
done

if [ ${#missing_gstreamer[@]} -gt 0 ]; then
  { apt-get install -y ${missing_gstreamer[@]} & } 2>/dev/null
  show_loading "Installing GStreamer plugins"
else
  print_info "All GStreamer plugins already installed - skipping"
fi

print_success "media codecs installation complete"

# Enable preload
print_info "Setting up preload for faster application startup..."
if ! is_package_installed "preload"; then
  { apt-get install -y preload & } 2>/dev/null
  show_loading "Installing preload"
  
  # Start and enable preload service
  systemctl start preload &>/dev/null
  systemctl enable preload &>/dev/null
  print_success "preload setup complete"
else
  print_info "preload already installed - skipping"
  
  # Make sure the service is enabled
  if ! systemctl is-enabled preload &>/dev/null; then
    systemctl enable preload &>/dev/null
    print_info "Enabled preload service"
  fi
  
  print_success "preload already set up"
fi

# Install additional applications
print_info "Installing additional applications..."

# Define common packages
packages=(
  "lm-sensors"
  "adb"
  "fish"
  "git"
  "htop"
  "kitty"
  "micro"
  "neofetch"
  "nomacs"
  "papirus-icon-theme"
  "xclip"
  "duf"
  "psensor"
  "curl"
  "apt-transport-https"
  "gnupg"
  "dirmngr"
  "software-properties-common"
  "copyq"
)

# Add lsd to packages list if not installing from GitHub
if [ "$lsd_github_confirmed" = false ]; then
  packages+=("lsd")
fi

# Install packages individually for better error handling
print_info "Installing packages from the list..."
install_packages "${packages[@]}"

# Install lsd from GitHub if confirmed
if [ "$lsd_github_confirmed" = true ]; then
  install_lsd_from_github
fi

# Install Oh My Fish for fish shell
print_info "Installing Oh My Fish (OMF) for fish shell..."
if [ -n "$SUDO_USER" ]; then
  omf_config_dir="/home/$SUDO_USER/.config/omf"
  if [ -d "$omf_config_dir" ]; then
    print_info "Oh My Fish already installed for user $SUDO_USER - skipping"
  else
    { su - $SUDO_USER -c "curl -L https://get.oh-my.fish | fish" & } 2>/dev/null
    show_loading "Installing Oh My Fish for user $SUDO_USER"
    print_success "oh my fish installed for user $SUDO_USER"
  fi
else
  print_warning "Could not determine sudo user, skipping Oh My Fish installation"
  failed_items+=("Oh My Fish installation: Could not determine sudo user")
fi

# Install Google Chrome from official source
print_info "Installing Google Chrome from official source..."
if is_package_installed "google-chrome-stable"; then
  print_info "Google Chrome already installed - skipping"
else
  chrome_deb="google-chrome-stable_current_amd64.deb"
  if wget -q "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O "/tmp/$chrome_deb" 2>/dev/null; then
    { apt-get install -y "/tmp/$chrome_deb" & } 2>/dev/null
    show_loading "Installing Google Chrome"
    
    # Clean up the deb file
    rm -f "/tmp/$chrome_deb"
    
    print_success "google chrome installed"
  else
    print_error "Failed to download Google Chrome installer"
    failed_items+=("Google Chrome")
  fi
fi

# Install MEGA (native app)
print_info "Installing native MEGA app..."
if is_package_installed "megasync"; then
  print_info "MEGA already installed - skipping"
else
  # Detect Ubuntu version for appropriate MEGA package
  ubuntu_version=$(detect_ubuntu_version)
  print_info "Detected Ubuntu version: $ubuntu_version"

  echo "MEGA offers various installation versions. Please select one:"
  echo "1) Ubuntu 22.04 (Jammy)"
  echo "2) Ubuntu 20.04 (Focal)"
  echo "3) Ubuntu 18.04 (Bionic)"
  echo "4) Ubuntu 16.04 (Xenial)"
  read -p "Enter your choice (1-4): " mega_choice
  echo

  mega_url=""
  case $mega_choice in
    1) mega_url="https://mega.nz/linux/repo/xUbuntu_22.04/amd64/megasync-xUbuntu_22.04_amd64.deb" ;;
    2) mega_url="https://mega.nz/linux/repo/xUbuntu_20.04/amd64/megasync-xUbuntu_20.04_amd64.deb" ;;
    3) mega_url="https://mega.nz/linux/repo/xUbuntu_18.04/amd64/megasync-xUbuntu_18.04_amd64.deb" ;;
    4) mega_url="https://mega.nz/linux/repo/xUbuntu_16.04/amd64/megasync-xUbuntu_16.04_amd64.deb" ;;
    *) print_error "Invalid choice. Skipping MEGA installation."; failed_items+=("MEGA (native app)"); mega_url="" ;;
  esac

  if [ -n "$mega_url" ]; then
    mega_deb="megasync.deb"
    if wget -q "$mega_url" -O "/tmp/$mega_deb" 2>/dev/null; then
      { apt-get install -y "/tmp/$mega_deb" & } 2>/dev/null
      show_loading "Installing MEGA"
      
      # Clean up the deb file
      rm -f "/tmp/$mega_deb"
      
      print_success "mega installed"
    else
      print_error "Failed to download MEGA installer"
      failed_items+=("MEGA (native app)")
    fi
  fi
fi

# Install Flatpak applications if confirmed
if [ "$flatpak_confirmed" = true ]; then
  print_info "Installing Flatpak applications..."
  
  flatpak_apps=(
    "com.brave.Browser:Brave Browser"
    "org.libreoffice.LibreOffice:LibreOffice"
    "org.gnome.Papers:Papers"
    "net.epson.epsonscan2"
  )
  
  for app_info in "${flatpak_apps[@]}"; do
    IFS=':' read -r app_id app_name <<< "$app_info"
    install_flatpak "$app_id" "$app_name"
  done
  
  print_success "flatpak applications installation complete"
else
  print_info "Skipping Flatpak applications installation as per user choice."
fi

# Configure autostart for MEGA
print_info "Setting up autostart for MEGA..."
if [ -f "/etc/xdg/autostart/MegaSync.desktop" ]; then
  print_info "MEGA autostart already configured - skipping"
else
  create_autostart "MegaSync" "/usr/bin/megasync" "MEGA file synchronization"
fi

# Create user desktop entries for flatpak apps 
mkdir -p /etc/skel/.local/share/applications
print_success "created desktop entry directory for new users"

# Clean up residual packages
print_info "Cleaning up package residues..."
{ apt-get autoremove -y & } 2>/dev/null
show_loading "Removing unnecessary packages"

{ apt-get clean & } 2>/dev/null
show_loading "Cleaning package cache"

print_success "cleanup complete"

# Download AppImages to the Downloads folder
print_info "Downloading AppImages to the Downloads folder..."

# Ensure Downloads directory exists with correct permissions
downloads_dir="/home/$SUDO_USER/Downloads"
if [ -n "$SUDO_USER" ]; then
  mkdir -p "$downloads_dir" 2>/dev/null && chown $SUDO_USER:$SUDO_USER "$downloads_dir" 2>/dev/null
else
  print_error "Could not determine sudo user for Downloads directory"
  failed_items+=("AppImage downloads: Could not determine sudo user")
  # Fall back to root's Downloads directory
  downloads_dir="/root/Downloads"
  mkdir -p "$downloads_dir" 2>/dev/null
fi

# Download AppImages
download_appimage "https://todoist.com/linux_app/appimage" "Todoist.AppImage" 
download_appimage "https://github.com/parsify-dev/desktop/releases/download/v2.0.1/Parsify-2.0.1-linux-x86_64.AppImage" "Parsify-Calculator.AppImage"

# Set proper ownership for downloads
[ -n "$SUDO_USER" ] && chown -R $SUDO_USER:$SUDO_USER "$downloads_dir" 2>/dev/null

print_success "appimage downloads complete"

# Make AppImages executable
if [ -n "$SUDO_USER" ]; then
  find "$downloads_dir" -name "*.AppImage" -exec chmod +x {} \; 2>/dev/null
  print_success "appimages made executable"
fi

# Calculate end time and duration
end_time=$(date +%s)
duration=$((end_time - start_time))
minutes=$((duration / 60))
seconds=$((duration % 60))

# Summary
echo -e "===== SYSTEM SETUP COMPLETE ====="
echo -e "${GREEN}Your Pop!_OS system has been configured with:${NC}"
echo "- Optimized APT settings"
echo "- Universe, Multiverse, and Restricted repositories"
echo "- Flathub repository"
echo "- Media codecs"
echo "- Preload for faster application startup"
[ "$dev_tools_confirmed" = true ] && echo "- Development tools and libraries"
[ "$remove_apps_confirmed" = true ] && echo "- Removed default GNOME applications"
echo "- Removed LibreOffice (system version)"
echo "- Additional applications:"
echo "  * System utilities (fish with Oh My Fish, git, htop, etc.)"
[ "$lsd_github_confirmed" = true ] && echo "  * lsd (from GitHub releases)" || echo "  * lsd (from official repo)"
echo "  * Google Chrome"
echo "  * MEGA (native app)"
[ "$flatpak_confirmed" = true ] && echo "  * Flatpak apps (Dropbox, VLC, Brave, qBittorrent, LibreOffice, Papers)"
echo ""
echo "- Autostart configured for:"
echo "  * MegaSync"
echo ""
echo "- Downloaded AppImages to Downloads folder:"
echo "  * Todoist"
echo "  * Parsify Calculator"
echo ""
echo "- Log file created at: $LOG_FILE"

# Report any failed installations
if [ ${#failed_items[@]} -gt 0 ]; then
  echo -e "${RED}The following items failed to install:${NC}"
  for item in "${failed_items[@]}"; do
    echo -e "${RED}- $item${NC}"
  done
  echo -e "${YELLOW}Possible reasons for failures:${NC}"
  echo "- Package not available in configured repositories"
  echo "- Network connectivity issues"
  echo "- Dependency conflicts"
  echo "- Repository configuration errors"
  echo ""
else
  echo -e "${GREEN}ALL COMPONENTS WERE SUCCESSFULLY INSTALLED!${NC}"
fi

echo -e "${YELLOW}Total execution time: $minutes minutes and $seconds seconds${NC}"
echo "Total execution time: $minutes minutes and $seconds seconds" >> "$LOG_FILE"

echo -e "${YELLOW}INSTALLATION DONE. PLEASE REBOOT YOUR SYSTEM FOR ALL CHANGES TO TAKE EFFECT!${NC}"
echo -e "${YELLOW}Command to reboot: sudo reboot now${NC}"
