# KissNeighbor

A macOS utility that instantly resizes the frontmost window to extend rightward until it touches the next adjacent window.

## What it does

KissNeighbor uses the Accessibility API to:
1. Find the frontmost application window
2. Locate the nearest window to the right that overlaps vertically
3. Resize the frontmost window to extend right and "kiss" (touch) that neighbor window

Perfect for quick window tiling without manual resizing.

## Installation

### With Raycast (Recommended)

1. Copy `kissneighbor.sh` to `~/.config/raycast/scripts/`
2. Open Raycast and search for "KissNeighbor"
3. Go to Raycast Preferences → Hotkeys
4. Assign **Cmd+Shift+K** to KissNeighbor
5. Grant Raycast Accessibility permissions in **System Settings → Privacy & Security → Accessibility**

### Manual usage

```bash
./kissneighbor.sh
```

## How it works

Pure shell script using JXA (JavaScript for Automation):
- Instant execution with zero Swift runtime overhead
- Finds the frontmost window
- Scans all other app windows for ones to the right
- Resizes to touch the closest neighbor

## Permissions

KissNeighbor requires Accessibility permissions to interact with windows. Grant access in:

**System Settings → Privacy & Security → Accessibility**

Add Raycast to the list (or Terminal if running manually).

## License

MIT
