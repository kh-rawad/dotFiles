curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
HELM_INSTALL_DIR="$HOME/.local/bin" ./get_helm.sh

echo "--- Installing Helm completions"
echo "source <(helm completion bash)" >> ./exports

rm get_helm.sh
echo "--- Helm installed successfully"