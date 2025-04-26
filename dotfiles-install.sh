#!/bin/bash
set -e

copy_dir() {
  local src=$1 dest=$2
  echo "Moving ${src} files..."
  mkdir -p "${dest}" && cp -r "${src}/"* "${dest}/"
}

copy_file() {
  local src=$1 dest=$2
  local name=$(basename "$src")
  echo "Moving ${name} to ${dest}..."
  mkdir -p "${dest}" && cp "${src}" "${dest}/"
}

if [[ -d ".config" ]]; then
  cd ".config" || exit 1
  
  # Process config directories
  declare -A configs=(
    ["fish"]="~/.config/fish"
    ["rofi"]="~/.config/rofi"
    ["kitty"]="~/.config/kitty"
    ["neofetch"]="~/.config/neofetch"
  )
  
  for src in "${!configs[@]}"; do
    [[ -d "${src}" ]] && copy_dir "${src}" "${configs[$src]}" || echo "Warning: ${src} directory not found. Skipping..."
  done
  
  # Setup fish functions
  if [[ -d "fish" && -d "fish/functions" ]]; then
    echo "Setting up fish configuration..."
    mkdir -p ~/.config/fish/functions
    cp -r fish/functions/* ~/.config/fish/functions/
  fi
  
  echo "Dotfiles are copied!"
elif [[ -f "config.fish" ]]; then
  echo "Found single config.fish file. Setting up fish configuration..."
  fish_config_dir="$HOME/.config/fish"
  copy_file "config.fish" "${fish_config_dir}"
  mkdir -p "${fish_config_dir}/functions"
  echo "Fish configuration is set up!"
else
  echo "Error: Neither .config directory nor config.fish file found. Exiting."
  exit 1
fi

# Offer to change shell to fish
if command -v fish &>/dev/null; then
  read -p "Do you want to change your shell to fish? (y/n): " change_shell
  if [[ "$change_shell" =~ ^[Yy]$ ]]; then
    echo "Changing shell to fish requires sudo privileges."
    sudo chsh -s "$(which fish)" "$USER"
    echo "Shell changed to fish."
  else
    echo "Shell change skipped."
  fi
else
  echo "Warning: fish shell not found. Please install it first with your package manager."
fi