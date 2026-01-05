#!/bin/bash

# Fonts Installation Script
# Installs Nerd Fonts for enhanced terminal experience

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing Nerd Fonts..."

if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS installation via Homebrew
    if command -v brew &> /dev/null; then
        echo "Installing Nerd Font via Homebrew..."
        brew tap homebrew/cask-fonts
        brew install --cask font-hack-nerd-font
        [[ $? -ne 0 ]] && echo "Failed to install font via brew" && exit 1
    else
        echo "Homebrew not found. Please install Homebrew first."
        exit 1
    fi
else
    # Linux/other platforms - use install_font_zip function
    echo "Installing FiraCode Nerd Font via direct download..."
    install_font_zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    [[ $? -ne 0 ]] && echo "Failed to install FiraCode Nerd Font" && exit 1
fi

echo "Fonts installation completed successfully!"
echo "You may need to restart your terminal or select the new font in your terminal settings."
echo "Available fonts: Hack Nerd Font (macOS), FiraCode Nerd Font (Linux)"