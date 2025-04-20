#!/bin/bash

# Exit immediately if a command fails
set -e

# Function to handle directory creation and file copying
copy_config() {
    local src_dir=$1
    local dest_dir=$2

    echo "Moving ${src_dir} files..."
    mkdir -p "${dest_dir}"
    cp -r "${src_dir}/"* "${dest_dir}/"
}

# Function to handle single file copying
copy_single_file() {
    local src_file=$1
    local dest_dir=$2
    local file_name=$(basename "$src_file")

    echo "Moving ${file_name} to ${dest_dir}..."
    mkdir -p "${dest_dir}"
    cp "${src_file}" "${dest_dir}/"
    echo "${file_name} copied to ${dest_dir}/"
}

# Check if we have the dotfiles structure or just a single config.fish file
if [[ -d ".config" ]]; then
    # Original dotfiles structure
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

    # Commented out plank theme copying
    # if [[ -d "plank" ]]; then
    #     echo "Moving plank files..."
    #     mkdir -p ~/.local/share/plank
    #     cp -r plank/themes/ ~/.local/share/plank/
    # else
    #     echo "Warning: plank directory not found. Skipping..."
    # fi

    # Make sure fish config is properly set up for aliases
    if [[ -d "fish" ]]; then
        echo "Setting up fish configuration..."
        mkdir -p ~/.config/fish/functions
        if [[ -d "fish/functions" ]]; then
            cp -r fish/functions/* ~/.config/fish/functions/
        fi
    fi

    echo "Dotfiles are copied!"
elif [[ -f "config.fish" ]]; then
    # Single fish config file scenario
    echo "Found single config.fish file. Setting up fish configuration..."
    fish_config_dir="$HOME/.config/fish"
    
    # Copy the fish config file
    copy_single_file "config.fish" "${fish_config_dir}"
    
    # Create functions directory for aliases
    mkdir -p "${fish_config_dir}/functions"
    echo "Created fish functions directory for aliases"
    
    echo "Fish configuration is set up!"
else
    echo "Error: Neither .config directory nor config.fish file found. Exiting."
    exit 1
fi

# Ask if user wants to change shell to fish
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