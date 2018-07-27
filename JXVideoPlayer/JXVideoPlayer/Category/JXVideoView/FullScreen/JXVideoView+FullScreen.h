//
//  JXVideoView+FullScreen.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

@interface JXVideoView (FullScreen)

@property (nonatomic, assign, readonly) BOOL isFullScreen;
@property (nonatomic, weak) id<JXVideoViewFullScreenDelegate> fullScreenDelegate;

- (void)enterFullScreen;
- (void)exitFullScreen;

@end


