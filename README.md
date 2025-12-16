# KissNeighbor

A macOS utility that **instantly** resizes the frontmost window to extend rightward until it touches the next adjacent window.

## What it does

KissNeighbor uses the Accessibility API to:
1. Find the frontmost application window
2. Locate the nearest window to the right that overlaps vertically
3. Resize the frontmost window to extend right and "kiss" (touch) that neighbor window

Perfect for quick window tiling without manual resizing.

## Quick Setup

### 1. Compile the binary

```bash
cd ~/Documents/GitHub/KissNeighbor
chmod +x build.sh
./build.sh
```

### 2. Grant Accessibility Permissions

**System Settings → Privacy & Security → Accessibility** → Add **Hammerspoon**

### 3. Install & Configure Hammerspoon

```bash
# Install Hammerspoon
brew install hammerspoon

# The config is already created at ~/.hammerspoon/init.lua
# Just open Hammerspoon from Applications
open /Applications/Hammerspoon.app
```

### 4. Done!

Press **Cmd+Shift+K** anytime to extend the active window right. No UI, instant execution.

## How it works

- **Compiled Objective-C binary** for instant execution (~5ms)
- **Hammerspoon** runs in background as a daemon
- Responds instantly to global hotkeys with zero delay
- No UI popups, completely silent

## Files

- `kissneighbor.m` - Objective-C source
- `build.sh` - Compilation script
- `kissneighbor` - Compiled binary (generated)
- `~/.hammerspoon/init.lua` - Hammerspoon config

## License

MIT
can