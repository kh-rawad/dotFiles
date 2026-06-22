## installs nvm (Node Version Manager)
echo "--- Installing NVM (Node Version Manager)"

: "${LOCALDIST_EXPORTS:=./exports}"

if ! is_termux; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash   
    
    # export for installer use
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    nvm install 18 --silent >/dev/null 2>&1
    nvm use 18 --silent >/dev/null 2>&1

    NVM_BLOCK='#[DOTFILES_NVM]
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use 18 --silent 2>/dev/null
#[/DOTFILES_NVM]
'
    append_block_once "$LOCALDIST_EXPORTS" "#[DOTFILES_NVM]" "$NVM_BLOCK"
fi

command -v node >/dev/null 2>&1 && echo "--- NodeJS Version:" "$(node -v)"
command -v npm >/dev/null 2>&1 && echo "--- NPM Version:" "$(npm -v)"

