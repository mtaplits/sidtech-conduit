#!/bin/bash
# Docker Installation Script for Ubuntu 24.04
# Run this script with: sudo bash install-docker.sh

set -e

echo "=== Docker Installation Script for Ubuntu 24.04 ==="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo: sudo bash install-docker.sh"
    exit 1
fi

# Get the actual user (not root)
ACTUAL_USER=${SUDO_USER:-$USER}

echo "Step 1: Updating package index..."
apt-get update

echo ""
echo "Step 2: Installing prerequisites..."
apt-get install -y ca-certificates curl gnupg

echo ""
echo "Step 3: Adding Docker's official GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo ""
echo "Step 4: Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo ""
echo "Step 5: Installing Docker Engine..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo ""
echo "Step 6: Adding user '$ACTUAL_USER' to docker group..."
usermod -aG docker $ACTUAL_USER

echo ""
echo "Step 7: Starting Docker service..."
systemctl start docker
systemctl enable docker

echo ""
echo "=== Docker Installation Complete! ==="
echo ""
echo "IMPORTANT: You need to log out and log back in for the group changes to take effect."
echo "Or run: newgrp docker"
echo ""
echo "To verify the installation, run: docker run hello-world"
echo ""
