set -e

HELM_SCRIPT="get_helm.sh"

echo "Downloading Helm installer..."
curl -fsSL --retry 3 --retry-delay 2 -o "$HELM_SCRIPT" https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 || {
    echo "Error: Failed to download Helm installer. Check your internet connection or GitHub rate limits."
    exit 1
}

if [ ! -f "$HELM_SCRIPT" ]; then
    echo "Error: Helm installer script not found after download"
    exit 1
fi

echo "Running Helm installer..."
chmod 700 "$HELM_SCRIPT"
HELM_INSTALL_DIR="$HOME/.local/bin" USE_SUDO=false ./get_helm.sh || {
    echo "Error: Helm installation failed"
    rm -f "$HELM_SCRIPT"
    exit 1
}

: "${LOCALDIST_EXPORTS:=./exports}"

if [ -n "$BASH_VERSION" ]; then
    echo "Installing Helm completions..."
    cat >> "$LOCALDIST_EXPORTS" <<'EOF'
if [ -n "$BASH_VERSION" ]; then
    command -v helm &>/dev/null && source <(helm completion bash)
fi
EOF
fi

rm -f "$HELM_SCRIPT"
echo "--- Helm installed successfully"