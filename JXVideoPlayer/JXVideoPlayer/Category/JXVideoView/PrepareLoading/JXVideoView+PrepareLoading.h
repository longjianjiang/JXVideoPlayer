//
//  JXVideoView+PrepareLoading.h
//  MobCoreApp
//
//  Created by zl on 2018/9/15.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "JXVideoView.h"
#import "JXVideoPlayerLoadingIndicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXVideoView (PrepareLoading)

@property (nonatomic, strong) JXVideoPlayerLoadingIndicator *loadingIndicator;

- (void)showLoadingIndicator;
- (void)hideLoadingIndicator;

- (void)loadingIndicatorEnterFullScreen;
- (void)loadingIndicatorExitFullScreen;

@end

NS_ASSUME_NONNULL_END
