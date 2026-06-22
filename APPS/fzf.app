## install fzf

: "${LOCALDIST_EXPORTS:=./exports}"

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

FZF_BLOCK='#[DOTFILES_FZF]
# fzf exports
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
    PATH="$HOME/.fzf/bin:${PATH}"
fi
[ -n "$BASH_VERSION" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash 2>/dev/null
[ -n "$ZSH_VERSION" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh 2>/dev/null
export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border"
#[/DOTFILES_FZF]
'

# Replace old generated FZF block (if present) then append the corrected block once.
sed -i '/^#\[DOTFILES_FZF\]$/,/^#\[\/DOTFILES_FZF\]$/d' "$LOCALDIST_EXPORTS" 2>/dev/null
append_block_once "$LOCALDIST_EXPORTS" "#[DOTFILES_FZF]" "$FZF_BLOCK"
