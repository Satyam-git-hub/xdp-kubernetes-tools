Here’s a clear and structured README for your `get_netns.sh` script, tailored for your use case involving `crictl`, container networking, and namespace manipulation — perfect for debugging or exploring UPF, AMF, or any pod networking within your 5G core setups on Kubernetes:

---

# 🧠 `get_netns.sh` – Access Pod Network Namespaces via `crictl`

This script allows you to **retrieve and bind the network namespace** of a Kubernetes pod (managed by containerd) to a named entry under `/var/run/netns`. This makes it easy to execute network-related commands (like `tcpdump`, `ip`, etc.) inside the pod's namespace using `ip netns exec`.

---

## ✅ Prerequisites

Make sure the following are installed and available in your system:
- [`crictl`](https://github.com/kubernetes-sigs/cri-tools) — to interact with containerd
- [`jq`](https://stedolan.github.io/jq/) — for JSON parsing
- `iproute2` — provides `ip netns`
- The script should be run as **root or via sudo** since it accesses `/proc` and manages `/var/run/netns`

---

## 📄 Usage

```bash
sudo ./get_netns.sh <pod-name> ["optional command in quotes"]
```

### 🔍 Examples:

1. **Create netns symlink for a pod**:

```bash
sudo ./get_netns.sh upf-0
```

This will:
- Resolve the pod and container ID using `crictl`
- Extract the PID of the container
- Symlink `/proc/<pid>/ns/net` → `/var/run/netns/upf-0`
- Output instructions for using `ip netns exec`

You can now run:

```bash
sudo ip netns exec upf-0 ip a
```

2. **Run a command directly inside the pod’s netns**:

```bash
sudo ./get_netns.sh upf-0 "ip a show dev n3"
```

---

## 🔧 What It Does Internally

1. Resolves **pod sandbox ID** using `crictl pods`
2. Finds **container ID** within that pod via `crictl ps`
3. Extracts **container PID** using `crictl inspect` + `jq`
4. Creates a symlink at `/var/run/netns/<pod-name>` pointing to the container’s network namespace
5. Optionally executes a command in that namespace via `ip netns exec`

---

## 💡 Why This Is Useful

For debugging eBPF, UPF behavior, traffic flows on N3/N6 interfaces, or understanding CNI configurations, directly entering the pod’s netns is essential — especially when standard `kubectl exec` doesn’t provide visibility into low-level networking.

---

Here are **two helper scripts** to complement your `get_netns.sh` setup:

---

### 🧹 `cleanup_netns.sh` — Remove stale or custom netns links


### 🛠 How to Use

Make both scripts executable:

```bash
chmod +x cleanup_netns.sh list_netns.sh
```

Then:

- Run `./list_netns.sh` to see all your pod netns links
- Run `sudo ./cleanup_netns.sh` to safely remove them

Let me know if you want a combined script to **rebuild all netns symlinks** for active pods!