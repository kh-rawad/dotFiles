#!/bin/bash

# Tmux and TPM (Tmux Plugin Manager) Installation Script
# Installs tmux configuration and the plugin manager

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing Tmux configuration and plugins..."

# Install tmux config
echo "Installing Tmux Config"
cp -f "$(dirname "$0")/tmux.conf" "$HOME/.tmux.conf"
[[ $? -ne 0 ]] && echo "Failed to install tmux config" && exit 1

# Install TPM (Tmux Plugin Manager)
echo "Installing Tmux Plugin Manager (TPM)..."
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    [[ $? -ne 0 ]] && echo "Failed to install TPM" && exit 1
else
    echo "TPM already installed, updating..."
    cd "$HOME/.tmux/plugins/tpm" && git pull
fi

# Install plugins
echo "Installing tmux plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
[[ $? -ne 0 ]] && echo "Failed to install tmux plugins" && exit 1

echo "Tmux installation completed successfully!"
echo "Features installed:"
echo "  - Tmux configuration with custom keybindings (Ctrl+Space prefix)"
echo "  - TPM (Tmux Plugin Manager)"
echo "  - tmux-sensible plugin"
echo "  - tmux-fzf plugin"
echo ""
echo "To use tmux:"
echo "  - Start a session: 'tmux' or 'tmux new-session -s <session-name>'"
echo "  - Prefix key is Ctrl+Space (not default Ctrl+b)"
echo "  - Install more plugins: Add to tmux.conf and run Prefix + I"