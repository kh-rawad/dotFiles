#!/bin/bash

cp .bashrc ~/.bashrc
cp -r .vim/ ~/.vim
cp .vimrc ~/.vimrc

if [ ! -d dotfiles ]; then
echo "creating dotFiles folder"
mkdir ~/dotfiles
fi

cp aliases ~/dotfiles
cp exports ~/dotfiles
cp functions ~/dotfiles


source ~/.bashrc
