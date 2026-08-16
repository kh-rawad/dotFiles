## install tmux from source
echo "--- Installing tmux from source"

# ── Version ───────────────────────────────────────────────────────────────────
# Pin to a specific tmux release so the source build and the download URL
# stay in sync.  The script skips the build when this version is already
# installed at ~/.local/bin/tmux.
VERSION="3.6a"

#sudo apt-get install bison libevent-dev

if [[ $OSTYPE == 'linux'* ]]; then
    if "$HOME/.local/bin/tmux" -V 2>/dev/null | grep -q "tmux ${VERSION}"; then
        echo "--- Tmux ${VERSION} is already installed"
    elif grep -Eqi 'debian|ubuntu|mint' /etc/*release 2>/dev/null; then
        TMUX_DIR="tmux-${VERSION}"
        TMUX_TAR="${TMUX_DIR}.tar.gz"

        wget "https://github.com/tmux/tmux/releases/download/${VERSION}/${TMUX_TAR}" || {
            echo "--- Failed to download tmux. Aborting."
            exit 1
        }

        tar -zxf "$TMUX_TAR"
        cd "$TMUX_DIR" || { echo "--- Failed to enter tmux directory"; exit 1; }

        ./configure --prefix="$HOME/.local"
        make && make install

        echo "--- Tmux ${VERSION} installed successfully"
        cd ..
        rm -rf "$TMUX_DIR" "$TMUX_TAR"
    else
        echo "--- Unsupported Linux distribution. Please install tmux manually."
    fi
fi


