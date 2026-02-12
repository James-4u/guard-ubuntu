#!/bin/bash

set -e

EMAIL="smart.jamesjin@gmail.com"
KEY_PATH="$HOME/.ssh/id_ed25519"

echo "========================================"
echo "SSH Key Generation Script"
echo "========================================"

# Create .ssh directory if not exists
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# Check if key already exists
if [ -f "$KEY_PATH" ]; then
    echo ""
    echo "SSH key already exists at $KEY_PATH"
    echo "Skipping generation."
else
    echo ""
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH" -N ""
    echo "SSH key generated successfully."
fi

# Fix permissions
chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"

echo ""
echo "========================================"
echo "YOUR PUBLIC KEY:"
echo "========================================"
cat "$KEY_PATH.pub"

echo ""
echo "========================================"
echo "Copy above key and add to server:"
echo "~/.ssh/authorized_keys"
echo "========================================"
