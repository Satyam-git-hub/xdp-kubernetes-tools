#!/bin/bash

# crictl-install.sh

# Default version
DEFAULT_VERSION="v1.32.0"

# Use provided version or fallback to default
VERSION="${1:-$DEFAULT_VERSION}"

echo "🔧 Installing crictl version: $VERSION"

# Download crictl using wget
wget "https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-amd64.tar.gz"
if [ $? -ne 0 ]; then
  echo "❌ Failed to download crictl version ${VERSION}. Please check the version or your network connection."
  exit 1
fi

# Extract to /usr/local/bin
sudo tar zxvf "crictl-${VERSION}-linux-amd64.tar.gz" -C /usr/local/bin
rm -f "crictl-${VERSION}-linux-amd64.tar.gz"

# Create crictl config file
echo "📝 Creating /etc/crictl.yaml"
sudo tee /etc/crictl.yaml > /dev/null <<EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF

# Confirm installation
echo "✅ crictl installed successfully."
crictl --version
