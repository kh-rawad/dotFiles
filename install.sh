#!/bin/bash

[[ -d ~/dotfiles ]] && echo "DotFiles folder exsists continue" || mkdir ~/dotfiles
# install dependencies
## installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 18
echo "NodeJS Version:" `node -v`
echo "NPM Version:" `npm -v`

## install powerline for the user
sudo apt update -y && sudo apt upgrade -y && sudo apt install -y vim screen exa duf curl
sudo apt install -y fonts-powerline powerline powerline-doc powerline-gitstatus
cp -r /usr/share/powerline/config_files/ ~/.config/powerline
git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts; ./install.sh && cd .. ;rm -rf fonts

## add neofetch binary from GitHub
curl -sL https://raw.githubusercontent.com/dylanaraps/neofetch/7.1.0/neofetch -o ~/.local/bin/neofetch
chmod +x ~/.local/bin/neofetch

curl -sL https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb -o k9s.deb
sudo dpkg -i k9s.deb
rm -f k9s.deb

sleep 2

echo "Installing BashRC"
cp -f bashrc ~/.bashrc
echo "Installing ZshRC"
cp -f zshrc ~/.zshrc
echo "Installing VIM Config"
cp -f -r vim/ ~/.vim
cp -f vimrc ~/.vimrc
vim +'PlugInstall --sync' +qall &> /dev/null
echo "Installing Aliases"
cp -f aliases ~/dotfiles
echo "Installing Exports"
cp -f exports ~/dotfiles
echo "Installing Functions"
cp -f functions ~/dotfiles
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

echo "Installing SCREEN Config"
cp -f screenrc ~/.screenrc

