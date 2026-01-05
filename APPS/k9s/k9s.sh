#!/bin/bash

# K9s Kubernetes CLI Installation Script
# K9s provides a terminal UI to interact with your Kubernetes clusters

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"
INSTALL_VERSION="v0.50.6"
echo "Installing K9s Kubernetes CLI..."

if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS installation via Homebrew
    if command -v brew &> /dev/null; then
        echo "Installing k9s via Homebrew..."
        brew install derailed/k9s/k9s
        [[ $? -ne 0 ]] && echo "Failed to install k9s via brew" && exit 1
    else
        echo "Homebrew not found. Please install Homebrew first."
        exit 1
    fi
else
    # Linux/other platforms - use manual_install function
    echo "Installing k9s via direct download..."
    manual_install \
        https://github.com/derailed/k9s/releases/download/$INSTALL_VERSION/k9s_$(get_os)_$(get_arch).tar.gz \
        k9s \
        "$HOME/.local/bin" \
        executable
    [[ $? -ne 0 ]] && echo "Failed to install k9s" && exit 1
fi

echo "K9s installation completed successfully!"
echo "Run 'k9s' to start the Kubernetes terminal UI"