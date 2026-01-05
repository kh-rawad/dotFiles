#!/bin/bash
source ./setEnv

echo "Detected system: $SYSTEM_INFO"
if [[ -z $SYSTEM_INFO ]]; then
    echo "System information not detected. Please set SYSTEM_INFO in setEnv file."
    exit 1
fi


# Create the dotfiles folder if it doesn't exist
[[ -d $DOTFILES_FOLDER ]] && echo "DotFiles folder exists continue" || mkdir -p $DOTFILES_FOLDER
# install dotfiles
echo "Installing BashRC"
cp -f SHELLS/BASH/bashrc $HOME/.bashrc
echo "Installing ZshRC"
cp -f SHELLS/ZSH/zshrc $HOME/.zshrc
echo "Installing Aliases"
cp -f SHELLS/aliases $DOTFILES_FOLDER
echo "Installing Exports"
cp -f SHELLS/exports $DOTFILES_FOLDER
echo "Installing Functions"
cp -f SHELLS/functions $DOTFILES_FOLDER

# install dependencies
if [[ -z $PACKAGING_START ]]; then
    echo "Do you want to install dependencies? (Yes/No)"
    read -r install_deps
else
    install_deps="No"
fi

if [[ ! $install_deps =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    echo "Skipping dependencies installation."
else
    echo "Installing Dependencies"
    if [[ $OSTYPE == 'darwin'* ]]; then
        brew install vim duf curl wget git tmux go-task/tap/go-task
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
        sudo apt update -y && sudo apt install -y vim exa duf curl wget git zsh tmux
        curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash
        sudo apt-get install task
        [[ $? -ne 0 ]] && echo "Failed to install dependencies" && exit 1
    fi
fi

## set Default shell
#echo "set default shell"
#chsh -s $(which zsh)

################################################################################################################
# copy all task files to the dotfiles folder

cp -f Taskfile.yml $DOTFILES_FOLDER/Taskfile.yml
cp -f setEnv $DOTFILES_FOLDER/setEnv
cp -f install.sh $DOTFILES_FOLDER/install.sh
cp -r ADDONS $DOTFILES_FOLDER/ADDONS
cp -r APPS $DOTFILES_FOLDER/APPS
cp -r SHELLS $DOTFILES_FOLDER/SHELLS
cp -r utils $DOTFILES_FOLDER/utils

################################################################################################################

# task
echo "Running Task to install selected apps and addons..."
echo "use task -g to see the list of available tasks"
task -d $DOTFILES_FOLDER