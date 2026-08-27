## install zoxide
echo "--- Installing zoxide"

# ── Version ───────────────────────────────────────────────────────────────────
# No pinned version.  zoxide's official install script always fetches the
# latest release.  To pin, replace the script URL with a specific version.

: "${LOCALDIST_EXPORTS:=./exports}"

if [[ $OSTYPE == 'darwin'* ]]; then
    brew install zoxide
elif is_termux; then
    pkg install -y zoxide
else
    run_install_script \
        https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh \
        "$HOME/.local/zoxide-install" \
        sh
fi

ZOXIDE_BLOCK='#[DOTFILES_ZOXIDE]
# zoxide exports
if [[ ! "$PATH" == *$HOME/.local/bin* ]]; then
    PATH="$HOME/.local/bin:${PATH}"
fi
[ -n "$BASH_VERSION" ] && eval "$(zoxide init bash)" 2>/dev/null
[ -n "$ZSH_VERSION" ] && eval "$(zoxide init zsh)" 2>/dev/null
#[/DOTFILES_ZOXIDE]
'

# Replace old generated zoxide block (if present) then append the corrected block once.
sed -i '/^#\[DOTFILES_ZOXIDE\]$/,/^#\[\/DOTFILES_ZOXIDE\]$/d' "$LOCALDIST_EXPORTS" 2>/dev/null
append_block_once "$LOCALDIST_EXPORTS" "#[DOTFILES_ZOXIDE]" "$ZOXIDE_BLOCK"
