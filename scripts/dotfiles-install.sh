#!/bin/bash
set -e

copy_dir() {
  local src=$1 dest=$2
  echo "Moving ${src} files..."
  mkdir -p "${dest}" && cp -r "${src}/." "${dest}/"
}

copy_file() {
  local src=$1 dest=$2
  local name
  name=$(basename "$src")
  echo "Moving ${name} to ${dest}..."
  mkdir -p "${dest}" && cp "${src}" "${dest}/"
}

if [[ -d ".config" ]]; then
  cd ".config" || exit 1

  # Process config directories
  declare -A configs=(
    ["fish"]="$HOME/.config/fish"
    ["rofi"]="$HOME/.config/rofi"
    ["kitty"]="$HOME/.config/kitty"
    ["neofetch"]="$HOME/.config/neofetch"
    ["wezterm"]="$HOME/.config/wezterm"
  )

  for src in "${!configs[@]}"; do
    [[ -d "${src}" ]] && copy_dir "${src}" "${configs[$src]}" || echo "Warning: ${src} directory not found. Skipping..."
  done

  # Setup fish functions
  if [[ -d "fish" && -d "fish/functions" ]]; then
    echo "Setting up fish configuration..."
    mkdir -p "$HOME/.config/fish/functions"
    cp -r fish/functions/. "$HOME/.config/fish/functions/"
  fi

  echo "Dotfiles are copied!"
elif [[ -f "config.fish" || -f "wezterm.lua" ]]; then
  # Handle individual config files
  [[ -f "config.fish" ]] && copy_file "config.fish" "$HOME/.config/fish"

  if [[ -f "wezterm.lua" ]]; then
    echo "Found wezterm.lua file. Setting up wezterm configuration..."
    copy_file "wezterm.lua" "$HOME/.config/wezterm"
  fi

  # Ensure fish functions directory exists if config.fish was found
  [[ -f "config.fish" ]] && mkdir -p "$HOME/.config/fish/functions"

  echo "Configuration files are set up!"
else
  echo "Error: No configuration files or directories found. Exiting."
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
