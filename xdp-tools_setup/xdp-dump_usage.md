
# **Usage README**

# XDP Dump - Usage Guide

`xdp-dump` is a powerful tool for capturing and dumping network traffic from XDP-enabled interfaces, providing various options for filtering, logging, and analyzing network traffic.

## Basic Command

After a successful installation, you can use the `xdp-dump` tool to capture traffic from an interface:

```bash
sudo xdp-dump -i <interface>
```

Replace `<interface>` with the name of the interface you want to capture traffic on, for example:

```bash
sudo xdp-dump -i eth0
```

---

## Advanced Command Options

### 1. **Capture Direction with `--rx-capture`**

Specify the capture point for the RX (receive) direction:

```bash
--rx-capture <mode>
```

- **Valid values**: `entry`, `exit`

    - `entry`: Capture packets at the entry point to the kernel (before network stack processing).
    - `exit`: Capture packets after they have passed through the kernel network stack.

Example:

```bash
sudo xdp-dump -i eth0 --rx-capture entry
```

### 2. **XDP Program Mode (`--load-xdp-mode`)**

Control the XDP mode for loading the program:

```bash
--load-xdp-mode <mode>
```

- **Valid values**: `native`, `skb`, `hw`, `unspecified`

    - `native`: XDP in native mode, best performance.
    - `skb`: XDP applied to the software packet buffer.
    - `hw`: XDP at the hardware level.
    - `unspecified`: Default mode.

Example:

```bash
sudo xdp-dump -i eth0 --load-xdp-mode native
```

### 3. **List Available Interfaces**

To list available network interfaces that support XDP, run:

```bash
sudo xdp-dump -D
```

### 4. **Load XDP Program (`--load-xdp-program`)**

If no XDP program is loaded, this option automatically loads a trace program:

```bash
--load-xdp-program
```

Example:

```bash
sudo xdp-dump -i eth0 --load-xdp-program
```

### 5. **Specify Program to Attach (`-p` or `--program-names`)**

Attach a specific program to the interface:

```bash
-p, --program-names <prog>
```

Example:

```bash
sudo xdp-dump -i eth0 --program-names xdp_prog
```

### 6. **Promiscuous Mode (`-P` or `--promiscuous-mode`)**

Enable promiscuous mode to capture all packets on the network:

```bash
-P, --promiscuous-mode
```

Example:

```bash
sudo xdp-dump -i eth0 --promiscuous-mode
```

### 7. **Packet Snapshot Length (`-s` or `--snapshot-length`)**

Define the minimum bytes of packet to capture:

```bash
-s, --snapshot-length <snaplen>
```

Example:

```bash
sudo xdp-dump -i eth0 -s 128
```

### 8. **Use Legacy PCAP Format (`--use-pcap`)**

Enable legacy pcap format for compatibility with other packet analysis tools:

```bash
--use-pcap
```

Example:

```bash
sudo xdp-dump -i eth0 --use-pcap
```

### 9. **Write Packets to Pcap File (`-w` or `--write`)**

Write the captured packets to a pcap file:

```bash
-w, --write <file>
```

Example:

```bash
sudo xdp-dump -i eth0 -w capture.pcap
```

### 10. **Print Packets in Hex (`-x` or `--hex`)**

Print the packet data in hexadecimal format:

```bash
-x, --hex
```

Example:

```bash
sudo xdp-dump -i eth0 -x
```

### 11. **Verbose Logging (`-v` or `--verbose`)**

Enable verbose output for detailed logging:

```bash
-v, --verbose
```

Example:

```bash
sudo xdp-dump -i eth0 -v
```

### 12. **Display Version Information (`--version`)**

Display version information for the tool:

```bash
--version
```

Example:

```bash
xdp-dump --version
```

---

## Notes

- **Permissions**: `xdp-dump` requires root privileges to capture network traffic, so run with `sudo`.
- **Capture Points**: Choose `entry` or `exit` depending on whether you want to capture packets entering or exiting the kernel network stack.
- **Program Mode**: Ensure that the correct XDP mode (`native`, `skb`, `hw`) is used depending on your network setup and requirements.

For full documentation and updates, refer to the [xdp-tools GitHub repository](https://github.com/xdp-project/xdp-tools).

---

This setup splits the installation instructions and usage documentation into two distinct README files, making it easier to follow depending on the user's needs.