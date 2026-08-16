#!/bin/bash

# ── Resolve script location & enter its directory ──────────────────────────────
# pushd is used (instead of plain cd) so we can reliably pop back to the
# caller's original working directory when this script completes, no matter
# where it was invoked from.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)" \
  || SCRIPT_DIR="$(dirname -- "${BASH_SOURCE[0]}")"

# Export so that sourced files (setEnv, .app, .pref) can rely on it too.
export DOTFILES_DIR="$SCRIPT_DIR"

pushd -- "$SCRIPT_DIR" >/dev/null || exit 1

# ── Bootstrap environment ──────────────────────────────────────────────────────
source "$SCRIPT_DIR/setEnv"

# ── Helpers ───────────────────────────────────────────────────────────────────
build_localdist() {
  local LOCALDIST_DIR="./localdist"
  local LOCALDIST_DOTFILES_DIR="${LOCALDIST_DIR}/.config/dotfiles"

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

# ── Pre-flight ────────────────────────────────────────────────────────────────
echo "Detected system: $SYSTEM_INFO"
if [[ -z "${SYSTEM_INFO:-}" ]]; then
  echo "System information not detected. Please set SYSTEM_INFO in setEnv file."
  popd >/dev/null || true
  exit 1
fi

# ── Dependencies (optional) ────────────────────────────────────────────────────
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
      popd >/dev/null || true
      exit 1
    fi
  elif [[ $OSTYPE == 'darwin'* ]]; then
    if ! brew install vim curl wget git tmux stow; then
      echo "Failed to install dependencies"
      popd >/dev/null || true
      exit 1
    fi
  elif grep -qiE "debian|ubuntu|mint" /etc/*release; then
    if ! sudo apt update -y && sudo apt install -y vim curl wget git zsh unzip stow bison libevent-dev; then
      echo "Failed to install dependencies"
      popd >/dev/null || true
      exit 1
    fi
  fi
fi

# ── App installers ────────────────────────────────────────────────────────────
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

# ── Preferences ───────────────────────────────────────────────────────────────
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

# ── Install dotfiles ──────────────────────────────────────────────────────────
echo "################################################################"
echo "Installing dotfiles"
echo "################################################################"
if [[ -d "$DOTFILES_FOLDER" ]]; then
  echo "DotFiles folder exists continue"
else
  mkdir -p "$DOTFILES_FOLDER"
fi
echo "Installing BashRC"
cp -f localdist/.bashrc "$HOME/.bashrc"
echo "Installing ZshRC"
cp -f localdist/.zshrc "$HOME/.zshrc"
echo "Installing Zsh environment"
cp -f localdist/.zshenv "$HOME/.zshenv"
echo "Installing Dotfiles config"
cp -rf localdist/.config/dotfiles/. "$DOTFILES_FOLDER/"

# ── Return to caller's original directory ─────────────────────────────────────
popd >/dev/null || true
echo "################################################################"
echo "Done — back in $(pwd)"
echo "################################################################"