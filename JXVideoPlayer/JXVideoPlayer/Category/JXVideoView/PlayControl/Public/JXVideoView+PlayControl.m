//
//  JXVideoView+PlayControl.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+PlayControl.h"
#import <objc/runtime.h>

#import "JXVideoView+PlayControlPrivate.h"

@implementation JXVideoView (PlayControl)

#pragma mark - getter and setter

- (BOOL)isSlideFastForwardDisabled {
    return [objc_getAssociatedObject(self, @selector(isSlideFastForwardDisabled)) boolValue];
}

- (void)setIsSlideFastForwardDisabled:(BOOL)isSlideFastForwardDisabled {
    if (isSlideFastForwardDisabled == YES && self.isSlideToChangeVolumeOrBrightnessDisabled == YES) {
        [self removeGestureRecognizer:self.panGestureRecognizer];
    }
    
    objc_setAssociatedObject(self, @selector(isSlideFastForwardDisabled), @(isSlideFastForwardDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isSlideToChangeVolumeOrBrightnessDisabled {
    return [objc_getAssociatedObject(self, @selector(isSlideToChangeVolumeOrBrightnessDisabled)) boolValue];
}

- (void)setIsSlideToChangeVolumeOrBrightnessDisabled:(BOOL)isSlideToChangeVolumeOrBrightnessDisabled {
    if (isSlideToChangeVolumeOrBrightnessDisabled == YES && self.isSlideFastForwardDisabled == YES) {
        [self removeGestureRecognizer:self.panGestureRecognizer];
    }
    
    objc_setAssociatedObject(self, @selector(isSlideToChangeVolumeOrBrightnessDisabled), @(isSlideToChangeVolumeOrBrightnessDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<JXVideoViewPlayControlDelegate>)playControlDelegate {
    id<JXVideoViewPlayControlDelegate> delegate = objc_getAssociatedObject(self, @selector(playControlDelegate));
    if ([delegate respondsToSelector:@selector(description)] == NO) {
        delegate = nil;
    }
    return delegate;
}

- (void)setPlayControlDelegate:(id<JXVideoViewPlayControlDelegate>)playControlDelegate {
    objc_setAssociatedObject(self, @selector(playControlDelegate), playControlDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)speedOfSecondToMove {
    CGFloat speedOfSecondToMove = [objc_getAssociatedObject(self, @selector(speedOfSecondToMove)) floatValue];
    if (speedOfSecondToMove == 0) {
        speedOfSecondToMove = 300;
    }
    return speedOfSecondToMove;
}

- (void)setSpeedOfSecondToMove:(CGFloat)speedOfSecondToMove {
    objc_setAssociatedObject(self, @selector(speedOfSecondToMove), @(speedOfSecondToMove), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)speedOfVolumeOrBrightnessChange {
    CGFloat speedOfVolumeOrBrightnessChange = [objc_getAssociatedObject(self, @selector(speedOfVolumeOrBrightnessChange)) floatValue];
    if (speedOfVolumeOrBrightnessChange == 0) {
        speedOfVolumeOrBrightnessChange = 10000.0f;
    }
    return speedOfVolumeOrBrightnessChange;
}

- (void)setSpeedOfVolumeOrBrightnessChange:(CGFloat)speedOfVolumeOrBrightnessChange {
    objc_setAssociatedObject(self, @selector(speedOfVolumeOrBrightnessChange), @(speedOfVolumeOrBrightnessChange), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MPVolumeView *)volumeView {
    MPVolumeView *volumeView = objc_getAssociatedObject(self, @selector(volumeView));
    if (volumeView == nil) {
        volumeView = [MPVolumeView new];
        objc_setAssociatedObject(self, @selector(volumeView), volumeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return volumeView;
}

@end
