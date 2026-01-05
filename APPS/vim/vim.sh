#!/bin/bash

# Vim and vim-plug Installation Script
# Installs vim configuration and plugin manager

# Source functions for cross-platform utilities
source "$(dirname "$0")/../../setEnv"

echo "Installing Vim configuration and vim-plug..."

# Install vim-plug
echo "Installing vim-plug (Vim Plugin Manager)..."
manual_install \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    plug.vim \
    "$HOME/.vim/autoload"
[[ $? -ne 0 ]] && echo "Failed to install vim-plug" && exit 1

# Install vim config
echo "Installing VIM Config"
cp -f "$(dirname "$0")/vimrc" "$HOME/.vimrc"
[[ $? -ne 0 ]] && echo "Failed to install vimrc" && exit 1

# Install vim plugins
echo "Installing vim plugins..."
vim +'PlugInstall --sync' +qall &> /dev/null
[[ $? -ne 0 ]] && echo "Warning: Failed to install some vim plugins" || echo "Vim plugins installed successfully"

# Enable gruvbox colorscheme
echo "Enabling gruvbox colorscheme..."
sed -i 's/"colorscheme gruvbox/colorscheme gruvbox/' "$HOME/.vimrc"
[[ $? -ne 0 ]] && echo "Warning: Failed to enable gruvbox colorscheme"

echo "Vim installation completed successfully!"
echo "Features installed:"
echo "  - vim-plug (Vim Plugin Manager)"
echo "  - Custom vimrc configuration"
echo "  - Gruvbox colorscheme (enabled)"
echo "  - Various vim plugins"
echo ""
echo "To use vim:"
echo "  - Open files: 'vim <filename>'"
echo "  - Install more plugins: Add to vimrc and run ':PlugInstall' in vim"
echo "  - Update plugins: Run ':PlugUpdate' in vim"