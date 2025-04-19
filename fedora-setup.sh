#!/bin/bash

# Complete Fedora System Setup Script - Optimized Version
# This script configures a Fedora Linux system with optimized settings and applications

# Record start time
start_time=$(date +%s)

# Color and formatting definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Create log file
LOG_FILE="/home/$SUDO_USER/Downloads/log.txt"
touch "$LOG_FILE" 2>/dev/null || LOG_FILE="/tmp/fedora_setup_log.txt"
echo "=== FEDORA SYSTEM SETUP LOG - $(date) ===" > "$LOG_FILE"

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

print_skip() {
  local msg=$(echo "$1" | tr '[:lower:]' '[:upper:]')
  echo -e "${YELLOW}[SKIP] $msg${NC}"
  echo "[SKIP] $msg" >> "$LOG_FILE"
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
  if rpm -q "$pkg_name" &>/dev/null; then
    return 0  # Package is installed
  else
    return 1  # Package is not installed
  fi
}

# Function to check if a repository is enabled
is_repo_enabled() {
  local repo_name="$1"
  if dnf repolist enabled | grep -q "$repo_name"; then
    return 0  # Repo is enabled
  else
    return 1  # Repo is not enabled
  fi
}

# Function to check if a flatpak app is installed
is_flatpak_installed() {
  local app_id="$1"
  if flatpak list --app | grep -q "$app_id"; then
    return 0  # Flatpak app is installed
  else
    return 1  # Flatpak app is not installed
  fi
}

# Function to check if a file exists
file_exists() {
  local filepath="$1"
  if [ -f "$filepath" ]; then
    return 0  # File exists
  else
    return 1  # File does not exist
  fi
}

