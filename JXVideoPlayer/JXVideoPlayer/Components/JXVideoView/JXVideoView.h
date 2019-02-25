//
//  JXVideoView.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

@import AVFoundation;

#import <UIKit/UIKit.h>
#import "JXVideoPlayerDefines.h"


@interface JXVideoView : UIView

@property (nonatomic, strong) AVAsset *assetToPlay;

@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, assign, readonly) JXVideoViewVideoUrlType videoUrlType;

@property (nonatomic, strong, readonly) NSURL *actualVideoPlayingUrl;
@property (nonatomic, assign, readonly) JXVideoViewVideoUrlType actualVideoUrlType;

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) JXVideoViewPrepareStatus prepareStatus;

@property (nonatomic, assign) BOOL isMuted; // set YES to mute the video playing
@property (nonatomic, assign) BOOL shouldPlayAfterPrepareFinished; // default is NO
@property (nonatomic, assign) BOOL shouldReplayWhenFinish; // default is NO
@property (nonatomic, assign) BOOL shouldChangeOrientationToFitVideo; // default is NO
@property (nonatomic, assign) BOOL shouldOnlyFullScreenSupportPlayControl; // default is NO

@property (nonatomic, assign) JXVideoViewStalledStrategy stalledStrategy;
@property (nonatomic, weak) id<JXVideoViewOperationDelegate> operationDelegate;

@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;
@property (nonatomic, strong, readonly) AVPlayer *player;
@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;

- (void)prepare;
- (void)play;
- (void)pause;
- (void)replay;
- (void)stopWithReleaseVideo:(BOOL)shouldReleaseVideo;

- (void)refreshUrl;

@end

