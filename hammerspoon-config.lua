-- KissNeighbor - Extend window right with Option+Cmd+K
-- Enhanced version with debugging and error handling

-- Function to show debug alerts
function debugAlert(message)
    -- Uncomment the line below to see debug messages
    hs.alert.show(message, 3)
    print("[KissNeighbor] " .. message)
end

-- Main window extension function
local function extendWindowRight()
    debugAlert("Starting window extension...")
    
    local result = hs.osascript.javascript([=[
        (() => {
            try {
                const se = Application('System Events');
                se.includeStandardAdditions = true;
                
                // Get frontmost application
                const frontApp = se.processes.whose({frontmost: true})[0];
                if (!frontApp) {
                    return {error: "No frontmost application found"};
                }
                
                const appName = frontApp.name();
                const windows = frontApp.windows;
                if (!windows || windows.length === 0) {
                    return {error: "No windows found in frontmost app: " + appName};
                }
                
                const frontWindow = windows[0];
                const pos = frontWindow.position;
                const size = frontWindow.size;
                
                if (!pos || !size) {
                    return {error: "Could not get window position/size"};
                }
                
                const currentRight = pos[0] + size[0];
                let closest = null;
                let minDist = Infinity;
                let windowCount = 0;
                
                // Check all other processes
                const allProcs = se.processes.where({name: {"!=": appName}});
                
                for (let i = 0; i < allProcs.length; i++) {
                    try {
                        const proc = allProcs[i];
                        // Skip hidden processes
                        if (proc.windows === undefined) continue;
                        
                        const procWindows = proc.windows;
                        if (!procWindows || procWindows.length === 0) continue;
                        
                        for (let j = 0; j < procWindows.length; j++) {
                            const w = procWindows[j];
                            try {
                                const wPos = w.position;
                                const wSize = w.size;
                                
                                if (!wPos || !wSize) continue;
                                if (wPos[0] < currentRight) continue;
                                
                                // Check if window is vertically aligned
                                const verticalOverlap = !(pos[1] + size[1] < wPos[1] || pos[1] > wPos[1] + wSize[1]);
                                
                                if (verticalOverlap) {
                                    const dist = wPos[0] - currentRight;
                                    if (dist < minDist && dist > 0) {
                                        minDist = dist;
                                        closest = w;
                                    }
                                    windowCount++;
                                }
                            } catch (e) {
                                // Skip windows that can't be accessed
                            }
                        }
                    } catch(e) {
                        // Skip processes that can't be accessed
                    }
                }
                
                if (closest && minDist < Infinity) {
                    const neighborPos = closest.position;
                    const newWidth = neighborPos[0] - pos[0];
                    
                    if (newWidth > size[0]) {  // Only expand, don't shrink
                        frontWindow.size = [newWidth, size[1]];
                        return {
                            success: true,
                            appName: appName,
                            oldWidth: size[0],
                            newWidth: newWidth,
                            windowsChecked: windowCount
                        };
                    } else {
                        return {error: "No space to expand window"};
                    }
                } else {
                    return {error: "No neighboring window found to the right"};
                }
            } catch(e) {
                return {error: "Script error: " + e.toString()};
            }
        })();
    ]=])
    
    -- Handle the result
    if type(result) == "table" and result.success then
        debugAlert(string.format("Extended %s window from %d to %dpx",
            result.appName, result.oldWidth, result.newWidth))
    elseif type(result) == "table" and result.error then
        debugAlert("Failed: " .. result.error)
        hs.alert.show("KissNeighbor: " .. result.error, 2)
    elseif type(result) == "boolean" then
        debugAlert("Script executed but returned no data")
        hs.alert.show("KissNeighbor: No windows found to resize", 2)
    else
        debugAlert("Unexpected result type: " .. type(result))
        hs.alert.show("KissNeighbor: Unexpected error", 2)
    end
end

-- Bind the hotkey
hs.hotkey.bind({"alt", "cmd"}, "K", function()
    extendWindowRight()
end)

-- Show ready message
hs.alert.show("KissNeighbor ready - Press ⌥⌘K", 2)
debugAlert("KissNeighbor loaded successfully")

-- Optional: Add a menu bar item for manual testing
menubar = hs.menubar.new()
menubar:setTitle("🪟")
menubar:setTooltip("KissNeighbor - Click to extend window right")

menubar:setClickCallback(function()
    extendWindowRight()
end)

debugAlert("Menu bar item added")