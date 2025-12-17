#!/bin/bash
# GitHub CLI Installation Script for Ubuntu
# Run with: sudo bash install-gh-cli.sh

set -e

echo "=== Installing GitHub CLI ==="

# Add GitHub CLI repository
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install
apt update
apt install gh -y

echo ""
echo "=== GitHub CLI installed successfully! ==="
echo ""
echo "Next steps:"
echo "1. Run: gh auth login"
echo "2. Follow the prompts to authenticate"
