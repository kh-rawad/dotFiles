# ── Version ───────────────────────────────────────────────────────────────────
# No pinned version.  The official get-helm-3 script always installs the
# latest stable Helm release from get.helm.sh.  To pin, replace the URL
# with a versioned script, e.g.:
#   https://raw.githubusercontent.com/helm/helm/v3.14.0/scripts/get-helm-3

echo "--- Installing Helm"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
HELM_INSTALL_DIR="$HOME/.local/bin" ./get_helm.sh

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