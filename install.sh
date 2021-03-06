#!/bin/bash

echo "Installing BashRC"
cp -f .bashrc ~/.bashrc
echo "Installing VIM Config"
cp -f -r .vim/ ~/.vim
cp -f .vimrc ~/.vimrc

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
grep -q \DOTFILES ~/.profile
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
cat <<EOT 
# if arch linux
# pacman -Syy && pacman -S vim neofetch powerline
# if debian 
# apt update && sudo apt upgrade && sudo apt install vim neofetch powerline

# Restart your session OR source .bashrc
EOT
sleep 2
