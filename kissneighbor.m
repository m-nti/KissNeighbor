#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>

int main() {
    @autoreleasepool {
        NSLog(@"KissNeighbor starting...");
        
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSRunningApplication *frontApp = [workspace frontmostApplication];
        
        if (!frontApp) {
            NSLog(@"Error: No frontmost app");
            return 1;
        }
        
        NSLog(@"Frontmost app: %@", [frontApp bundleIdentifier]);
        
        pid_t pid = [frontApp processIdentifier];
        NSLog(@"PID: %d", pid);
        
        AXUIElementRef appRef = AXUIElementCreateApplication(pid);
        if (!appRef) {
            NSLog(@"Error: Could not create AXUIElement");
            return 1;
        }
        
        NSLog(@"Got AXUIElement");
        
        CFArrayRef windows = NULL;
        AXError result = AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef *)&windows);
        
        NSLog(@"AXUIElementCopyAttributeValue result: %d", result);
        
        if (result != kAXErrorSuccess) {
            NSLog(@"Error getting windows: %d", result);
            CFRelease(appRef);
            return 1;
        }
        
        if (!windows) {
            NSLog(@"Error: windows is NULL");
            CFRelease(appRef);
            return 1;
        }
        
        CFIndex windowCount = CFArrayGetCount(windows);
        NSLog(@"Window count: %ld", windowCount);
        
        if (windowCount == 0) {
            NSLog(@"Error: No windows");
            CFRelease(windows);
            CFRelease(appRef);
            return 1;
        }
        
        AXUIElementRef frontWindow = (AXUIElementRef)CFArrayGetValueAtIndex(windows, 0);
        NSLog(@"Got front window");
        
        CFTypeRef posRef = NULL;
        AXUIElementCopyAttributeValue(frontWindow, kAXPositionAttribute, &posRef);
        
        if (posRef) {
            CGPoint pos;
            AXValueGetValue((AXValueRef)posRef, kAXValueTypeCGPoint, &pos);
            NSLog(@"Window position: %.0f, %.0f", pos.x, pos.y);
            CFRelease(posRef);
        }
        
        NSLog(@"Test complete");
        CFRelease(windows);
        CFRelease(appRef);
    }
    return 0;
}
        
        AXUIElementRef frontWindow = (AXUIElementRef)CFArrayGetValueAtIndex(windows, 0);
        
        CFTypeRef posRef = NULL, sizeRef = NULL;
        AXUIElementCopyAttributeValue(frontWindow, kAXPositionAttribute, &posRef);
        AXUIElementCopyAttributeValue(frontWindow, kAXSizeAttribute, &sizeRef);
        
        if (!posRef || !sizeRef) {
            fprintf(stderr, "Error: Could not get window position/size\n");
            if (posRef) CFRelease(posRef);
            if (sizeRef) CFRelease(sizeRef);
            CFRelease(windows);
            CFRelease(appRef);
            return 1;
        }
        
        CGPoint pos;
        CGSize size;
        AXValueGetValue((AXValueRef)posRef, kAXValueTypeCGPoint, &pos);
        AXValueGetValue((AXValueRef)sizeRef, kAXValueTypeCGSize, &size);
        
        CFRelease(posRef);
        CFRelease(sizeRef);
        
        CGFloat currentRight = pos.x + size.width;
        
        AXUIElementRef closestWindow = NULL;
        CGFloat minDistance = CGFLOAT_MAX;
        
        for (NSRunningApplication *app in [workspace runningApplications]) {
            if (app.processIdentifier == pid || app.isHidden) continue;
            
            AXUIElementRef appRef2 = AXUIElementCreateApplication(app.processIdentifier);
            if (!appRef2) continue;
            
            CFArrayRef windows2 = NULL;
            AXUIElementCopyAttributeValue(appRef2, kAXWindowsAttribute, (CFTypeRef *)&windows2);
            
            if (!windows2) {
                CFRelease(appRef2);
                continue;
            }
            
            for (CFIndex i = 0; i < CFArrayGetCount(windows2); i++) {
                AXUIElementRef w = (AXUIElementRef)CFArrayGetValueAtIndex(windows2, i);
                
                CFTypeRef wPosRef = NULL, wSizeRef = NULL;
                AXUIElementCopyAttributeValue(w, kAXPositionAttribute, &wPosRef);
                AXUIElementCopyAttributeValue(w, kAXSizeAttribute, &wSizeRef);
                
                if (!wPosRef || !wSizeRef) {
                    if (wPosRef) CFRelease(wPosRef);
                    if (wSizeRef) CFRelease(wSizeRef);
                    continue;
                }
                
                CGPoint wPos;
                CGSize wSize;
                AXValueGetValue((AXValueRef)wPosRef, kAXValueTypeCGPoint, &wPos);
                AXValueGetValue((AXValueRef)wSizeRef, kAXValueTypeCGSize, &wSize);
                
                CFRelease(wPosRef);
                CFRelease(wSizeRef);
                
                if (wPos.x >= currentRight) {
                    bool verticalOverlap = !(pos.y + size.height < wPos.y || pos.y > wPos.y + wSize.height);
                    
                    if (verticalOverlap) {
                        CGFloat distance = wPos.x - currentRight;
                        if (distance < minDistance) {
                            minDistance = distance;
                            closestWindow = w;
                        }
                    }
                }
            }
            
            CFRelease(windows2);
            CFRelease(appRef2);
        }
        
        if (closestWindow) {
            CFTypeRef neighborPosRef = NULL;
            AXUIElementCopyAttributeValue(closestWindow, kAXPositionAttribute, &neighborPosRef);
            
            if (neighborPosRef) {
                CGPoint neighborPos;
                AXValueGetValue((AXValueRef)neighborPosRef, kAXValueTypeCGPoint, &neighborPos);
                CFRelease(neighborPosRef);
                
                CGFloat newWidth = neighborPos.x - pos.x;
                CGSize newSize = CGSizeMake(newWidth, size.height);
                
                AXValueRef newSizeRef = AXValueCreate(kAXValueTypeCGSize, (void *)&newSize);
                if (newSizeRef) {
                    AXUIElementSetAttributeValue(frontWindow, kAXSizeAttribute, newSizeRef);
                    CFRelease(newSizeRef);
                }
            }
        }
        
        CFRelease(windows);
        CFRelease(appRef);
    }
    return 0;
}
