#!/bin/bash

# Check for help flag first
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [-N] USERNAME"
    echo "Options:"
    echo "  -N         Create new user with no shell access (network-only mode)"
    echo "  -h, --help Show this help message"
    exit 0
fi

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

NETWORK_ONLY=0

# Check for -N flag
if [ "$1" = "-N" ]; then
    NETWORK_ONLY=1
    shift
fi

# Get username
if [ -z "$1" ]; then
    read -p "Enter username: " USERNAME
else
    USERNAME="$1"
fi

if [ -z "$USERNAME" ]; then
    echo "Error: Username cannot be empty"
    exit 1
fi

# Determine the correct home directory
if [ "$USERNAME" = "root" ]; then
    HOME_DIR="/root"
else
    HOME_DIR="/home/$USERNAME"
fi

# Create user if doesn't exist
if ! id "$USERNAME" &>/dev/null; then
    if [ $NETWORK_ONLY -eq 1 ]; then
        useradd -m -s /usr/sbin/nologin "$USERNAME"
        echo "User $USERNAME created (network-only mode, no shell)"
    else
        useradd -m -s /bin/bash "$USERNAME"
        echo "User $USERNAME created"
    fi
else
    echo "User $USERNAME already exists - just adding SSH key"
fi

# Create SSH directory
SSH_DIR="$HOME_DIR/.ssh"
mkdir -p "$SSH_DIR"

# Generate SSH key
KEY_FILE="$SSH_DIR/id_ed25519"
ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -C "$USERNAME@$(hostname)"

# Setup authorized_keys
cat "$KEY_FILE.pub" > "$SSH_DIR/authorized_keys"

# Fix permissions
chmod 700 "$SSH_DIR"
chmod 600 "$KEY_FILE"
chmod 644 "$KEY_FILE.pub"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R "$USERNAME":"$USERNAME" "$HOME_DIR"

# Show key locations
echo "Key files created:"
echo "Private key: $KEY_FILE"
echo "Public key: $KEY_FILE.pub"
echo "Keys added to: $SSH_DIR/authorized_keys"
echo ""
echo "To use this key for SSH:"
echo "ssh -i $KEY_FILE $USERNAME@hostname"
