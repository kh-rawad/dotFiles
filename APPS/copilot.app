## install copilot-cli

echo "--- Installing GitHub Copilot CLI"
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install --cask github-copilot
else
    rm -rf "$HOME/.nvm/versions/node/v16.20.2/lib/node_modules/@github/copilot"
    npm install -g @github/copilot
fi

## install copilot vim plugin
echo "--- Installing GitHub Copilot Vim Plugin"
if [[ $OSTYPE == 'darwin'* ]]; then
    git clone --depth=1 https://github.com/github/copilot.vim.git \
        "$HOME/.config/nvim/pack/github/start/copilot.vim"
else
    rm -rf "$HOME/.vim/pack/github/start/copilot.vim"
    git clone --depth=1 https://github.com/github/copilot.vim.git \
        "$HOME/.vim/pack/github/start/copilot.vim"
    echo "^^ Open Vim and run :Copilot setup to complete installation"
fi


### additional steps for termux on android (copilot-cli)
if is_termux; then
   echo "--- Additional steps for Termux on Android"
   pkg install -y build-essential python
   npm install -y -g node-gyp node-pty
   npm install -y -g @github/copilot

   mkdir -p /data/data/com.termux/files/usr/lib/node_modules/@github/copilot/prebuilds/android-arm64 
   cp /data/data/com.termux/files/usr/lib/node_modules/node-pty/build/Release/pty.node /data/data/com.termux/files/usr/lib/node_modules/@github/copilot/prebuilds/android-arm64/pty.node
fi


echo "to use copilot RUN: copilot auth login"
