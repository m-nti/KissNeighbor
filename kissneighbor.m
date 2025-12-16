#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>

int main() {
    @autoreleasepool {
        NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
        NSRunningApplication *frontApp = [workspace frontmostApplication];
        
        if (!frontApp) {
            fprintf(stderr, "No front app\n");
            return 1;
        }
        
        pid_t pid = [frontApp processIdentifier];
        AXUIElementRef appRef = AXUIElementCreateApplication(pid);
        
        CFArrayRef windows = NULL;
        AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute, (CFTypeRef *)&windows);
        
        if (!windows || CFArrayGetCount(windows) == 0) {
            fprintf(stderr, "No windows\n");
            return 1;
        }
        
        AXUIElementRef frontWindow = (AXUIElementRef)CFArrayGetValueAtIndex(windows, 0);
        
        CFTypeRef posRef = NULL, sizeRef = NULL;
        AXUIElementCopyAttributeValue(frontWindow, kAXPositionAttribute, &posRef);
        AXUIElementCopyAttributeValue(frontWindow, kAXSizeAttribute, &sizeRef);
        
        CGPoint pos;
        CGSize size;
        AXValueGetValue((AXValueRef)posRef, kAXValueTypeCGPoint, &pos);
        AXValueGetValue((AXValueRef)sizeRef, kAXValueTypeCGSize, &size);
        
        CGFloat currentRight = pos.x + size.width;
        
        AXUIElementRef closestWindow = NULL;
        CGFloat minDistance = CGFLOAT_MAX;
        
        for (NSRunningApplication *app in [workspace runningApplications]) {
            if (app.processIdentifier == pid || app.isHidden) continue;
            
            AXUIElementRef appRef2 = AXUIElementCreateApplication(app.processIdentifier);
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
                
                if (!wPosRef || !wSizeRef) continue;
                
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
            
            CGPoint neighborPos;
            AXValueGetValue((AXValueRef)neighborPosRef, kAXValueTypeCGPoint, &neighborPos);
            CFRelease(neighborPosRef);
            
            CGFloat newWidth = neighborPos.x - pos.x;
            CGSize newSize = CGSizeMake(newWidth, size.height);
            
            CFTypeRef newSizeRef = AXValueCreate(kAXValueTypeCGSize, (void *)&newSize);
            AXUIElementSetAttributeValue(frontWindow, kAXSizeAttribute, newSizeRef);
            CFRelease(newSizeRef);
        }
        
        CFRelease(windows);
        CFRelease(appRef);
    }
    return 0;
}
