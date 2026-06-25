: "${LOCALDIST_EXPORTS:=./exports}"
: "${LOCALDIST_ALIASES:=./aliases}"

# kubernetes tools completion
echo "--- Installing kubectl and kubeadm"
if [[ $OSTYPE == 'linux-gnu'* ]]; then
    # Stage downloads inside localdist, then copy to ~/.local/bin
    K8S_STAGE_DIR="$(dirname "$LOCALDIST_EXPORTS")/k8s"
    mkdir -p "$K8S_STAGE_DIR" "$HOME/.local/bin"

    # check for latest kubectl version
    # $(curl -L -s https://dl.k8s.io/release/stable.txt)
    if ! is_termux; then
      curl -L -o "$K8S_STAGE_DIR/kubectl" "https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubectl"
      curl -L -o "$K8S_STAGE_DIR/kubeadm" "https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubeadm"
    else
      curl -L -o "$K8S_STAGE_DIR/kubectl" "https://dl.k8s.io/release/v1.35.0/bin/linux/arm64/kubectl"
      curl -L -o "$K8S_STAGE_DIR/kubeadm" "https://dl.k8s.io/release/v1.35.0/bin/linux/arm64/kubeadm"
    fi

    chmod +x "$K8S_STAGE_DIR/kubectl" "$K8S_STAGE_DIR/kubeadm"
    cp -f "$K8S_STAGE_DIR/kubectl" "$HOME/.local/bin/kubectl"
    cp -f "$K8S_STAGE_DIR/kubeadm" "$HOME/.local/bin/kubeadm"

    echo "--- kubectl and kubeadm installed successfully"
fi

if [ -n "$BASH_VERSION" ]; then
    cat >> "$LOCALDIST_EXPORTS" <<'EOF'
# Kubernetes tools completions (bash only)
if [ -n "$BASH_VERSION" ]; then
  command -v kubectl &>/dev/null && source <(kubectl completion bash)
  command -v kubeadm &>/dev/null && source <(kubeadm completion bash)
  complete -F __start_kubectl k
fi
EOF
fi

echo "alias k=kubectl" >> "$LOCALDIST_ALIASES"
