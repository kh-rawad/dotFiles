#!/bin/bash

DOTFILES_FOLDER=~/.config/dotfiles
[[ -d $DOTFILES_FOLDER ]] && echo "DotFiles folder exsists continue" || mkdir -p $DOTFILES_FOLDER

# install dependencies
sudo apt update -y && sudo apt upgrade -y && sudo apt install -y vim exa duf curl wget git zsh tmux fonts-powerline 
[[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1

## installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 18
echo "NodeJS Version:" `node -v`
echo "NPM Version:" `npm -v`

## install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
## install zsh-autosuggestions
# git clone 

## install tmux plugins manager
echo "Installing Tmux Config"
cp -f tmux.conf ~/.tmux.conf
[[ ! -d ~/.tmux/plugins/tpm ]] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

## add k9s binary from GitHub
echo "Installing K9s"
curl -sL https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb -o k9s.deb
sudo dpkg -i k9s.deb
rm -f k9s.deb

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

################################################################################################################
# install dotfiles
echo "Installing BashRC"
cp -f bashrc ~/.bashrc
echo "Installing ZshRC"
cp -f zshrc ~/.zshrc
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