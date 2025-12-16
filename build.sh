#!/bin/bash

# Build script for KissNeighbor
# Run this once to compile the binary

cd "$(dirname "$0")"

echo "Compiling KissNeighbor..."
clang -framework Cocoa -framework CoreServices kissneighbor.m -o kissneighbor

if [ -f kissneighbor ]; then
    echo "✓ Build successful! Binary ready at: $(pwd)/kissneighbor"
else
    echo "✗ Build failed"
    exit 1
fi
