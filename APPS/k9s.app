## add k9s binary from GitHub
echo "--- Installing K9S"

# ── Version ───────────────────────────────────────────────────────────────────
# k9s release to download.  The binary URL is platform-specific
# (linux/amd64, linux/arm64, darwin/amd64, etc.) but the tag stays the same.
VERSION="0.50.6"

if [[ $OSTYPE == 'darwin'* ]]; then
    brew install derailed/k9s/k9s
elif is_termux; then
    echo "--- Skipping K9S install on Termux"
else
    manual_install \
        "https://github.com/derailed/k9s/releases/download/v${VERSION}/k9s_$(get_os)_$(get_arch).tar.gz" \
        k9s \
        "$HOME/.local/bin" \
        executable
    echo "--- K9S installed successfully"
fi