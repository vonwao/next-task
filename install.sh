#!/bin/bash
# Install sprint to ~/.local/bin

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"

# Install main script
cp "$SCRIPT_DIR/src/sprint" "$INSTALL_DIR/sprint"
chmod +x "$INSTALL_DIR/sprint"

echo "✅ Installed 'sprint' to $INSTALL_DIR/sprint"

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
echo "  sprint init    # Set up project"
echo "  sprint         # Run next task"
echo "  sprint status  # Show status"
