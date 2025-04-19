#!/bin/bash

# Exit immediately if a command fails
set -e

# Function to handle directory creation and file copying
copy_config() {
    local src_dir=$1
    local dest_dir=$2

    echo "Moving ${src_dir} files..."
    mkdir -p "${dest_dir}"
    cp -r "${src_dir}/" "${dest_dir}"
}

# Change shell to fish if it's available
if command -v fish &>/dev/null; then
    chsh -s "$(which fish)"
else
    echo "Warning: fish shell not found. Skipping shell change."
fi

# Move to .config directory if it exists
if [[ -d ".config" ]]; then
    cd ".config" || exit 1

    # Array of config directories to copy
    configs=(
        "fish:~/.config/fish"
        "rofi:~/.config/rofi"
        "kitty:~/.config/kitty"
        "neofetch:~/.config/neofetch"
    )

    # Copy each config
    for config in "${configs[@]}"; do
        IFS=':' read -r src dest <<< "${config}"
        if [[ -d "${src}" ]]; then
            copy_config "${src}" "${dest}"
        else
            echo "Warning: ${src} directory not found. Skipping..."
        fi
    done

    # Handle plank separately as it has a different path
    if [[ -d "plank" ]]; then
        echo "Moving plank files..."
        mkdir -p ~/.local/share/plank
        cp -r plank/themes/ ~/.local/share/plank/
    else
        echo "Warning: plank directory not found. Skipping..."
    fi

    echo "Dotfiles are copied!"
else
    echo "Error: .config directory not found. Exiting."
    exit 1
fi