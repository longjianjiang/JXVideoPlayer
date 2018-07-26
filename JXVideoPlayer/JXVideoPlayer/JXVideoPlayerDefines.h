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

- (void)jx_videoView:(JXVideoView *)videoView didTappedReplayButton:(UIButton *)replayButton;
- (void)jx_videoView:(JXVideoView *)videoView layoutReplayButton:(UIButton *)replayButton;
@end


/**********************************************************************/

@protocol JXVideoViewTimeDelegate <NSObject>

@optional
- (void)jx_videoView:(JXVideoView *)videoView didFinishedMoveToTime:(NSTimeInterval)time;

@end

#endif /* JXVideoPlayerDefines_h */
