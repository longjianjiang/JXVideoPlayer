//
//  JXVideoView+MenuView.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/29.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+MenuView.h"
#import <objc/runtime.h>
#import <HandyFrame/UIView+LayoutMethods.h>
#import "JXWeakProxy.h"

static NSInteger const kAutoHideTimeInterval = 7.0;

@interface JXVideoView (MenuViewPrivateAboutFullScreen)

@property (nonatomic, assign) CGRect originalMenuViewFrame;
@property (nonatomic, strong) NSTimer *autoHideTimer;

@end


@implementation JXVideoView (MenuView)


#pragma mark menu show hide method
- (void)makeMenuShow {
    self.menuView.hidden = NO;
    
    [self autoHideMenuWithTimeInterval:kAutoHideTimeInterval];
}

- (void)makeMenuHide {
    self.menuView.hidden = YES;
    
    [self invalidateTimer];
}

- (void)autoHideMenuWithTimeInterval:(NSTimeInterval)ti {
    self.autoHideTimer = [NSTimer scheduledTimerWithTimeInterval:ti target:[JXWeakProxy proxyWithTarget:self] selector:@selector(makeMenuHide) userInfo:nil repeats:NO];
}

- (void)invalidateTimer {
    [self.autoHideTimer invalidate];
    self.autoHideTimer = nil;
}

#pragma mark - public method
- (void)makeMenuViewNotAutoHide {
  [self invalidateTimer];
}

- (void)makeMenuViewAutoHide {
  [self autoHideMenuWithTimeInterval:kAutoHideTimeInterval];
}

- (void)controlWhetherShowMenuView {
    self.menuView.isHidden ? [self makeMenuShow] : [self makeMenuHide];
}

- (void)menuViewEnterFullScreen {
    NSValue *originalFrameValue = [NSValue valueWithCGRect:self.menuView.frame];
    objc_setAssociatedObject(self, @selector(originalMenuViewFrame), originalFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = [UIScreen mainScreen].bounds.size.width;
  
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0 && SCREEN_HEIGHT >= 812) {
      CGFloat hMargin = 44;
      CGFloat bMargin = 21;
      
      self.menuView.frame = CGRectMake(hMargin,
                                       0,
                                       width - 2 * hMargin,
                                       height - bMargin);
    } else {
      self.menuView.frame = CGRectMake(0, 0, width, height);
    }
  
    [self.menuView layoutIfNeeded];
}

- (void)menuViewExitFullScreen {
    self.menuView.frame = self.originalMenuViewFrame;
}

#pragma mark life cycle
- (void)showMenuView {
    if (self.menuView.superview == nil) {
        [self addSubview:self.menuView];
        [self layoutMenuView];

        [self autoHideMenuWithTimeInterval:kAutoHideTimeInterval];
    }
}

- (void)initMenuView {
  if (self.menuView.superview == nil) {
    [self addSubview:self.menuView];
    [self layoutMenuView];
    self.menuView.hidden = YES;
  }
}

- (void)deallocMenuView {
    [self invalidateTimer];
}

- (void)layoutMenuView {
    [self.menuView fill];
}


#pragma mark - getter and setter
- (UIView *)menuView {
    return objc_getAssociatedObject(self, @selector(menuView));
}

- (void)setMenuView:(UIView *)menuView {
    objc_setAssociatedObject(self, @selector(menuView), menuView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)originalMenuViewFrame {
    return [objc_getAssociatedObject(self, @selector(originalMenuViewFrame)) CGRectValue];
}

- (NSTimer *)autoHideTimer {
    return objc_getAssociatedObject(self, @selector(autoHideTimer));
}

- (void)setAutoHideTimer:(NSTimer *)autoHideTimer {
    objc_setAssociatedObject(self, @selector(autoHideTimer), autoHideTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
