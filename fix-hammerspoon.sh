#!/bin/bash

# Fix script for KissNeighbor Hammerspoon configuration

set -e

echo "=========================================="
echo "KissNeighbor Hammerspoon Fix"
echo "=========================================="
echo ""

# Backup existing config
HAMMER_CONFIG="$HOME/.hammerspoon/init.lua"
BACKUP_CONFIG="$HOME/.hammerspoon/init.lua.backup"

if [ -f "$HAMMER_CONFIG" ]; then
    echo "📦 Backing up existing config..."
    cp "$HAMMER_CONFIG" "$BACKUP_CONFIG"
    echo "   ✓ Backup saved to $BACKUP_CONFIG"
fi

echo ""

# Install new config
echo "🔧 Installing improved KissNeighbor config..."
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
NEW_CONFIG="$REPO_DIR/hammerspoon-config.lua"

if [ -f "$NEW_CONFIG" ]; then
    cp "$NEW_CONFIG" "$HAMMER_CONFIG"
    echo "   ✓ New config installed"
else
    echo "   ✗ New config not found at $NEW_CONFIG"
    exit 1
fi

echo ""

# Check Hammerspoon status
echo "🔍 Checking Hammerspoon status..."
if pgrep -q "Hammerspoon"; then
    echo "   ✓ Hammerspoon is running"
    echo "   🔄 Reloading configuration..."
    # Use Hammerspoon's built-in reload mechanism
    osascript -e 'tell application "System Events" to tell process "Hammerspoon" to keystroke "r" using {command down, shift down}'
    sleep 1
    echo "   ✓ Configuration reloaded (⌘⇧R)"
else
    echo "   ⚠ Hammerspoon is not running"
    echo "   🚀 Starting Hammerspoon..."
    open -a Hammerspoon
    echo "   ✓ Hammerspoon started"
fi

echo ""
echo "=========================================="
echo "✓ Fix Complete!"
echo "=========================================="
echo ""
echo "Testing instructions:"
echo "1. Open two windows side by side"
echo "2. Focus the left window"
echo "3. Press ⌥⌘K (Option+Command+K)"
echo "4. Or click the 🪟 icon in your menu bar"
echo ""
echo "If it still doesn't work:"
echo "- Check Hammerspoon Console (click Hammerspoon icon → Open Console)"
echo "- Make sure Hammerspoon has Accessibility permissions"
echo "- Try the menu bar icon as an alternative to the hotkey"