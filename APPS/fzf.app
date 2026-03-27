## install fzf

if [[ $OSTYPE == 'darwin'* ]]; then
    brew install fzf
elif is_termux; then
    pkg install -y fzf
else
    # [[ ! -d $HOME/.fzf ]] && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    # $HOME/.fzf/install --key-bindings --no-completion --no-update-rc
    run_install_script \
        https://github.com/junegunn/fzf.git \
        "$HOME/.fzf" \
        ./install --key-bindings --completion --no-update-rc --xdg
fi
