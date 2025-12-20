#!/bin/bash

# Diagnostic script for KissNeighbor issues

echo "=========================================="
echo "KissNeighbor Diagnostic Tool"
echo "=========================================="
echo ""

# Check 1: Source file consistency
echo "1️⃣  Checking source files..."
if [ -f "kissneighbor.m" ]; then
    echo "   ✓ Found kissneighbor.m (Objective-C)"
    OBJC_EXISTS=true
else
    echo "   ✗ kissneighbor.m NOT found"
    OBJC_EXISTS=false
fi

if [ -f "main.swift" ]; then
    echo "   ✓ Found main.swift (Swift)"
    SWIFT_EXISTS=true
else
    echo "   ✗ main.swift NOT found"
    SWIFT_EXISTS=false
fi

if [ "$OBJC_EXISTS" = true ] && [ "$SWIFT_EXISTS" = true ]; then
    echo "   ⚠ Both source files exist - potential confusion"
elif [ "$OBJC_EXISTS" = false ] && [ "$SWIFT_EXISTS" = true ]; then
    echo "   ⚠ Only Swift source exists but build script expects Objective-C"
elif [ "$OBJC_EXISTS" = true ] && [ "$SWIFT_EXISTS" = false ]; then
    echo "   ✓ Source files match build script"
fi

echo ""

# Check 2: Binary consistency
echo "2️⃣  Checking binary..."
if [ -f "kissneighbor" ]; then
    echo "   ✓ Binary exists in root directory"
    BINARY_TYPE=$(file kissneighbor | grep -o "Mach-O.*executable")
    echo "   Type: $BINARY_TYPE"
    
    # Check if binary was recently compiled
    SOURCE_TIME=0
    if [ -f "main.swift" ]; then
        SOURCE_TIME=$(stat -f %m main.swift)
    elif [ -f "kissneighbor.m" ]; then
        SOURCE_TIME=$(stat -f %m kissneighbor.m)
    fi
    
    BINARY_TIME=$(stat -f %m kissneighbor)
    if [ "$BINARY_TIME" -lt "$SOURCE_TIME" ]; then
        echo "   ⚠ Binary is older than source file - needs rebuild"
    else
        echo "   ✓ Binary appears up-to-date"
    fi
else
    echo "   ✗ Binary NOT found in root directory"
fi

if [ -f "build/kissneighbor" ]; then
    echo "   ✓ Binary exists in build/ directory"
else
    echo "   ✗ Binary NOT found in build/ directory"
fi

echo ""

# Check 3: Hammerspoon configuration
echo "3️⃣  Checking Hammerspoon..."
HAMMER_CONFIG="$HOME/.hammerspoon/init.lua"
if [ -f "$HAMMER_CONFIG" ]; then
    echo "   ✓ Hammerspoon config exists"
    if grep -q "kissneighbor" "$HAMMER_CONFIG"; then
        echo "   ✓ Config references kissneighbor"
    else
        echo "   ⚠ Config doesn't mention kissneighbor"
    fi
else
    echo "   ✗ Hammerspoon config NOT found"
fi

# Check if Hammerspoon is running
if pgrep -q "Hammerspoon"; then
    echo "   ✓ Hammerspoon process is running"
else
    echo "   ⚠ Hammerspoon is NOT running"
fi

echo ""

# Check 4: Accessibility permissions
echo "4️⃣  Checking accessibility..."
if [ -f "kissneighbor" ]; then
    echo "   Testing accessibility permissions..."
    if ./kissneighbor 2>&1 | grep -q "accessibility"; then
        echo "   ⚠ Accessibility permissions may be missing"
    else
        echo "   ✓ No accessibility errors detected"
    fi
fi

echo ""
echo "=========================================="
echo "Diagnostic Complete"
echo "=========================================="