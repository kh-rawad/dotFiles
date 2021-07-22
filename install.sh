#!/bin/bash

echo "Installing BashRC"
cp -f .bashrc ~/.bashrc
echo "Installing VIM Config"
cp -f -r .vim/ ~/.vim
cp -f .vimrc ~/.vimrc

if [ -d ~dotfiles ]; then echo "DotFiles folder exsists continue"; fi
if [ ! -d ~/dotfiles ]; then echo "creating dotFiles folder"; mkdir ~/dotfiles; fi

echo "Installing Aliases"
cp -f aliases ~/dotfiles
echo "Installing Exports"
cp -f exports ~/dotfiles
echo "Installing Functions"
cp -f functions ~/dotfiles

sleep 2
clear
source ~/.bashrc
