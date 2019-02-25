//
//  JXVideoView+PrepareLoading.m
//  MobCoreApp
//
//  Created by zl on 2018/9/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JXVideoView+PrepareLoading.h"
#import <objc/runtime.h>

@interface JXVideoView (PrepareLoadingPrivateAboutFullScreen)

@property (nonatomic, assign) CGSize originalVideoViewSize;

@end

@implementation JXVideoView (PrepareLoading)

#pragma mark - public method
- (void)showLoadingIndicator {
  if (self.loadingIndicator.superview == nil) {
    [self addSubview:self.loadingIndicator];
    [self layoutLoadingIndicator];
  }
  [self.loadingIndicator startAnimating];
}

- (void)hideLoadingIndicator {
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self.loadingIndicator stopAnimating];
  }];
}

- (void)loadingIndicatorEnterFullScreen {
  NSValue *originalSizeValue = [NSValue valueWithCGSize:self.frame.size];
  objc_setAssociatedObject(self, @selector(originalVideoViewSize), originalSizeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  CGFloat width = [UIScreen mainScreen].bounds.size.height;
  CGFloat height = [UIScreen mainScreen].bounds.size.width;
  [self.loadingIndicator layoutLoadingIndicatorWithSize:CGSizeMake(width, height)];
}

- (void)loadingIndicatorExitFullScreen {
  [self.loadingIndicator layoutLoadingIndicatorWithSize:self.originalVideoViewSize];
}

#pragma mark - layout method
- (void)layoutLoadingIndicator {
  if (self.loadingIndicator.superview) {
    [self.loadingIndicator layoutLoadingIndicatorWithSize:self.frame.size];
  }
}

#pragma mark - getter and setter
- (JXVideoPlayerLoadingIndicator *)loadingIndicator {
  JXVideoPlayerLoadingIndicator *loadingIndicator = objc_getAssociatedObject(self, @selector(loadingIndicator));
  if (loadingIndicator == nil) {
    JXVideoPlayerLoadingIndicator *indicator = [JXVideoPlayerLoadingIndicator new];
    objc_setAssociatedObject(self, @selector(loadingIndicator), indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    loadingIndicator = indicator;
  }
  return loadingIndicator;
}

- (void)setLoadingIndicator:(JXVideoPlayerLoadingIndicator *)loadingIndicator {
  objc_setAssociatedObject(self, @selector(loadingIndicator), loadingIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)originalVideoViewSize {
  return [objc_getAssociatedObject(self, @selector(originalVideoViewSize)) CGSizeValue];
}
@end
