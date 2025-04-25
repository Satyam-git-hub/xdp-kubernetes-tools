#!/bin/bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <pod-name> [\"command in quotes\"]"
    exit 1
fi

POD_NAME=$1
CMD=$2

# Step 1: Find pod sandbox ID
POD_ID=$(crictl pods --name "$POD_NAME" -q)
if [ -z "$POD_ID" ]; then
    echo "❌ Pod '$POD_NAME' not found!"
    exit 1
fi
echo "🆔 Found Pod ID: $POD_ID"

# Step 2: Get container ID inside pod
CONTAINER_ID=$(crictl ps -a --pod "$POD_ID" -q | head -n 1)
if [ -z "$CONTAINER_ID" ]; then
    echo "❌ No container found in pod '$POD_NAME'"
    exit 1
fi
echo "📦 Found Container ID: $CONTAINER_ID"

# Step 3: Get container PID
PID=$(crictl inspect "$CONTAINER_ID" | jq -r '.info.pid')
if [ -z "$PID" ] || [ "$PID" == "null" ]; then
    echo "❌ Failed to retrieve PID for container in pod '$POD_NAME'"
    exit 1
fi
echo "🔍 Found PID: $PID"

# Step 4: Force recreate the symlink
mkdir -p /var/run/netns
LINK_PATH="/var/run/netns/$POD_NAME"
NS_PATH="/proc/$PID/ns/net"

if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
    echo "🧹 Removing existing link or file: $LINK_PATH"
    rm -f "$LINK_PATH"
fi

ln -s "$NS_PATH" "$LINK_PATH"
echo "✅ Symlink created: $LINK_PATH -> $NS_PATH"

# Step 5: Optional command
if [ ! -z "$CMD" ]; then
    echo "🚀 Executing in namespace: $CMD"
    ip netns exec "$POD_NAME" bash -c "$CMD"
else
    echo "ℹ️ You can now run: ip netns exec $POD_NAME <command>"
fi