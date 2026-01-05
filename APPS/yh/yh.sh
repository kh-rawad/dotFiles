#!/bin/bash

# YH (YAML Highlighter) Installation Script
# YH is a command-line tool for syntax highlighting YAML files

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing YH (YAML Highlighter)..."

if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS installation via Homebrew
    if command -v brew &> /dev/null; then
        echo "Installing yh via Homebrew..."
        brew install yh
        [[ $? -ne 0 ]] && echo "Failed to install yh via brew" && exit 1
    else
        echo "Homebrew not found. Installing via direct download..."
        manual_install \
            https://github.com/andreazorzetto/yh/releases/download/v0.4.0/yh-$(get_os)-$(get_arch).zip \
            yh \
            "$HOME/.local/bin" \
            executable
        [[ $? -ne 0 ]] && echo "Failed to install yh" && exit 1
    fi
else
    # Linux/other platforms - use manual_install function
    echo "Installing yh via direct download..."
    manual_install \
        https://github.com/andreazorzetto/yh/releases/download/v0.4.0/yh-$(get_os)-$(get_arch).zip \
        yh \
        "$HOME/.local/bin" \
        executable
    [[ $? -ne 0 ]] && echo "Failed to install yh" && exit 1
fi

echo "YH installation completed successfully!"
echo "Run 'yh <yaml-file>' to highlight YAML syntax"