#!/bin/bash

echo "Installing BashRC"
cp -f bashrc ~/.bashrc
echo "Installing ZshRC"
cp -f zshrc ~/.zshrc
echo "Installing VIM Config"
cp -f -r vim/ ~/.vim
cp -f vimrc ~/.vimrc
vim +'PlugInstall --sync' +qall &> /dev/null

if [ -d ~/dotfiles ]; then echo "DotFiles folder exsists continue"; fi
if [ ! -d ~/dotfiles ]; then echo "creating dotFiles folder"; mkdir ~/dotfiles; fi

echo "Installing Aliases"
cp -f aliases ~/dotfiles
echo "Installing Exports"
cp -f exports ~/dotfiles
echo "Installing Functions"
cp -f functions ~/dotfiles

echo "Installing .Profile";
if [ ! -f ~/.profile ]; then echo "Creating [~/.profile] "; touch ~/.profile; fi
grep -q DOTFILES ~/.profile
if [ $? -eq 1 ]; then
    echo "Updating .profile"
    cat <<EOT >> ~/.profile
#[DOTFILES] execute .bashrc for non-login shells.
if [ -n "\$BASH_VERSION" ]; then    
    if [ -f "\$HOME/.bashrc" ]; then
        . "\$HOME/.bashrc"
    fi 
fi
#[DOTFILES]
EOT
else 
    echo "please remove any [DOTFILES] lines in [~/.profile] before update" 
fi

# install dependencies
# add neofetch binary from GitHub
curl https://raw.githubusercontent.com/dylanaraps/neofetch/7.1.0/neofetch > ~\.local\bin\neofetch
# install powerline for the user
python3 -m pip install powerline-status
cp -R .local/lib/python3.9/site-packages/powerline/config_files/ ~/.config/powerline
git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts; ./install.sh && cd .. ;rm -rf fonts

cat <<EOT 
# if arch linux
# pacman -Syy && pacman -S vim exa duf screen curl
# if debian 
# apt update && sudo apt upgrade && sudo apt install vim screen exa duf curl

# Restart your session OR source .bashrc
EOT
sleep 2
