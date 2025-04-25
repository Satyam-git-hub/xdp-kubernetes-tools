#!/bin/bash

set -e

NETNS_DIR="/var/run/netns"

if [ ! -d "$NETNS_DIR" ]; then
    echo "❌ $NETNS_DIR not found!"
    exit 1
fi

echo "🧼 Cleaning up custom network namespaces in $NETNS_DIR..."

for ns in "$NETNS_DIR"/*; do
    if [ -L "$ns" ]; then
        echo "🗑️ Removing symlink: $ns"
        sudo rm -f "$ns"
    fi
done

echo "✅ Cleanup complete."
