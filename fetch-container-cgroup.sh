#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: source $0 <container-name>"
    exit 1
fi

CONTAINER_NAME="$1"
CONTAINERD_SOCK="/run/k3s/containerd/containerd.sock"

export CONTAINER_RUNTIME_ENDPOINT=unix://$CONTAINERD_SOCK

# Step 1: Find the container ID of the running container with that name
CID=$(sudo crictl ps -o json | jq -r --arg name "$CONTAINER_NAME" '
    .containers[] 
    | select(.metadata.name == $name and .state == "CONTAINER_RUNNING") 
    | .id')

if [ -z "$CID" ]; then
    echo "❌ No running container named '$CONTAINER_NAME' found"
    exit 1
fi

echo "📦 Found running container: $CID"

# Step 2: Get the PID of the container
PID=$(sudo crictl inspect "$CID" | jq '.info.pid')
if [ "$PID" -eq 0 ]; then
    echo "⚠️ Container '$CONTAINER_NAME' has exited (PID = 0)"
    exit 0
fi

echo "🔧 Container PID: $PID"

# Step 3: Extract container cgroup from /proc
CGROUP_LINE=$(sudo cat /proc/$PID/cgroup | grep -E '^0::')
REL_CGROUP_PATH=$(echo "$CGROUP_LINE" | cut -d: -f3)

echo "📁 Container cgroup path:"
echo "    $REL_CGROUP_PATH"

# Step 4: Construct and export absolute cgroup path env var
ABS_CGROUP_PATH="/sys/fs/cgroup$REL_CGROUP_PATH"
VAR_NAME=$(echo "${CONTAINER_NAME^^}_CGROUP_PATH")  # Uppercase and safe
export "$VAR_NAME=$ABS_CGROUP_PATH"

# Step 5: Display it
echo "📌 Exported environment variable:"
echo "    export $VAR_NAME=\"$ABS_CGROUP_PATH\""
