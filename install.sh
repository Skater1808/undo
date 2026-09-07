#!/usr/bin/env bash
set -euo pipefail

REPO="Skater1808/undo"
VERSION="${1:-latest}"
INSTALL_DIR="${HOME}/.local/bin"

echo "Installing undo..."

# Create install dir
mkdir -p "$INSTALL_DIR"

# Download
if [ "$VERSION" = "latest" ]; then
    URL="https://raw.githubusercontent.com/$REPO/master/undo"
else
    URL="https://raw.githubusercontent.com/$REPO/$VERSION/undo"
fi

curl -sL "$URL" -o "$INSTALL_DIR/undo"
chmod +x "$INSTALL_DIR/undo"

# Detect shell and add hook
SHELL_NAME=$(basename "${SHELL:-/bin/bash}")
HOOK_LINE='eval "$(undo --hook)"'

add_to_config() {
    local config="$1"
    if [ -f "$config" ] && grep -qF 'undo --hook' "$config"; then
        echo "Hook already in $config"
        return
    fi
    echo "" >> "$config"
    echo "# undo - automatic filesystem undo (https://github.com/Skater1808/undo)" >> "$config"
    echo "$HOOK_LINE" >> "$config"
    echo "Added hook to $config"
}

case "$SHELL_NAME" in
    zsh)  add_to_config "${HOME}/.zshrc" ;;
    bash) add_to_config "${HOME}/.bashrc" ;;
    *)    add_to_config "${HOME}/.bashrc"; add_to_config "${HOME}/.zshrc" ;;
esac

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo ""
    echo "⚠  $INSTALL_DIR is not in your PATH."
    echo "   Add this to your shell config:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo "✓ Done! Restart your shell or run:"
echo "  source ~/${SHELL_NAME}rc"
echo ""
echo "Usage:"
echo "  rm important.txt   # just use your shell normally"
echo "  undo               # pick which command to undo"
