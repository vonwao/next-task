#!/bin/bash
# Install next-task to ~/.local/bin

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"

# Install main script
cp "$SCRIPT_DIR/src/next" "$INSTALL_DIR/next"
chmod +x "$INSTALL_DIR/next"

echo "✅ Installed 'next' to $INSTALL_DIR/next"

# Check if in PATH
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  echo ""
  echo "⚠️  $INSTALL_DIR is not in your PATH"
  echo "   Add this to your ~/.zshrc or ~/.bashrc:"
  echo ""
  echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo "Usage:"
echo "  cd ~/dev/your-project"
echo "  next init    # Set up project"
echo "  next         # Run next task"
echo "  next status  # Show status"
