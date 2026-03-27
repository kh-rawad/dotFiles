# kubernetes tools completion
echo "--- Installing kubectl and kubeadm"
if $OSTYPE == 'linux-gnu'*; then
    # check for latest kubectl version
    # $(curl -L -s https://dl.k8s.io/release/stable.txt)

    if ! is_tmux; then
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

echo """# Kubernetes tools completions
source <(kubectl completion bash)
source <(kubeadm completion bash)""" >> ./exports

echo "alias k=kubectl" >> ./aliases
echo "complete -F __start_kubectl k" >> ./exports