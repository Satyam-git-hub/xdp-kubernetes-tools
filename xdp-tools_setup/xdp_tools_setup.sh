#!/bin/bash

# Define the version of xdp-tools and crictl to install (can be set to 'latest' for the latest version)
XDPTOOLS_VERSION="main"  # Change this to a specific tag or 'main' for the latest version

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install dependencies
install_dependencies() {
  echo "Installing required dependencies..."

  sudo apt update
  sudo apt install -y build-essential clang llvm libelf-dev libpcap-dev pkg-config libmnl-dev libbpf-dev m4
  sudo apt install -y libcap-ng-dev
}

# Function to clone the xdp-tools repository and build it
clone_and_build_xdp_tools() {
  echo "Cloning the xdp-tools repository..."

  # Clone the repository
  git clone https://github.com/xdp-project/xdp-tools.git
  cd xdp-tools

  # Checkout the specified version or 'main' if latest
  git checkout $XDPTOOLS_VERSION

  echo "Running the build process..."

  # Run the configuration script and build
  ./configure
  make
}

# Function to install xdp-tools binaries
install_xdp_tools() {
  echo "Installing xdp-tools..."

  sudo make install
}

# Function to verify the installation
verify_installation() {
  echo "Verifying the xdp-dump installation..."

  # Check if xdp-dump is available
  if command_exists xdp-dump; then
    echo "xdp-dump installed successfully!"
  else
    echo "xdp-dump installation failed!"
    exit 1
  fi
}

# Function to set up xdp-dump environment (optional)
setup_xdp_dump_env() {
  echo "Setting up the xdp-dump environment..."

  # Optionally create a symbolic link or set up any environment variables
  # For example, add xdp-dump to PATH (if installed locally)
  if ! command_exists xdp-dump; then
    echo "Adding xdp-dump to PATH"
    export PATH=$PATH:/usr/local/bin
  fi
}

# Main setup function
setup() {
  echo "Starting the setup process..."

  # Install dependencies
  install_dependencies

  # Clone and build xdp-tools
  clone_and_build_xdp_tools

  # Install the xdp-tools binaries
  install_xdp_tools

  # Verify the installation
  verify_installation

  # Optionally set up environment
  setup_xdp_dump_env

  echo "Setup completed successfully!"
}

# Execute the setup function
setup
