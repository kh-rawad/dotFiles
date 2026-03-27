
## install Fonts
echo "--- Installing Fonts"
if [[ $OSTYPE == 'darwin'* ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
elif is_termux; then
    pkg install -y fontconfig
    install_font_zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    # sudo apt install -y fonts-hack-nerd
    # Download and install FiraCode Nerd Font
    install_font_zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
fi
echo "--- Fonts installed successfully"