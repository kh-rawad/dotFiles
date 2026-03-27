echo '>>>Intalling exa'
echo '--- https://github.com/ogham/exa'
PACKAGE_NAME='exa'


if [[ $OSTYPE == 'darwin'* ]]; then
    brew install exa
elif is_termux; then
    wget -q -O exa-linux-armv7-v0.10.1.zip https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-armv7-v0.10.1.zip
    unzip -o exa-linux-armv7-v0.10.1.zip -d source
elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
    wget -q -O exa-linux-x86_64-v0.10.1.zip https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip
    unzip -o exa-linux-x86_64-v0.10.1.zip -d source
fi

if [[ $OSTYPE != 'darwin'* ]]; then
    echo '--- Copy completions scripts'
    [[ -f source/bin ]]; mv source/bin/* ${HOME}/.local/bin/

    # target_paths[0] is BASH, target_paths[1] is ZSH
    if [[ -d source/completions ]]; then
        target_paths=( "${DOTFILES_FOLDER}/SHELLS/"{BASH,ZSH}"/${PACKAGE_NAME}/completions" )
        mkdir -p "${target_paths[@]}"
        mv source/completions/*bash "${target_paths[0]}"/ 2>/dev/null
        mv source/completions/*zsh "${target_paths[1]}"/ 2>/dev/null
    fi

    echo '--- Cleanup'
    rm -rf source
    rm exa-*
fi

echo '<<< DONE'
