#!/bin/bash

cp -f .bashrc ~/.bashrc
cp -f -r .vim/ ~/.vim
cp -f .vimrc ~/.vimrc

if [ ! -d ~/dotfiles ]; then
echo "creating dotFiles folder"
mkdir ~/dotfiles
fi

cp -f aliases ~/dotfiles
cp -f exports ~/dotfiles
cp -f functions ~/dotfiles


source ~/.bashrc
