//
//  JXVideoView+FullScreen.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+FullScreen.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import <objc/runtime.h>

@implementation JXVideoView (FullScreen)

- (void)enterFullScreen {
    self.isFullScreen = YES;
    
    
}

- (void)exitFullScreen {
    self.isFullScreen = NO;
}

#pragma mark - getter and setter
- (id<JXVideoViewFullScreenDelegate>)fullScreenDelegate {
    return objc_getAssociatedObject(self, @selector(fullScreenDelegate));
}

- (void)setFullScreenDelegate:(id<JXVideoViewFullScreenDelegate>)fullScreenDelegate {
    objc_setAssociatedObject(self, @selector(fullScreenDelegate), fullScreenDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isFullScreen {
    return objc_getAssociatedObject(self, @selector(isFullScreen));
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    objc_setAssociatedObject(self, @selector(isFullScreen), @(isFullScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
