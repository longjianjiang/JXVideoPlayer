//
//  JXVideoView+FullScreen.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+FullScreen.h"
#import <objc/runtime.h>

#import <HandyFrame/UIView+LayoutMethods.h>
#import "AVAsset+JXVideoView.h"

#import "JXVideoView+MenuView.h"

@interface JXVideoView (PrivateAboutFullScreen)

@property (nonatomic, weak) UIView *originSuperView;
@property (nonatomic, assign) CGRect originVideoViewFrame;

@end


@implementation JXVideoView (FullScreen)

- (void)enterFullScreen {
    self.isFullScreen = YES;
    
    CGFloat videoWidth = [[[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject] naturalSize].width;
    CGFloat videoHeight = [[[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject] naturalSize].height;
    
    CATransform3D transform = CATransform3DMakeRotation(0.0/180.0 * M_PI, 0.0, 0.0, 1.0);
    CGRect scaleFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    if ([self.asset jx_isVideoPortrait]) {
        if (videoWidth < videoHeight) {
            if (self.transform.b != 1 || self.transform.c != -1) {
                transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
                scaleFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
            }
        }
    } else {
        if (videoWidth > videoHeight) {
            if (self.transform.b != 1 || self.transform.c != -1) {
                transform = CATransform3DMakeRotation(90.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
                scaleFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
            }
        }
    }
    
    [self animateToFullScreenWithTransform:transform scaleFrame:scaleFrame];
}

- (void)exitFullScreen {
    self.isFullScreen = NO;
    [self animateExitFullScreen];
}

#pragma mark - private method
- (void)animateToFullScreenWithTransform:(CATransform3D)transform scaleFrame:(CGRect)scaleFrame {
    NSValue *originalFrameValue = [NSValue valueWithCGRect:self.frame];
    objc_setAssociatedObject(self, @selector(originVideoViewFrame), originalFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGRect covertToWindowFrame = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    self.originSuperView = self.superview;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = covertToWindowFrame;
    
    [self menuViewEnterFullScreen];
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = scaleFrame;
        self.center = [UIApplication sharedApplication].keyWindow.center;
        
        if ([self.fullScreenDelegate respondsToSelector:@selector(jx_videoViewLayoutSubviewsWhenEnterFullScreen:)]) {
            [self.fullScreenDelegate jx_videoViewLayoutSubviewsWhenEnterFullScreen:self];
        }
        self.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        if (finished) {
            if ([self.fullScreenDelegate respondsToSelector:@selector(jx_videoVidewDidFinishEnterFullScreen:)]) {
                [self.fullScreenDelegate jx_videoVidewDidFinishEnterFullScreen:self];
            }
        }
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
}

- (void)animateExitFullScreen {
    [self.originSuperView addSubview:self];
    self.originSuperView = nil;
    
    [self menuViewExitFullScreen];
    [UIView animateWithDuration:0.3f animations:^{
        self.playerLayer.transform = CATransform3DMakeRotation(0.0 / 180.0 * M_PI, 0.0, 0.0, 1.0);
        self.frame = [self originVideoViewFrame];
        
        if ([self.fullScreenDelegate respondsToSelector:@selector(jx_videoViewLayoutSubviewsWhenExitFullScreen:)]) {
            [self.fullScreenDelegate jx_videoViewLayoutSubviewsWhenExitFullScreen:self];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            if ( [self.fullScreenDelegate respondsToSelector:@selector(jx_videoVidewDidFinishExitFullScreen:)]) {
                [self.fullScreenDelegate jx_videoVidewDidFinishExitFullScreen:self];
            }
        }
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
}

#pragma mark - getter and setter
- (id<JXVideoViewFullScreenDelegate>)fullScreenDelegate {
    return objc_getAssociatedObject(self, @selector(fullScreenDelegate));
}

- (void)setFullScreenDelegate:(id<JXVideoViewFullScreenDelegate>)fullScreenDelegate {
    objc_setAssociatedObject(self, @selector(fullScreenDelegate), fullScreenDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isFullScreen {
    return [objc_getAssociatedObject(self, @selector(isFullScreen)) boolValue];
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    objc_setAssociatedObject(self, @selector(isFullScreen), @(isFullScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)originVideoViewFrame {
    return [objc_getAssociatedObject(self, @selector(originVideoViewFrame)) CGRectValue];
}

- (UIView *)originSuperView {
    return objc_getAssociatedObject(self, @selector(originSuperView));
}

- (void)setOriginSuperView:(UIView *)originSuperView {
    objc_setAssociatedObject(self, @selector(originSuperView), originSuperView, OBJC_ASSOCIATION_ASSIGN);
}


@end
