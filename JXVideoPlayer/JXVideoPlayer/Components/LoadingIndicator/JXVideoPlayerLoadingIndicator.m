//
//  JXVideoPlayerLoadingIndicator.m
//  MobCoreApp
//
//  Created by zl on 2018/9/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JXVideoPlayerLoadingIndicator.h"

CGFloat const JXVideoPlayerLoadingIndicatorWidthHeight = 46;

@interface JXVideoPlayerLoadingIndicator ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property(nonatomic, strong) UIVisualEffectView *blurView;

@property(nonatomic, assign, getter=isAnimating) BOOL animating;

@property (nonatomic, strong) UIView *blurBackgroundView;

@end


@implementation JXVideoPlayerLoadingIndicator

#pragma mark - public method
- (void)layoutLoadingIndicatorWithSize:(CGSize)videoViewSize {
  self.blurBackgroundView.frame = CGRectMake((videoViewSize.width - JXVideoPlayerLoadingIndicatorWidthHeight) * 0.5,
                                             (videoViewSize.height - JXVideoPlayerLoadingIndicatorWidthHeight) * 0.5,
                                             JXVideoPlayerLoadingIndicatorWidthHeight,
                                             JXVideoPlayerLoadingIndicatorWidthHeight);
  self.activityIndicator.frame = self.blurBackgroundView.bounds;
  self.blurView.frame = self.blurBackgroundView.bounds;
}

- (void)startAnimating {
  if (!self.isAnimating) {
    self.hidden = NO;
    [self.activityIndicator startAnimating];
    self.animating = YES;
  }
}

- (void)stopAnimating {
  if (self.isAnimating) {
    self.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.animating = NO;
  }
}

#pragma mark - life cycle
- (instancetype)init {
  self = [super init];
  if (self) {
    [self _setup];
  }
  return self;
}

- (void)_setup{
  self.backgroundColor = [UIColor clearColor];
  
  self.blurBackgroundView = ({
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    view.layer.cornerRadius = 10;
    view.clipsToBounds = YES;
    [self addSubview:view];
    
    view;
  });
  
  self.blurView = ({
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.blurBackgroundView addSubview:blurView];
    
    blurView;
  });
  
  self.activityIndicator = ({
    UIActivityIndicatorView *indicator = [UIActivityIndicatorView new];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicator.color = [UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
    [self.blurBackgroundView addSubview:indicator];
    
    indicator;
  });
  
  self.animating = NO;
}


@end
