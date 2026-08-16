## install yh (Yaml Highlighter)
echo "--- Installing YH (Yaml Highlighter)"

# ── Version ───────────────────────────────────────────────────────────────────
# yh release.  The asset is currently linux-amd64 only; add other arch assets
# here if upstream publishes them.
VERSION="0.4.0"

manual_install \
    "https://github.com/andreazorzetto/yh/releases/download/v${VERSION}/yh-linux-amd64.zip" \
    yh \
    "$HOME/.local/bin" \
    executable
echo "--- YH installed successfully"