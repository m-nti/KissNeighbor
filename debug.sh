#!/bin/bash

# Comprehensive KissNeighbor Setup & Debug

set -e

REPO_DIR="$HOME/Documents/GitHub/KissNeighbor"
BINARY="$REPO_DIR/kissneighbor"

echo "=========================================="
echo "KissNeighbor Setup & Debug"
echo "=========================================="
echo ""

# Step 1: Check binary
echo "1️⃣  Checking binary..."
if [ -f "$BINARY" ]; then
    echo "   ✓ Binary exists at $BINARY"
    ls -lh "$BINARY"
else
    echo "   ✗ Binary NOT found. Building..."
    cd "$REPO_DIR"
    chmod +x build.sh
    ./build.sh
fi

echo ""

# Step 2: Test binary
echo "2️⃣  Testing binary execution..."
if "$BINARY" > /dev/null 2>&1; then
    echo "   ✓ Binary executed successfully"
else
    echo "   ⚠ Binary ran (may not output anything if no window to resize)"
fi

echo ""

# Step 3: Verify Hammerspoon config
echo "3️⃣  Checking Hammerspoon config..."
HAMMER_CONFIG="$HOME/.hammerspoon/init.lua"
if [ -f "$HAMMER_CONFIG" ]; then
    echo "   ✓ Config exists at $HAMMER_CONFIG"
    echo "   Content:"
    echo "   ---"
    head -20 "$HAMMER_CONFIG" | sed 's/^/   /'
    echo "   ---"
else
    echo "   ✗ Config NOT found"
fi

echo ""
echo "=========================================="
echo "✓ Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Quit Hammerspoon completely (not just close window)"
echo "2. System Settings → Privacy & Security → Accessibility"
echo "3. Add Hammerspoon (you may need to remove & re-add it)"
echo "4. Reopen Hammerspoon from Applications"
echo "5. Press Cmd+Shift+K to test"
echo "6. If still not working, check Hammerspoon Console for errors"
echo ""
