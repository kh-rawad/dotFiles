#!/bin/bash

# FZF (Fuzzy Finder) Installation Script
# FZF is a general-purpose command-line fuzzy finder

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing FZF (Fuzzy Finder)..."

if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS installation via Homebrew
    if command -v brew &> /dev/null; then
        echo "Installing fzf via Homebrew..."
        brew install fzf
        [[ $? -ne 0 ]] && echo "Failed to install fzf via brew" && exit 1
    else
        echo "Homebrew not found. Please install Homebrew first."
        exit 1
    fi
else
    # Linux/other platforms - use run_install_script function
    echo "Installing fzf via direct download and setup..."
    run_install_script \
        https://github.com/junegunn/fzf.git \
        $HOME/.fzf \
        "./install --key-bindings --completion --no-update-rc --xdg"
    [[ $? -ne 0 ]] && echo "Failed to install fzf" && exit 1
fi

echo "FZF installation completed successfully!"
echo "Features installed:"
echo "  - fzf command-line fuzzy finder"
echo "  - Key bindings (Ctrl+R for history, Ctrl+T for files)"
echo "  - Tab completion support"
echo ""
echo "Try 'fzf --help' to see usage options"
