#!/bin/bash

set -e

NETNS_DIR="/var/run/netns"

if [ ! -d "$NETNS_DIR" ]; then
    echo "❌ $NETNS_DIR does not exist!"
    exit 1
fi

echo "🔍 Network Namespaces in $NETNS_DIR:"
printf "%-20s %-40s\n" "Name" "Points to"

for ns in "$NETNS_DIR"/*; do
    if [ -L "$ns" ]; then
        name=$(basename "$ns")
        target=$(readlink -f "$ns")
        printf "%-20s %-40s\n" "$name" "$target"
    fi
done
