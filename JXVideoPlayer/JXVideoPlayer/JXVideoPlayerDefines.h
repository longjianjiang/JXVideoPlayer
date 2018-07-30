//
//  JXVideoPlayerDefines.h
//  AiJieTi
//
//  Created by zl on 2018/6/6.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#ifndef JXVideoPlayerDefines_h
#define JXVideoPlayerDefines_h

#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

@import CoreMedia;
@class JXVideoView;

typedef NS_ENUM(NSUInteger, JXVideoViewPrepareStatus) {
    JXVideoViewPrepareStatusNotInitiated,
    JXVideoViewPrepareStatusNotPrepared,
    JXVideoViewPrepareStatusPreparing,
    JXVideoViewPrepareStatusPrepareFinished,
    JXVideoViewPrepareStatusPrepareFailed,
};

typedef NS_ENUM(NSUInteger, JXVideoViewVideoUrlType) {
    JXVideoViewVideoUrlTypeRemote,
    JXVideoViewVideoUrlTypeNative,
    JXVideoViewVideoUrlTypeLiveStream,
    JXVideoViewVideoUrlTypeAsset,
};

typedef NS_ENUM(NSUInteger, JXVideoViewPlayControlDirection) {
    JXVideoViewPlayControlDirectionMoveForward,
    JXVideoViewPlayControlDirectionMoveBackward,
};

/**********************************************************************/

@protocol JXVideoViewOperationDelegate <NSObject>

@optional
- (void)jx_videoViewWillStartPrepare:(JXVideoView *)videoView;
- (void)jx_videoViewDidFinishPrepare:(JXVideoView *)videoView;
- (void)jx_videoViewDidFailPrepare:(JXVideoView *)videoView error:(NSError *)error;

- (void)jx_videoViewWillStartPlaying:(JXVideoView *)videoView;
- (void)jx_videoViewDidStartPlaying:(JXVideoView *)videoView; // will call this method when the video is **really** playing.
- (void)jx_videoViewDidFinishPlaying:(JXVideoView *)videoView;

- (void)jx_videoViewWillPause:(JXVideoView *)videoView;
- (void)jx_videoViewDidPause:(JXVideoView *)videoView;

- (void)jx_videoViewWillStop:(JXVideoView *)videoView;
- (void)jx_videoViewDidStop:(JXVideoView *)videoView;

- (void)jx_videoViewWillSeek:(JXVideoView *)videoView;
- (void)jx_videoViewDidSeek:(JXVideoView *)videoView;

@end

/**********************************************************************/

@protocol JXVideoViewOperationButtonDelegate <NSObject>

@optional
- (void)jx_videoView:(JXVideoView *)videoView didTappedPlayButton:(UIButton *)playButton;
- (void)jx_videoView:(JXVideoView *)videoView layoutPlayButton:(UIButton *)playButton;

@end


/**********************************************************************/

@protocol JXVideoViewTimeDelegate <NSObject>

@optional
- (void)jx_videoViewDidLoadVideoDuration:(JXVideoView *)videoView;
- (void)jx_videoView:(JXVideoView *)videoView didFinishedMoveToTime:(CMTime)time;
- (void)jx_videoView:(JXVideoView *)videoView didPlayToSecond:(CGFloat)second;
- (void)jx_videoView:(JXVideoView *)videoView didBufferToProgress:(CGFloat)progress;

@end

/**********************************************************************/

@protocol JXVideoViewFullScreenDelegate <NSObject>

@optional
- (void)jx_videoViewLayoutSubviewsWhenEnterFullScreen:(JXVideoView *)videoView;
- (void)jx_videoVidewDidFinishEnterFullScreen:(JXVideoView *)videoView;

- (void)jx_videoViewLayoutSubviewsWhenExitFullScreen:(JXVideoView *)videoView;
- (void)jx_videoVidewDidFinishExitFullScreen:(JXVideoView *)videoView;

@end

/**********************************************************************/

@protocol JXVideoViewPlayControlDelegate <NSObject>

@optional

- (void)jx_videoViewShowPlayControlIndicator:(JXVideoView *)videoView;
- (void)jx_videoViewHidePlayControlIndicator:(JXVideoView *)videoView;
- (void)jx_videoView:(JXVideoView *)videoView playControlDidMoveToSecond:(CGFloat)second direction:(JXVideoViewPlayControlDirection)direction;

- (void)jx_videoViewBeTapOneTime:(JXVideoView *)videoView;
- (void)jx_videoViewBeTapDoubleTime:(JXVideoView *)videoView;

@end


#endif /* JXVideoPlayerDefines_h */
