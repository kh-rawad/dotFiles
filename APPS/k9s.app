## add k9s binary from GitHub
echo "--- Installing K9S"
if [[ $OSTYPE == 'darwin'* ]]; then
    brew install derailed/k9s/k9s
elif is_termux; then
    echo "--- Skipping K9S install on Termux"
else
    manual_install \
        https://github.com/derailed/k9s/releases/download/v0.50.6/k9s_$(get_os)_$(get_arch).tar.gz \
        k9s \
        "$HOME/.local/bin" \
        executable
    echo "--- K9S installed successfully"
fi