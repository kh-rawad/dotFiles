#!/bin/bash

source "$(dirname "$0")/setEnv"

echo "Detected system: $SYSTEM_INFO"
if [[ -z "${SYSTEM_INFO:-}" ]]; then
    echo "System information not detected. Please set SYSTEM_INFO in setEnv file."
    exit 1
fi

# install dependencies
if [[ -z "${PACKAGING_START:-}" ]]; then
    echo "Do you want to install dependencies? (Yes/No)"
    read -r install_deps
else
    install_deps="No"
fi

echo "################################################################"

if [[ ! $install_deps =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    echo "Skipping dependencies installation."
else
    echo "Installing Dependencies"
    if is_termux; then
        pkg update -y && pkg install -y vim curl wget git zsh tmux nodejs-lts stow unzip
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    elif [[ $OSTYPE == 'darwin'* ]]; then
        brew install vim curl wget git tmux stow
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
        sudo apt update -y && sudo apt install -y vim curl wget git zsh unzip stow bison libevent-dev
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    fi

fi


echo "################################################################"
echo "Installing applications"
echo "################################################################"

for app in ./APPS/*; do
    echo ">>> Installing $app"
    if source "$app"; then
        echo "<<< Finished installing $app"
    else
        echo "<<< Failed installing $app (exit code: $?)"
    fi
    echo -e "\n---------------------------------------------------------------\n"
done

echo "################################################################"
echo "running prefrences scripts"
echo "################################################################"
for pref in ./PREFS/*; do
    echo ">>> Running $pref"
    if source "$pref"; then
        echo "<<< Finished running $pref"
    else
        echo "<<< Failed running $pref (exit code: $?)"
    fi
    echo -e "\n---------------------------------------------------------------"
done
echo "################################################################"
echo "Installing dotfiles"
echo "################################################################"
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
