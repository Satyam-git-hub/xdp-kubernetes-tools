Sure! Here's the updated version with **two separate README files**:

---

### **Installation README**

# XDP tools - Installation Guide

## Prerequisites

Before you begin the installation, ensure that your system meets the following prerequisites:

### System Dependencies

```bash
sudo apt update
sudo apt install -y build-essential clang llvm libelf-dev libpcap-dev pkg-config libmnl-dev libbpf-dev m4
```

You may also need to install:

```bash
sudo apt install -y libcap-ng-dev
```

These dependencies are required to build and use the `xdp-dump` tool.

### Kernel Support for XDP

Ensure that your system's Linux kernel supports XDP. XDP is available in Linux kernels from version 4.8 onwards. You will need a kernel that has XDP support built in.

---

## **Installation Steps**

### 1. **Clone the Repository**

Clone the `xdp-tools` repository:

```bash
git clone https://github.com/xdp-project/xdp-tools.git
cd xdp-tools
```

### 2. **Build the Tools**

Run the `./configure` script to prepare the build environment:

```bash
./configure
```

Then, compile the tools:

```bash
make
```

Optionally, if you want to install the binaries system-wide, run:

```bash
sudo make install
```

This will install the `xdp-dump` binary to a default system directory (e.g., `/usr/local/bin`).

### 3. **Check Installation**

If you ran `make install`, you can verify the installation by running:

```bash
xdp-dump --version
```

If you built without installation (`make` only), you can run `xdp-dump` from the build directory:

```bash
./xdp-dump/xdp-dump --version
```

## Below is a bash script that automates the installation and setup of `xdp-dump`, including all the dependencies, building the tool, and ensuring it's ready for use.


### **How to Use the Script**:

1. **Save the Script**:
   Save the script to a file, e.g., `setup_xdpdump.sh`.

2. **Make the Script Executable**:
   Run the following command to make the script executable:

   ```bash
   chmod +x setup_xdpdump.sh
   ```

3. **Run the Script**:
   Now, execute the script to automate the installation and setup process:

   ```bash
   ./setup_xdpdump.sh
   ```

### **What the Script Does**:

1. **Installs Dependencies**: It installs all the necessary packages like `clang`, `llvm`, `libpcap-dev`, etc.
2. **Clones the xdp-tools Repo**: It clones the latest version of the `xdp-tools` repository or any specific branch/tag you specify.
3. **Builds xdp-tools**: Runs the necessary steps to configure and build the tool using `make`.
4. **Installs the Tool**: Optionally installs the binaries system-wide using `make install`.
5. **Verifies Installation**: It checks if `xdp-dump` is correctly installed and available.
6. **Sets Up Environment**: Optionally adds `xdp-dump` to the system's `PATH` if it's not installed globally or sets any required environment variables.

---

### **Notes**:

- You can change the version of `xdp-tools` by setting the `XDPTOOLS_VERSION` variable to a specific branch/tag or leave it as `main` for the latest.
- The script assumes you're working on an Ubuntu-based system. Adjust the installation of dependencies if you're using another distribution.


---
