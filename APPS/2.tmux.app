## install tmux from source
echo "--- Installing tmux from source"
#sudo apt-get install bison libevent-dev

if [[ $OSTYPE == 'linux'* ]]; then
    REQUIRED_VERSION="3.6a"

    if "$HOME/.local/bin/tmux" -V 2>/dev/null | grep -q "tmux ${REQUIRED_VERSION}"; then
        echo "--- Tmux ${REQUIRED_VERSION} is already installed"
    elif grep -Eqi 'debian|ubuntu|mint' /etc/*release 2>/dev/null; then
        TMUX_DIR="tmux-${REQUIRED_VERSION}"
        TMUX_TAR="${TMUX_DIR}.tar.gz"

        wget "https://github.com/tmux/tmux/releases/download/${REQUIRED_VERSION}/${TMUX_TAR}" || {
            echo "--- Failed to download tmux. Aborting."
            exit 1
        }

        tar -zxf "$TMUX_TAR"
        cd "$TMUX_DIR" || { echo "--- Failed to enter tmux directory"; exit 1; }

        ./configure --prefix="$HOME/.local"
        make && make install

        echo "--- Tmux ${REQUIRED_VERSION} installed successfully"
        cd ..
        rm -rf "$TMUX_DIR" "$TMUX_TAR"
    else
        echo "--- Unsupported Linux distribution. Please install tmux manually."
    fi
fi


