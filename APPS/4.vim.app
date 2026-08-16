#!/bin/bash
# install vim from sources if not version >=9 available in package manager
echo "--- Installing VIM"

# ── Version ───────────────────────────────────────────────────────────────────
# Minimum Vim version required locally.  The script skips the source build
# when the system or ~/.local/bin/vim already meets or exceeds this version.
VERSION="9.2"

if "$HOME/.local/bin/vim" -V 2>/dev/null | grep -q "VIM - Vi IMproved ${VERSION}"; then
    ## install vim-plug
    manual_install \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
        plug.vim \
        "$HOME/.vim/autoload"
fi
echo "--- Installing VIM Config"
cp -f ./vimrc "$HOME/.vimrc"
vim +'PlugInstall --sync' +qall &> /dev/null
sed -i 's/"colorscheme gruvbox/colorscheme gruvbox/' "$HOME/.vimrc"
echo "--- VIM Config installed successfully"
