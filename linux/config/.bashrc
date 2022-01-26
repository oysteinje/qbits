export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export KUBECONFIG="$HOME/.kube/config"

sudo ip link set dev eth0 mtu 1400

fish
