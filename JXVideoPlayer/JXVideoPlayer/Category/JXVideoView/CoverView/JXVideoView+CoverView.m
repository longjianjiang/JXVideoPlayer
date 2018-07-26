//
//  JXVideoView+CoverView.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+CoverView.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import <objc/runtime.h>

@implementation JXVideoView (CoverView)

#pragma mark - life cycle
- (void)initCoverView {
    [self showCoverView];
}

- (void)deallocCoverView {
    
}

- (void)layoutCoverView {
    [self.coverView fill];
}

#pragma mark - public method
- (void)showCoverView {
    if (self.shouldShowCoverViewBeforePlay && self.coverView.superview == nil) {
        [self addSubview:self.coverView];
        [self layoutCoverView];
    }
}

- (void)hideCoverView {
    if (self.coverView.superview) {
        [UIView animateWithDuration:0.2f animations:^{
            self.coverView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.coverView removeFromSuperview];
                self.coverView.alpha = 1.0;
            }
        }];
    }
}



#pragma mark - getter and setter
- (BOOL)shouldShowCoverViewBeforePlay {
    return [objc_getAssociatedObject(self, @selector(shouldShowCoverViewBeforePlay)) boolValue];
}

- (void)setShouldShowCoverViewBeforePlay:(BOOL)shouldShowCoverViewBeforePlay {
    objc_setAssociatedObject(self, @selector(shouldShowCoverViewBeforePlay), @(shouldShowCoverViewBeforePlay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (shouldShowCoverViewBeforePlay == YES) {
        if (self.coverView.superview == nil) {
            [self showCoverView];
        }
    }
}

- (UIView *)coverView {
    return objc_getAssociatedObject(self, @selector(coverView));
}

- (void)setCoverView:(UIView *)coverView {
    objc_setAssociatedObject(self, @selector(coverView), coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.shouldShowCoverViewBeforePlay == YES) {
        [self showCoverView];
    }
}

@end
