#!/bin/bash

source "$(dirname "$0")/setEnv"

build_localdist() {
  LOCALDIST_DIR="./localdist"
  LOCALDIST_DOTFILES_DIR="${LOCALDIST_DIR}/.config/dotfiles"

  rm -rf "$LOCALDIST_DIR"
  mkdir -p "$LOCALDIST_DOTFILES_DIR"

  cp -f SHELLS/BASH/bashrc "${LOCALDIST_DIR}/.bashrc"
  cp -f SHELLS/ZSH/zshrc "${LOCALDIST_DIR}/.zshrc"
  cp -f SHELLS/ZSH/zshenv "${LOCALDIST_DIR}/.zshenv"
  cp -f aliases "${LOCALDIST_DOTFILES_DIR}/aliases"
  cp -f exports "${LOCALDIST_DOTFILES_DIR}/exports"
  cp -f functions "${LOCALDIST_DOTFILES_DIR}/functions"

  export LOCALDIST_EXPORTS="${LOCALDIST_DOTFILES_DIR}/exports"
  export LOCALDIST_ALIASES="${LOCALDIST_DOTFILES_DIR}/aliases"
  export LOCALDIST_BASHRC="${LOCALDIST_DIR}/.bashrc"
  export LOCALDIST_ZSHRC="${LOCALDIST_DIR}/.zshrc"
}

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
    if ! pkg update -y && pkg install -y vim curl wget git zsh tmux nodejs-lts stow unzip; then
      echo "Failed to install dependencies"
      exit 1
    fi
  elif [[ $OSTYPE == 'darwin'* ]]; then
  if ! brew install vim curl wget git tmux stow; then
    echo "Failed to install dependencies"
    exit 1
  fi
  elif grep -qiE "debian|ubuntu|mint" /etc/*release; then
    if ! sudo apt update -y && sudo apt install -y vim curl wget git zsh unzip stow bison libevent-dev; then
      echo "Failed to install dependencies"
      exit 1
    fi
  fi

fi


echo "################################################################"
echo "Installing applications"
echo "################################################################"
build_localdist

for app in ./APPS/*; do
  echo ">>> Installing $app"
  # shellcheck disable=SC1090
  if source "$app"; then
    echo "<<< Finished installing $app"
  else
    echo "<<< Failed installing $app (exit code: $?)"
  fi
  echo -e "\n---------------------------------------------------------------\n"
done

echo "################################################################"
echo "running preferences scripts"
echo "################################################################"
for pref in ./PREFS/*; do
  echo ">>> Running $pref"
  # shellcheck disable=SC1090
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
if [[ -d "$DOTFILES_FOLDER" ]]; then
  echo "DotFiles folder exists continue"
else
  mkdir -p "$DOTFILES_FOLDER"
fi
# install dotfiles
echo "Installing BashRC"
cp -f localdist/.bashrc "$HOME/.bashrc"
echo "Installing ZshRC"
cp -f localdist/.zshrc "$HOME/.zshrc"
echo "Installing Zsh environment"
cp -f localdist/.zshenv "$HOME/.zshenv"
echo "Installing Dotfiles config"
cp -rf localdist/.config/dotfiles/. "$DOTFILES_FOLDER/"
