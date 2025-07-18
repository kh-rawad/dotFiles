#!/bin/bash
# create a DotFiles package for offline installation
source "$(dirname "$0")/setEnv"
if [[ -z $SYSTEM_INFO ]]; then
    echo "System information not detected. Please set SYSTEM_INFO in setEnv file."
    exit 1
fi

# Create a tem directory for the package
PACKAGE_DIR="$(pwd)/dotfiles_package"
mkdir -p "$PACKAGE_DIR" 

# set temprorary directory as HOME
OLD_HOME="$HOME"
export HOME="$PACKAGE_DIR"
export PACKAGING_START='true'
./install.sh

# clean up unnecessary files
rm -rf "$HOME/.cache"
rm "$HOME/.wget-hsts"

# create a tarball of the package
PACKAGE_NAME="dotfiles_package_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$PACKAGE_NAME" -C "$PACKAGE_DIR" .
# Clean up the temporary directory
rm -rf "$PACKAGE_DIR"

# restore original HOME
export HOME="$OLD_HOME"
unset PACKAGING_START