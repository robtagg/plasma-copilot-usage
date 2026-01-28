#!/bin/bash
# Install the GitHub Copilot Usage plasmoid

PLASMOID_DIR="$HOME/.local/share/plasma/plasmoids/com.github.copilot-usage"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing GitHub Copilot Usage widget..."

# Check if gh is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "Error: 'gh' CLI is not installed. Install it with: sudo dnf install gh"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Warning: 'gh' CLI is not authenticated. Run: gh auth login"
fi

# Remove old installation if exists
if [ -d "$PLASMOID_DIR" ]; then
    echo "Removing existing installation..."
    rm -rf "$PLASMOID_DIR"
fi

# Create directory and copy files
mkdir -p "$PLASMOID_DIR"
cp -r "$SCRIPT_DIR/metadata.json" "$PLASMOID_DIR/"
cp -r "$SCRIPT_DIR/contents" "$PLASMOID_DIR/"

echo "Installation complete!"
echo ""
echo "To use the widget:"
echo "1. Right-click on your panel -> Add Widgets"
echo "2. Search for 'GitHub Copilot Usage'"
echo "3. Drag it to your panel"
echo ""
echo "The widget uses 'gh' CLI for authentication - no token config needed!"
echo ""
echo "You may need to restart plasmashell:"
echo "  kquitapp6 plasmashell && kstart plasmashell"
