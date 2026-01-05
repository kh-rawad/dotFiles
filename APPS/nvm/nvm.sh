#!/bin/bash

# NVM (Node Version Manager) Installation Script
# NVM allows you to install and manage multiple Node.js versions

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing NVM (Node Version Manager)..."

# Install NVM
echo "Downloading and installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
[[ $? -ne 0 ]] && echo "Failed to install NVM" && exit 1

# Source NVM to make it available in current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install Node.js LTS version
echo "Installing Node.js LTS version..."
nvm install --lts
[[ $? -ne 0 ]] && echo "Failed to install Node.js" && exit 1

# Use the LTS version as default
nvm use --lts
nvm alias default lts/*

echo "NVM installation completed successfully!"
echo "Node.js Version: $(node -v 2>/dev/null || echo 'Not available in current session')"
echo "NPM Version: $(npm -v 2>/dev/null || echo 'Not available in current session')"
echo ""
echo "Note: Restart your terminal or run 'source ~/.bashrc' (or ~/.zshrc) to use nvm commands."
echo "Then run 'nvm use --lts' to activate Node.js."