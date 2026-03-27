## installs nvm (Node Version Manager)
echo "--- Installing NVM (Node Version Manager)"
if ! is_termux; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash   
    
    # export for installer use
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    nvm install 18
fi

echo "--- NodeJS Version:" "$(node -v)"
echo "--- NPM Version:" "$(npm -v)"

