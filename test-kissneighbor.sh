#!/bin/bash

# Test script for KissNeighbor functionality

echo "=========================================="
echo "KissNeighbor Test Script"
echo "=========================================="
echo ""

# Check if Hammerspoon is running
if ! pgrep -q "Hammerspoon"; then
    echo "❌ Hammerspoon is not running"
    echo "Please start Hammerspoon first"
    exit 1
fi

echo "✅ Hammerspoon is running"
echo ""

# Check if the config was loaded
echo "🔍 Checking configuration..."
if grep -q "KissNeighbor loaded successfully" ~/.hammerspoon/init.lua; then
    echo "✅ Enhanced KissNeighbor config is installed"
else
    echo "⚠️ Standard KissNeighbor config detected"
fi

echo ""
echo "🧪 Testing KissNeighbor..."
echo ""

# Test 1: Menu bar test
echo "Test 1: Menu bar icon"
echo "Look for a 🪟 icon in your menu bar"
echo "Click it to test window extension"
echo ""

# Test 2: Hotkey test
echo "Test 2: Hotkey test"
echo "Press ⌥⌘K (Option+Command+K) to test"
echo ""

# Test 3: Manual window setup
echo "Test 3: Manual test setup"
echo "1. Open two applications (e.g., Finder and TextEdit)"
echo "2. Position them side by side with a gap"
echo "3. Focus the left window"
echo "4. Press ⌥⌘K or click the 🪟 icon"
echo ""

# Test 4: Debug mode
echo "Test 4: Enable debug mode"
echo "To see debug messages:"
echo "1. Open Hammerspoon Console (right-click Hammerspoon icon → Open Console)"
echo "2. Uncomment line 7 in ~/.hammerspoon/init.lua"
echo "3. Reload config with ⌘⇧R"
echo ""

echo "=========================================="
echo "Troubleshooting:"
echo "=========================================="
echo "If it's not working:"
echo ""
echo "1. Check Accessibility permissions:"
echo "   System Settings → Privacy & Security → Accessibility"
echo "   Make sure Hammerspoon is enabled"
echo ""
echo "2. Check Hammerspoon Console for errors:"
echo "   Right-click Hammerspoon icon → Open Console"
echo ""
echo "3. Try the menu bar icon instead of hotkey"
echo ""
echo "4. Make sure windows have space to expand"
echo "   (there must be a neighboring window to the right)"
echo ""
echo "5. Some apps may block window manipulation"
echo "   Try with Finder or TextEdit windows"