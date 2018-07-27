//
//  JXVideoView+PlayControl.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface JXVideoView (PlayControl)

@property (nonatomic, assign) BOOL isSlideFastForwardDisabled;
@property (nonatomic, assign) CGFloat speedOfSecondToMove;

@property (nonatomic, assign) BOOL isSlideToChangeVolumeOrBrightnessDisabled;
@property (nonatomic, assign) CGFloat speedOfVolumeOrBrightnessChange;
@property (nonatomic, strong, readonly) MPVolumeView *volumeView;

@property (nonatomic, weak) id<JXVideoViewPlayControlDelegate> playControlDelegate;

@end


