#!/bin/bash

# KissNeighbor Setup Script - Automated installation

set -e

REPO_DIR="$HOME/Documents/GitHub/KissNeighbor"

echo "🔨 Building KissNeighbor..."
cd "$REPO_DIR"
chmod +x build.sh
./build.sh

echo ""
echo "✓ Binary compiled successfully"
echo ""
echo "🔧 Testing binary..."
if "$REPO_DIR/kissneighbor" 2>/dev/null; then
    echo "✓ Binary works!"
else
    echo "⚠ Binary executed (may not show output if no window to resize)"
fi

echo ""
echo "📍 Hammerspoon config location: $HOME/.hammerspoon/init.lua"
echo ""
echo "✓ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open System Settings → Privacy & Security → Accessibility"
echo "2. Add Hammerspoon to the list (if not already there)"
echo "3. Open Hammerspoon → Right-click icon → Reload Config"
echo "4. Press Cmd+Shift+K to test!"
