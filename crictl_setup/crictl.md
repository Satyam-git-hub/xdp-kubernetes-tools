Here’s a simple and clean **README** for installing `crictl` and configuring its `crictl.yaml`—especially useful if you're dealing with RKE2, containerd, or debugging pods in custom CNI setups like macvlan with Multus in a 5G Core deployment.


---

## 🛠️ Install `crictl` by script

This project includes a helper script to install [`crictl`](https://github.com/kubernetes-sigs/cri-tools) – a CLI for interacting with CRI-compatible container runtimes.

### 🔧 Default Setup (v1.32.0)

To install the default version (`v1.32.0`) and configure `crictl.yaml`:

```bash
chmod +x crictl-install.sh
./crictl-install.sh
```

### 📦 Install a Specific Version

To install another version (e.g., `v1.31.0`), pass it as an argument:

```bash
./crictl-install.sh v1.31.0
```

### ⚙️ Configuration

After installation, the script creates the config file at `/etc/crictl.yaml` with the following default runtime endpoint (you can change it if needed):

```yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
```

---

---

## 📦 crictl self Setup Guide

`crictl` is a CLI tool for debugging and interacting with CRI-compatible container runtimes like containerd or cri-o.

### ✅ Step 1: Download crictl

Visit the [official GitHub releases page](https://github.com/kubernetes-sigs/cri-tools/releases) or use the commands below:

```bash
# Choose a version (adjust if needed)
VERSION="v1.32.0"

# Download crictl
curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${VERSION}/crictl-${VERSION}-linux-amd64.tar.gz

# Extract and move to /usr/local/bin
tar zxvf crictl-${VERSION}-linux-amd64.tar.gz
sudo mv crictl /usr/local/bin/

# Verify installation
crictl --version
```

---

### ⚙️ Step 2: Configure `crictl.yaml`

By default, `crictl` looks for its config in `/etc/crictl.yaml`.

For **RKE2** or **containerd**, your runtime socket will likely be:

```
/run/k3s/containerd/containerd.sock
```

Or with **default RKE2 setups**:

```
/run/containerd/containerd.sock
```

#### Create the file:
```bash
sudo tee /etc/crictl.yaml > /dev/null <<EOF
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
timeout: 10
debug: false
EOF
```

To verify:
```bash
crictl info
```

---

### 🛠 Common Uses

```bash
crictl ps -a             # List all containers
crictl images            # List images
crictl pods              # List pods
crictl inspect <id>      # Inspect a container or pod
crictl logs <container>  # Get logs
```

---

### 🧠 Tip for RKE2 Clusters

If you're using **RKE2**, the socket is already set up by RKE2 internally. You don't need to install containerd manually. This tool helps with low-level pod/container debugging—especially in CNI issues, like:

- Multus/macvlan troubleshooting  
- Inspecting UPF/AMF pod crashes in 5GC  
- Debugging NAD-based interfaces  

---