# Function to create autostart entry
create_autostart() {
  local name="$1"
  local exec_cmd="$2"
  local comment="$3"
  local desktop_file="/etc/xdg/autostart/${name}.desktop"
  
  # Check if autostart file already exists
  if file_exists "$desktop_file"; then
    print_skip "autostart entry for $name already exists"
    return 0
  fi
  
  mkdir -p /etc/xdg/autostart || return 1
  cat > "$desktop_file" << EOF
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
    if is_package_installed "$pkg"; then
      print_skip "$pkg is already installed"
      continue
    fi
    
    print_info "Installing $pkg..."
    if $DNF_CMD install -y --skip-unavailable "$pkg" &>/dev/null; then
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

# Function to install flatpak apps with error handling
install_flatpak() {
  local app_id="$1"
  local app_name="$2"
  
  if is_flatpak_installed "$app_id"; then
    print_skip "$app_name flatpak is already installed"
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
  if file_exists "$downloads_dir/$filename"; then
    print_skip "$filename already exists in Downloads folder"
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

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  print_error "Please run this script with sudo privileges."
  exit 1
fi

# Detect DNF version and adapt commands accordingly
DNF_CMD="dnf"
if command -v dnf5 &> /dev/null; then
  print_info "DNF5 detected, adapting commands..."
  DNF_CMD="dnf5"
  GROUP_UPDATE_CMD="group install"
else
  GROUP_UPDATE_CMD="groupupdate"
fi

# Welcome message
echo -e "===== FEDORA SYSTEM SETUP SCRIPT ====="
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

# Configure DNF
print_info "Configuring DNF for optimal performance..."
# Check if DNF is already configured with our settings
if grep -q "max_parallel_downloads=10" /etc/dnf/dnf.conf &&
   grep -q "fastestmirror=True" /etc/dnf/dnf.conf &&
   grep -q "keepcache=True" /etc/dnf/dnf.conf; then
  print_skip "dnf is already optimally configured"
else
  cat > /etc/dnf/dnf.conf << EOF
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=True
max_parallel_downloads=10
defaultyes=True
keepcache=True
EOF
  print_success "dnf configuration complete"
fi

# Update system first
print_info "Checking for updates..."
{ $DNF_CMD update -y --skip-unavailable &>/dev/null & }
show_loading "Updating system"
[ $? -eq 0 ] && print_success "system update complete" || { 
  print_error "System update had issues, continuing with setup..."
  failed_items+=("System updates")
}

# Install development tools (if confirmed)
if [ "$dev_tools_confirmed" = true ]; then
  print_info "Installing development tools..."
  
  # Check if kernel headers and development packages are already installed
  if is_package_installed "kernel-headers" && is_package_installed "kernel-devel"; then
    print_skip "kernel headers and devel are already installed"
  else
    { $DNF_CMD install -y --skip-unavailable kernel-headers kernel-devel &>/dev/null & }
    show_loading "Installing kernel headers and devel"
  fi
  
  # Check if C Development Tools are installed
  # We can't easily check for group installation, so we'll check for common packages
  if is_package_installed "gcc" && is_package_installed "make" && is_package_installed "glibc-devel"; then
    print_skip "C Development Tools appear to be already installed"
  else
    { $DNF_CMD group install -y --skip-unavailable "C Development Tools and Libraries" &>/dev/null & }
    show_loading "Installing C Development Tools"
  fi
  
  print_success "development tools installation complete"
fi

# Remove default GNOME applications if requested
if [ "$remove_apps_confirmed" = true ]; then
  print_info "Removing default GNOME applications..."
  
  gnome_apps=(
    "gnome-boxes" "gnome-contacts" "gnome-maps" "gnome-photos" 
    "gnome-tour" "gnome-weather" "gnome-connections" "totem" 
    "cheese" "gnome-logs" "simple-scan" "gnome-characters" 
    "gnome-font-viewer" "evince"
  )
  
  for app in "${gnome_apps[@]}"; do
    if is_package_installed "$app"; then
      { $DNF_CMD remove -y "$app" &>/dev/null & }
      show_loading "Removing $app"
    else
      print_skip "$app is not installed"
    fi
  done
  
  print_success "gnome applications removal complete"
fi

# Remove LibreOffice
print_info "Removing LibreOffice..."
libreoffice_pkgs=(
  "libreoffice-calc" "libreoffice-core" "libreoffice-data" 
  "libreoffice-draw" "libreoffice-emailmerge" "libreoffice-graphicfilter" 
  "libreoffice-impress" "libreoffice-math" "libreoffice-writer"
  "libreoffice-x11" "libreoffice-xsltfilter" "libreoffice-filters"
  "libreoffice-base"
)

libreoffice_removed=false
for pkg in "${libreoffice_pkgs[@]}"; do
  if is_package_installed "$pkg"; then
    { $DNF_CMD remove -y "$pkg" &>/dev/null & }
    show_loading "Removing $pkg"
    libreoffice_removed=true
  else
    print_skip "$pkg is not installed"
  fi
done

if [ "$libreoffice_removed" = true ]; then
  print_success "libreoffice removal complete"
else
  print_skip "no libreoffice packages were found to remove"
fi

# Enable RPM Fusion repositories
print_info "Enabling RPM Fusion repositories..."

# Check if RPM Fusion Free is already enabled
if is_repo_enabled "rpmfusion-free"; then
  print_skip "rpmfusion-free repository is already enabled"
else
  { $DNF_CMD install -y --skip-unavailable https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm &>/dev/null & }
  show_loading "Enabling RPM Fusion Free"
fi

# Check if RPM Fusion NonFree is already enabled
if is_repo_enabled "rpmfusion-nonfree"; then
  print_skip "rpmfusion-nonfree repository is already enabled"
else
  { $DNF_CMD install -y --skip-unavailable https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &>/dev/null & }
  show_loading "Enabling RPM Fusion Non-Free"
fi

{ $DNF_CMD $GROUP_UPDATE_CMD -y --skip-unavailable core &>/dev/null & }
show_loading "Updating core group"

print_success "rpm fusion repositories setup complete"

# Enable Flathub repo
print_info "Checking Flathub repository..."
if flatpak remotes | grep -q "flathub"; then
  print_skip "flathub repository is already enabled"
else
  print_info "Enabling Flathub repository..."
  { flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null & }
  show_loading "Adding Flathub repository"
  print_success "flathub repository enabled"
fi

# Enable media codecs
print_info "Installing media codecs..."
# Since we cannot easily check if media codecs are installed, we'll just install them
if [ "$DNF_CMD" = "dnf5" ]; then
  { $DNF_CMD group install -y --skip-unavailable multimedia &>/dev/null & }
  show_loading "Installing multimedia codecs"
  
  { $DNF_CMD group install -y --skip-unavailable sound-and-video &>/dev/null & }
  show_loading "Installing sound and video codecs"
else
  { $DNF_CMD groupupdate -y --skip-unavailable multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin &>/dev/null & }
  show_loading "Installing multimedia codecs"
  
  { $DNF_CMD groupupdate -y --skip-unavailable sound-and-video &>/dev/null & }
  show_loading "Installing sound and video codecs"
fi
print_success "media codecs installation complete"

# Enable preload
print_info "Setting up preload for faster application startup..."
if is_package_installed "preload"; then
  print_skip "preload is already installed"
else
  { $DNF_CMD copr enable -y elxreno/preload &>/dev/null & }
  show_loading "Enabling preload copr repository"

  { $DNF_CMD install -y --skip-unavailable preload &>/dev/null & }
  show_loading "Installing preload"

  # Start and enable preload service
  systemctl start preload &>/dev/null
  systemctl enable preload &>/dev/null
  print_success "preload setup complete"
fi

# Install additional applications
print_info "Installing additional applications..."

# Define common packages
packages=(
  "lm_sensors-libs"
  "android-tools"
  "fish"
  "git"
  "htop"
  "kitty"
  "lsd"
  "micro"
  "neofetch"
  "nomacs"
  "papirus-icon-theme"
  "xclip"
  "gnome-tweaks"
  "duf"
  "psensor"
  "curl"
  "fuse"
  "fuse-libs"
)

# Install packages individually for better error handling
print_info "Installing packages from the list..."
install_packages "${packages[@]}"

# Install Oh My Fish for fish shell
print_info "Checking for Oh My Fish (OMF) installation..."
omf_installed=false
if [ -n "$SUDO_USER" ]; then
  omf_dir="/home/$SUDO_USER/.local/share/omf"
  if [ -d "$omf_dir" ]; then
    print_skip "oh my fish is already installed for user $SUDO_USER"
    omf_installed=true
  else
    print_info "Installing Oh My Fish (OMF) for fish shell..."
    { su - $SUDO_USER -c "curl -L https://get.oh-my.fish | fish" &>/dev/null & }
    show_loading "Installing Oh My Fish for user $SUDO_USER"
    print_success "oh my fish installed for user $SUDO_USER"
    omf_installed=true
  fi
else
  print_warning "Could not determine sudo user, skipping Oh My Fish installation"
  failed_items+=("Oh My Fish installation: Could not determine sudo user")
fi

# Install Google Chrome from official source
print_info "Checking for Google Chrome..."
if is_package_installed "google-chrome-stable"; then
  print_skip "google chrome is already installed"
else
  print_info "Installing Google Chrome from official source..."
  chrome_rpm="google-chrome-stable_current_x86_64.rpm"
  if wget -q "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm" -O "/tmp/$chrome_rpm" 2>/dev/null; then
    { $DNF_CMD install -y --skip-unavailable "/tmp/$chrome_rpm" &>/dev/null & }
    show_loading "Installing Google Chrome"
    
    # Clean up the RPM file
    rm -f "/tmp/$chrome_rpm"
    
    print_success "google chrome installed"
  else
    print_error "Failed to download Google Chrome installer"
    failed_items+=("Google Chrome")
  fi
fi

# Install MEGA (native app)
print_info "Checking for MEGA..."
if is_package_installed "megasync"; then
  print_skip "mega is already installed"
else
  print_info "Installing native MEGA app..."
  mega_rpm="megasync-Fedora_42.x86_64.rpm"
  if wget -q "https://mega.nz/linux/repo/Fedora_42/x86_64/$mega_rpm" -O "/tmp/$mega_rpm" 2>/dev/null; then
    { $DNF_CMD install -y --skip-unavailable "/tmp/$mega_rpm" &>/dev/null & }
    show_loading "Installing MEGA"
    
    # Clean up the RPM file
    rm -f "/tmp/$mega_rpm"
    
    print_success "mega installed"
  else
    print_error "Failed to download MEGA installer"
    failed_items+=("MEGA (native app)")
  fi
fi

# Install Flatpak applications if confirmed
if [ "$flatpak_confirmed" = true ]; then
  print_info "Installing Flatpak applications..."
  
  flatpak_apps=(
    "com.dropbox.Client:Dropbox"
    "org.videolan.VLC:VLC"
    "com.brave.Browser:Brave Browser"
    "org.qbittorrent.qBittorrent:qBittorrent"
    "org.libreoffice.LibreOffice:LibreOffice"
    "org.gnome.Papers:GNOME Papers"
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
create_autostart "MegaSync" "/usr/bin/megasync" "MEGA file synchronization"

# Create user desktop entries for flatpak apps 
if [ ! -d "/etc/skel/.local/share/applications" ]; then
  mkdir -p /etc/skel/.local/share/applications
  print_success "created desktop entry directory for new users"
else
  print_skip "desktop entry directory for new users already exists"
fi

# Clean up residual packages
print_info "Cleaning up package residues..."
{ $DNF_CMD autoremove -y &>/dev/null & }
show_loading "Removing unnecessary packages"

{ $DNF_CMD clean all &>/dev/null & }
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

# Calculate end time and duration
end_time=$(date +%s)
duration=$((end_time - start_time))
minutes=$((duration / 60))
seconds=$((duration % 60))

# Summary
echo -e "===== SYSTEM SETUP COMPLETE ====="
echo -e "${GREEN}Your Fedora system has been configured with:${NC}"
echo "- Optimized DNF settings"
echo "- RPM Fusion repositories (free and nonfree)"
echo "- Flathub repository"
echo "- Media codecs"
echo "- Preload for faster application startup"
[ "$dev_tools_confirmed" = true ] && echo "- Development tools and libraries"
[ "$remove_apps_confirmed" = true ] && echo "- Removed default GNOME applications"
echo "- Removed LibreOffice (system version)"
echo "- Additional applications:"
echo "  * System utilities (fish with Oh My Fish, git, htop, etc.)"
echo "  * Google Chrome"
echo "  * MEGA (native app)"
echo "  * FUSE and FUSE libraries"
[ "$flatpak_confirmed" = true ] && echo "  * Flatpak apps (Dropbox, VLC, Brave, qBittorrent, LibreOffice, GNOME Papers)"
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
