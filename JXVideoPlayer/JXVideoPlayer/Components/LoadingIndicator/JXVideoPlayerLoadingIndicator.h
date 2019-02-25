//
//  JXVideoPlayerLoadingIndicator.h
//  MobCoreApp
//
//  Created by zl on 2018/9/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXVideoPlayerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXVideoPlayerLoadingIndicator : UIView

@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong, readonly) UIVisualEffectView *blurView;
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;
- (void)layoutLoadingIndicatorWithSize:(CGSize)videoViewSize;

@end

NS_ASSUME_NONNULL_END
