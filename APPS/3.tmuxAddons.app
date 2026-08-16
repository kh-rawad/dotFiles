## install tmux plugins manager
echo "--- Installing Tmux Config"

# ── Version ───────────────────────────────────────────────────────────────────
# No pinned version.  Tmux Plugin Manager (TPM) clones latest from GitHub;
# plugins are installed at their master/main heads.
cp -f tmux.conf "$HOME/.tmux.conf"
[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
echo "--- Tmux Config installed successfully"
