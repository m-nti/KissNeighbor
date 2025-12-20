#!/bin/bash

# Build script for KissNeighbor
# Run this once to compile the binary

set -e  # Exit on any error

# Configuration
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_FILE="$SCRIPT_DIR/kissneighbor.m"
BINARY_NAME="kissneighbor"
BUILD_DIR="$SCRIPT_DIR/build"
BINARY_PATH="$BUILD_DIR/$BINARY_NAME"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check prerequisites
check_prerequisites() {
    if ! command -v clang &> /dev/null; then
        log_error "clang compiler not found. Please install Xcode Command Line Tools."
        exit 1
    fi
    
    if [[ ! -f "$SOURCE_FILE" ]]; then
        log_error "Source file not found: $SOURCE_FILE"
        exit 1
    fi
}

# Clean previous build
clean_build() {
    log_info "Cleaning previous build..."
    [[ -f "$BINARY_PATH" ]] && rm -f "$BINARY_PATH"
    [[ ! -d "$BUILD_DIR" ]] && mkdir -p "$BUILD_DIR"
}

# Build function
build_binary() {
    log_info "Building KissNeighbor..."
    
    local compiler_flags=(
        -Wall                    # Enable all warnings
        -Wextra                  # Extra warning flags
        -O2                      # Optimization level
        -framework Cocoa
        -framework CoreServices
        -framework ApplicationServices  # Required for AX APIs
        -framework CoreGraphics         # Required for graphics types
        -framework Foundation           # Required for Foundation classes
    )
    
    if clang "${compiler_flags[@]}" "$SOURCE_FILE" -o "$BINARY_PATH"; then
        log_info "✓ Build successful!"
        log_info "Binary created at: $BINARY_PATH"
        
        # Show binary info
        if [[ -f "$BINARY_PATH" ]]; then
            local size=$(du -h "$BINARY_PATH" | cut -f1)
            log_info "Binary size: $size"
        fi
    else
        log_error "✗ Build failed"
        exit 1
    fi
}

# Main execution
main() {
    log_info "Starting KissNeighbor build process..."
    check_prerequisites
    clean_build
    build_binary
    log_info "Build completed successfully!"
}

main "$@"