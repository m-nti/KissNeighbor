#!/bin/bash

# KissNeighbor - Extend window to the right
# Pure shell script using JXA (JavaScript for Automation)

osascript -l JavaScript << 'SCRIPT'
const se = Application('System Events');
const frontApp = se.processes.whose({ frontmost: true })[0];
const windows = frontApp.windows();

if (windows.length === 0) throw new Error("No windows");

const frontWindow = windows[0];
const pos = frontWindow.position();
const size = frontWindow.size();
const currentRight = pos[0] + size[0];

let closestWindow = null;
let minDistance = Infinity;

se.processes().forEach(proc => {
    if (proc.name() === frontApp.name()) return;
    try {
        proc.windows().forEach(w => {
            const wPos = w.position();
            const wSize = w.size();
            if (wPos[0] >= currentRight) {
                const overlap = !(pos[1] + size[1] < wPos[1] || pos[1] > wPos[1] + wSize[1]);
                if (overlap) {
                    const distance = wPos[0] - currentRight;
                    if (distance < minDistance) {
                        minDistance = distance;
                        closestWindow = w;
                    }
                }
            }
        });
    } catch (e) {}
});

if (closestWindow) {
    const neighborPos = closestWindow.position();
    frontWindow.size = [neighborPos[0] - pos[0], size[1]];
}
SCRIPT
