#!/bin/bash

# Oh My Zsh Installation Script
# Installs Oh My Zsh framework and useful plugins for enhanced Zsh experience

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing Oh My Zsh and plugins..."

# Install Oh My Zsh
echo "Installing Oh My Zsh framework..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    [[ $? -ne 0 ]] && echo "Failed to install Oh My Zsh" && exit 1
else
    echo "Oh My Zsh already installed, skipping..."
fi

# Install zsh-autosuggestions plugin
echo "Installing zsh-autosuggestions plugin..."
ZSH_CUSTOM_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
AUTOSUGGESTIONS_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"

if [ -d "$AUTOSUGGESTIONS_DIR" ]; then
    echo "Updating existing zsh-autosuggestions..."
    rm -rf "$AUTOSUGGESTIONS_DIR"
fi

git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGESTIONS_DIR"
[[ $? -ne 0 ]] && echo "Failed to install zsh-autosuggestions" && exit 1

echo "Oh My Zsh installation completed successfully!"
echo "Features installed:"
echo "  - Oh My Zsh framework with bira theme"
echo "  - zsh-autosuggestions plugin"
echo ""
echo "To activate, restart your terminal or run 'source ~/.zshrc'"
echo "Make sure 'zsh-autosuggestions' is in your plugins list in ~/.zshrc"