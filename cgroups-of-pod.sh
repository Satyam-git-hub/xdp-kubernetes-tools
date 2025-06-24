#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <pod-name> <container-name>"
    exit 1
fi

POD_NAME="$1"
CONTAINER_NAME="$2"
CONTAINERD_SOCK="/run/k3s/containerd/containerd.sock"

export CONTAINER_RUNTIME_ENDPOINT=unix://$CONTAINERD_SOCK

# Step 1: Find namespace of the pod
NAMESPACE=$(kubectl get pod --all-namespaces | grep "$POD_NAME" | awk '{print $1}')
if [ -z "$NAMESPACE" ]; then
    echo "❌ Pod '$POD_NAME' not found"
    exit 1
fi
echo "📍 Pod '$POD_NAME' found in namespace '$NAMESPACE'"

# Step 2: Get Pod UID and QoS
POD_UID=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.metadata.uid}')
POD_SLICE_UID=$(echo "$POD_UID" | tr '-' '_')
QOS_CLASS=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE" -o jsonpath='{.status.qosClass}' | tr '[:upper:]' '[:lower:]')
if [ -z "$QOS_CLASS" ]; then QOS_CLASS="besteffort"; fi

POD_CGROUP_PATH="/kubepods.slice/kubepods-${QOS_CLASS}.slice/kubepods-${QOS_CLASS}-pod${POD_SLICE_UID}.slice"

echo "🔹 Pod UID: $POD_UID"
echo "🧩 QoS Class: $QOS_CLASS"
echo "📁 Pod-level cgroup: $POD_CGROUP_PATH"
echo ""

# Find container ID matching pod + container
CID=$(sudo crictl ps -a -o json | jq -r \
  --arg pod "$POD_NAME" \
  --arg name "$CONTAINER_NAME" \
  '.containers[] | select(.labels."io.kubernetes.pod.name" == $pod and .metadata.name == $name) | .id')

if [ -z "$CID" ]; then
    echo "❌ Container '$CONTAINER_NAME' not found in pod '$POD_NAME'"
    exit 1
fi

# Step 5: Get container PID and cgroup
PID=$(sudo crictl inspect "$CID" | jq '.info.pid')
if [ "$PID" -eq 0 ]; then
    echo "⚠️ Container '$CONTAINER_NAME' has exited (PID 0)"
    exit 0
fi

CGROUP_LINE=$(cat /proc/$PID/cgroup | grep -E '^0::')
CONTAINER_CGROUP=$(echo "$CGROUP_LINE" | cut -d: -f3)

echo "📦 Container '$CONTAINER_NAME':"
echo "     ├─ PID: $PID"
echo "     └─ Container-level cgroup: $CONTAINER_CGROUP"
