#!/usr/bin/env bash
set -euo pipefail

# ====== CONFIG ======
KEY_NAME="github_deploy"
GITHUB_HOST="github.com"
EMAIL_TAG="smart.jamesjin@gmail.com"
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"
CONFIG_PATH="$SSH_DIR/config"
# ====================

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generate key if it doesn't exist
if [[ ! -f "$KEY_PATH" ]]; then
  ssh-keygen -t ed25519 -a 100 -f "$KEY_PATH" -C "$EMAIL_TAG" -N ""
  chmod 600 "$KEY_PATH"
  chmod 644 "$KEY_PATH.pub"
  echo "✅ Created key: $KEY_PATH"
else
  echo "ℹ️ Key already exists: $KEY_PATH"
fi

# Add GitHub host key to known_hosts (prevents interactive prompt)
touch "$SSH_DIR/known_hosts"
chmod 600 "$SSH_DIR/known_hosts"
ssh-keyscan -H "$GITHUB_HOST" >> "$SSH_DIR/known_hosts" 2>/dev/null || true

# Add SSH config entry (idempotent-ish)
if ! grep -q "Host github.com-$KEY_NAME" "$CONFIG_PATH" 2>/dev/null; then
  cat >> "$CONFIG_PATH" <<EOF

Host github.com-$KEY_NAME
  HostName github.com
  User git
  IdentityFile $KEY_PATH
  IdentitiesOnly yes
EOF
  chmod 600 "$CONFIG_PATH"
  echo "✅ Added SSH config host alias: github.com-$KEY_NAME"
else
  echo "ℹ️ SSH config alias already present: github.com-$KEY_NAME"
fi

echo
echo "🔑 Public key (add this to GitHub as a Deploy key or SSH key):"
echo "------------------------------------------------------------"
cat "$KEY_PATH.pub"
echo "------------------------------------------------------------"
echo
echo "Test command after adding key on GitHub:"
echo "  ssh -T git@github.com"
echo
echo "If you use the alias in git remote, set remote like:"
echo "  git remote set-url origin git@github.com-$KEY_NAME:OWNER/REPO.git"
