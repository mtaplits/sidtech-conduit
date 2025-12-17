#!/bin/bash
# Conduit Setup Script
# Run this AFTER Docker is installed and you've logged out/in

set -e

echo "=== Conduit Setup Script ==="
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed. Please run install-docker.sh first."
    exit 1
fi

# Check if user can run docker without sudo
if ! docker ps &> /dev/null; then
    echo "ERROR: Cannot run Docker without sudo."
    echo "Please make sure you've:"
    echo "  1. Run the install-docker.sh script"
    echo "  2. Logged out and logged back in (or run 'newgrp docker')"
    exit 1
fi

# Check if docker compose is available
if ! docker compose version &> /dev/null; then
    echo "ERROR: Docker Compose is not available."
    exit 1
fi

echo "✓ Docker is installed and accessible"
echo "✓ Docker Compose is available"
echo ""

# Check Node.js/npm
if ! command -v npm &> /dev/null; then
    echo "ERROR: npm is not installed. Please install Node.js first."
    exit 1
fi

echo "✓ npm is available"
echo ""

echo "Starting Conduit deployment..."
echo "This will download and configure Conduit containers."
echo ""

# Run Conduit CLI deploy setup
npx @conduitplatform/cli deploy setup

echo ""
echo "=== Conduit Setup Complete! ==="
echo ""
echo "The Conduit admin panel should now be open in your browser."
echo "Default credentials: admin / admin"
echo ""
echo "IMPORTANT: Please change the default password after logging in!"
echo ""
