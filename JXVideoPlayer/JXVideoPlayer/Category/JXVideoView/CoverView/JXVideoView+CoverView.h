//
//  JXVideoView+CoverView.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

@interface JXVideoView (CoverView)

@property (nonatomic, assign) BOOL shouldShowCoverViewBeforePlay;
@property (nonatomic, strong) UIView *coverView;

- (void)initCoverView;
- (void)deallocCoverView;

- (void)showCoverView;
- (void)hideCoverView;
- (void)layoutCoverView;

@end


