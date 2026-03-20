#!/bin/bash

source "$(dirname "$0")/setEnv"

echo "Detected system: $SYSTEM_INFO"
if [[ -z "${SYSTEM_INFO:-}" ]]; then
    echo "System information not detected. Please set SYSTEM_INFO in setEnv file."
    exit 1
fi


# Create the dotfiles folder if it doesn't exist
[[ -d "$DOTFILES_FOLDER" ]] && echo "DotFiles folder exists continue" || mkdir -p "$DOTFILES_FOLDER"
# install dotfiles
echo "Installing BashRC"
cp -f SHELLS/BASH/bashrc "$HOME/.bashrc"
echo "Installing ZshRC"
cp -f SHELLS/ZSH/zshrc "$HOME/.zshrc"
echo "Installing Aliases"
cp -f aliases "$DOTFILES_FOLDER"
echo "Installing Exports"
cp -f exports "$DOTFILES_FOLDER"
echo "Installing Functions"
cp -f functions "$DOTFILES_FOLDER"

# install dependencies
if [[ -z "${PACKAGING_START:-}" ]]; then
    echo "Do you want to install dependencies? (Yes/No)"
    read -r install_deps
else
    install_deps="No"
fi

if [[ ! $install_deps =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    echo "Skipping dependencies installation."
else
    echo "Installing Dependencies"
    if is_termux; then
        pkg update -y && pkg install -y vim curl wget git zsh tmux nodejs-lts fzf
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    elif [[ $OSTYPE == 'darwin'* ]]; then
        brew install vim duf curl wget git tmux
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
        sudo apt update -y && sudo apt install -y vim exa duf curl wget git zsh tmux fonts-powerline 
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    fi

    ## installs nvm (Node Version Manager)
    if ! is_termux; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
        
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        nvm install 18
    fi

    echo "NodeJS Version:" "$(node -v)"
    echo "NPM Version:" "$(npm -v)"
fi

## install Fonts
echo "Installing Fonts"
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


## install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
## install zsh-autosuggestions
rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

## install tmux plugins manager
echo "-----------------------------------------------------------------------"
echo "Installing Tmux Config"
cp -f tmux.conf "$HOME/.tmux.conf"
[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

## add k9s binary from GitHub
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install derailed/k9s/k9s
elif is_termux; then
    echo "Skipping K9S install on Termux"
else
    manual_install \
        https://github.com/derailed/k9s/releases/download/v0.50.6/k9s_$(get_os)_$(get_arch).tar.gz \
        k9s \
        "$HOME/.local/bin" \
        executable
fi

## install vim-plug
manual_install \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    plug.vim \
    "$HOME/.vim/autoload"

echo "Installing VIM Config"
cp -f ./vimrc "$HOME/.vimrc"
vim +'PlugInstall --sync' +qall &> /dev/null
sed -i 's/"colorscheme gruvbox/colorscheme gruvbox/' "$HOME/.vimrc"

## install fzf
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install fzf
else
    # [[ ! -d $HOME/.fzf ]] && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    # $HOME/.fzf/install --key-bindings --no-completion --no-update-rc
    run_install_script \
        https://github.com/junegunn/fzf.git \
        "$HOME/.fzf" \
        ./install --key-bindings --completion --no-update-rc --xdg
fi

## install yh (Yaml Highlighter)
manual_install \
    https://github.com/andreazorzetto/yh/releases/download/v0.4.0/yh-linux-amd64.zip \
    yh \
    "$HOME/.local/bin" \
    executable

## install copilot vim plugin
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install --cask github-copilot
    git clone --depth=1 https://github.com/github/copilot.vim.git \
        "$HOME/.config/nvim/pack/github/start/copilot.vim"
else
    git clone --depth=1 https://github.com/github/copilot.vim.git \
        "$HOME/.vim/pack/github/start/copilot.vim"
    echo "Open Vim and run :Copilot setup to complete installation"
fi

## set Default shell
#echo "set default shell"
chsh -s "$(command -v zsh)"

################################################################################################################

# echo "Installing .Profile";
# [[ ! -f $HOME/.profile ]] && touch $HOME/.profile
# grep -q DOTFILES $HOME/.profile
# if [ $? -eq 1 ]; then
#     echo "Updating .profile"
#     cat <<EOT >> $HOME/.profile
# #[DOTFILES] execute .bashrc for non-login shells.
# if [ -n "\$BASH_VERSION" ]; then
#     if [ -f "\$HOME/.bashrc" ]; then
#         . "\$HOME/.bashrc"
#     fi
# fi
# #[DOTFILES]
# EOT
# else
#     echo "please remove any [DOTFILES] lines in [$HOME/.profile] before update" 
# fi
