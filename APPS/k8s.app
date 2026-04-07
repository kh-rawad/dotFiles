# kubernetes tools completion
echo "--- Installing kubectl and kubeadm"
if [[ $OSTYPE == 'linux-gnu'* ]]; then
    # check for latest kubectl version
    # $(curl -L -s https://dl.k8s.io/release/stable.txt)

    if ! is_termux; then
      curl -LO "https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubectl"
      curl -LO "https://dl.k8s.io/release/v1.35.0/bin/linux/amd64/kubeadm"
    else
      curl -LO "https://dl.k8s.io/release/v1.35.0/bin/linux/arm64/kubectl"
      curl -LO "https://dl.k8s.io/release/v1.35.0/bin/linux/arm64/kubeadm"
    fi
fi
chmod +x kubectl
chmod +x kubeadm
mv kubectl "$HOME/.local/bin/"
mv kubeadm "$HOME/.local/bin/"

echo "--- kubectl and kubeadm installed successfully"

: "${LOCALDIST_EXPORTS:=./exports}"
: "${LOCALDIST_ALIASES:=./aliases}"

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
