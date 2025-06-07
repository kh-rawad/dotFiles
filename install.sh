#!/bin/bash

DOTFILES_FOLDER=~/.config/dotfiles
DEFAULT_SHELL='zsh'

# Get OS and architecture
get_os() {
    case "$OSTYPE" in
        darwin*)  echo "macos" ;;
        linux*)   echo "linux" ;;
        msys*|cygwin*|mingw*) echo "windows" ;;
        *)        echo "unknown" ;;
    esac
}

get_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64) echo "amd64" ;;
        i386|i686)    echo "i386" ;;
        arm64|aarch64) echo "arm64" ;;
        *)           echo "unknown" ;;
    esac
}

SYSTEM_INFO="$(get_os)-$(get_arch)"
echo "Detected system: $SYSTEM_INFO"

[[ -d $DOTFILES_FOLDER ]] && echo "DotFiles folder exsists continue" || mkdir -p $DOTFILES_FOLDER

# install dependencies
echo "Installing Dependencies"
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install vim duf curl wget git tmux
    [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    sudo apt update -y && sudo apt install -y vim exa duf curl wget git zsh tmux fonts-powerline 
    [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
fi

## installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 18
echo "NodeJS Version:" `node -v`
echo "NPM Version:" `npm -v`

## install Fonts
echo "Installing Fonts"
if [[ $OSTYPE == 'darwin'* ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    sudo apt install -y fonts-hack-nerd
fi
# Download and install FiraCode Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "FiraCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d FiraCode
fc-cache -fv
cd -

## install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
## install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

## install tmux plugins manager
echo "Installing Tmux Config"
cp -f tmux.conf ~/.tmux.conf
[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

## add k9s binary from GitHub
echo "Installing K9s"
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install derailed/k9s/k9s
elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    curl -sL https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb -o k9s.deb
    sudo dpkg -i k9s.deb
    rm -f k9s.deb
fi

## install vim-plug
echo "Installing Vim-Plug"
[[ ! -d ~/.vim/autoload ]] && mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Installing VIM Config"
cp -f vimrc ~/.vimrc
vim +'PlugInstall --sync' +qall &> /dev/null

## install fzf
echo "Installing FZF"
[[ ! -d ~/.fzf ]] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --no-completion --no-update-rc



## install yh (Yaml Highlighter)
echo "Installing YH"
curl -sL https://github.com/andreazorzetto/yh/releases/download/v0.4.0/yh-linux-amd64.zip -o yh.zip
unzip yh.zip
chmod +x yh
sudo mv yh /usr/local/bin
rm -f yh.zip

## set Default shell
chsh -s $(which zsh)

################################################################################################################
# install dotfiles
echo "Installing BashRC"
cp -f SHELLS/BASH/bashrc ~/.bashrc
echo "Installing ZshRC"
cp -f SHELLS/ZSH/zshrc ~/.zshrc
echo "Installing Aliases"
cp -f aliases $DOTFILES_FOLDER
echo "Installing Exports"
cp -f exports $DOTFILES_FOLDER
echo "Installing Functions"
cp -f functions $DOTFILES_FOLDER

# echo "Installing .Profile";
# [[ ! -f ~/.profile ]] && touch ~/.profile
# grep -q DOTFILES ~/.profile
# if [ $? -eq 1 ]; then
#     echo "Updating .profile"
#     cat <<EOT >> ~/.profile
# #[DOTFILES] execute .bashrc for non-login shells.
# if [ -n "\$BASH_VERSION" ]; then    
#     if [ -f "\$HOME/.bashrc" ]; then
#         . "\$HOME/.bashrc"
#     fi 
# fi
# #[DOTFILES]
# EOT
# else 
#     echo "please remove any [DOTFILES] lines in [~/.profile] before update" 
# fi