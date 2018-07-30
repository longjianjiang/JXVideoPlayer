//
//  JXVideoView.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

#import "JXVideoView+CoverView.h"
#import "JXVideoView+OperationButton.h"
#import "JXVideoView+Time.h"
#import "JXVideoView+PlayControlPrivate.h"
#import "JXVideoView+MenuView.h"

NSString * const kJXVideoViewKVOKeyPathPlayerItemStatus = @"player.currentItem.status";
NSString * const kJXVideoViewKVOKeyPathPlayerItemDuration = @"player.currentItem.duration";
NSString * const kJXVideoViewKVOKeyPathLayerReadyForDisplay = @"layer.readyForDisplay";
NSString * const kJXVideoViewKVOKeyPathPlayerItemLoadedTimeRanges = @"player.currentItem.loadedTimeRanges";

static void * kJXVideoViewKVOContext = &kJXVideoViewKVOContext;


@interface JXVideoView ()

@property (nonatomic, assign, readwrite) JXVideoViewPrepareStatus prepareStatus;
@property (nonatomic, assign, readwrite) JXVideoViewVideoUrlType videoUrlType;
@property (nonatomic, strong, readwrite) NSURL *actualVideoPlayingUrl;
@property (nonatomic, assign, readwrite) JXVideoViewVideoUrlType actualVideoUrlType;

@property (nonatomic, strong, readwrite) AVPlayer *player;
@property (nonatomic, strong, readwrite) AVURLAsset *asset;
@property (nonatomic, strong, readwrite) AVPlayerItem *playerItem;

@property (nonatomic, assign) BOOL isVideoUrlChanged;
@end


@implementation JXVideoView

#pragma mark - public method
- (void)prepare {
    if (self.isPlaying == YES && self.isVideoUrlChanged == NO) {
        return;
    }
    
    if (self.assetToPlay) {
        self.prepareStatus = JXVideoViewPrepareStatusPreparing;
        [self asynchronouslyLoadUrlAsset:self.assetToPlay];
        return;
    }
    
    if (self.asset && self.prepareStatus == JXVideoViewPrepareStatusNotPrepared) {
        self.prepareStatus = JXVideoViewPrepareStatusPreparing;
        [self asynchronouslyLoadUrlAsset:self.asset];
        return;
    }
    
    if (self.prepareStatus == JXVideoViewPrepareStatusPrepareFinished) {
        if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewDidFinishPrepare:)]) {
            [self.operationDelegate jx_videoViewDidFinishPrepare:self];
        }
        return;
    }
}

- (void)play {
    [self hidePlayButton];
    if (self.isPlaying) {
        [self hideCoverView];
        return;
    }
    
    if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewWillStartPlaying:)]) {
        [self.operationDelegate jx_videoViewWillStartPlaying:self];
    }
    
    if (self.prepareStatus == JXVideoViewPrepareStatusPrepareFinished) {
        [self willStartPlay];
        
        NSInteger currentPlaySecond = (NSInteger)(self.currentPlaySecond * 100);
        NSInteger totalDurationSeconds = (NSInteger)(self.totalPlaySecond * 100);
        if (currentPlaySecond == totalDurationSeconds && totalDurationSeconds > 0) {
            [self replay];
        } else {
            [self.player play];
            
            [self showMenuView];
        }
    }
}

- (void)pause {
    [self hideCoverView];
    [self showPlayButton];
    if (self.isPlaying) {
        if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewWillPause:)]) {
            [self.operationDelegate jx_videoViewWillPause:self];
        }
        [self.player pause];
        if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewDidPause:)]) {
            [self.operationDelegate jx_videoViewDidPause:self];
        }
    }
}

- (void)replay {
    [self hidePlayButton];
    [self.playerLayer.player seekToTime:kCMTimeZero];
    [self play];
}

- (void)stopWithReleaseVideo:(BOOL)shouldReleaseVideo {
    if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewWillStop:)]) {
        [self.operationDelegate jx_videoViewWillStop:self];
    }
    [self.player pause];
    [self showCoverView];
    [self showPlayButton];
    if (shouldReleaseVideo) {
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.prepareStatus = JXVideoViewPrepareStatusNotPrepared;
    }
    if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewDidStop:)]) {
        [self.operationDelegate jx_videoViewDidStop:self];
    }
}


#pragma mark - private method
- (void)asynchronouslyLoadUrlAsset:(AVAsset *)asset {
    if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewWillStartPrepare:)]) {
        [self.operationDelegate jx_videoViewWillStartPrepare:self];
    }
    
    WeakSelf
    [asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
        StrongSelf
        
        strongSelf.isVideoUrlChanged = NO;
        if (asset != strongSelf.asset && asset != strongSelf.assetToPlay) {
            return;
        }
        
        NSError *error = nil;
        if ([asset statusOfValueForKey:@"tracks" error:&error] == AVKeyValueStatusFailed) {
            NSLog(@"%@", error);
        }
        if ([asset statusOfValueForKey:@"duration" error:&error] == AVKeyValueStatusFailed) {
            NSLog(@"%@", error);
        }
        if ([asset statusOfValueForKey:@"playable" error:&error] == AVKeyValueStatusFailed) {
            NSLog(@"%@", error);
        }
        
        strongSelf.playerItem = [AVPlayerItem playerItemWithAsset:asset];
        strongSelf.prepareStatus = JXVideoViewPrepareStatusPrepareFinished;
        
        if (strongSelf.shouldPlayAfterPrepareFinished) {
            [strongSelf play];
        }
        
        if ([strongSelf.operationDelegate respondsToSelector:@selector(jx_videoViewDidFinishPrepare:)]) {
            [strongSelf.operationDelegate jx_videoViewDidFinishPrepare:self];
        }
    }];
}

- (void)refreshUrl {
    if ([[self.videoUrl pathExtension] isEqualToString:@"m3u8"]) {
        self.videoUrlType = JXVideoViewVideoUrlTypeLiveStream;
        self.actualVideoUrlType = JXVideoViewVideoUrlTypeLiveStream;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:[self.videoUrl path]]) {
        self.videoUrlType = JXVideoViewVideoUrlTypeNative;
        self.actualVideoUrlType = JXVideoViewVideoUrlTypeNative;
    } else {
        self.videoUrlType = JXVideoViewVideoUrlTypeRemote;
        self.actualVideoUrlType = JXVideoViewVideoUrlTypeRemote;
    }
    
    self.actualVideoPlayingUrl = self.videoUrl;
    
    if (![self.asset.URL isEqual:self.actualVideoPlayingUrl]) {
        self.asset = [AVURLAsset assetWithURL:self.actualVideoPlayingUrl];
        self.prepareStatus = JXVideoViewPrepareStatusNotPrepared;
        self.isVideoUrlChanged = YES;
    }
}

#pragma mark - life cycle
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performInitProcess];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self performInitProcess];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self performInitProcess];
    }
    return self;
}

- (void)performInitProcess {
    if (_prepareStatus != JXVideoViewPrepareStatusNotInitiated) {
        return;
    }
    
    // KVO
    [self addObserver:self
           forKeyPath:kJXVideoViewKVOKeyPathPlayerItemStatus
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:&kJXVideoViewKVOContext];
    
    [self addObserver:self
           forKeyPath:kJXVideoViewKVOKeyPathPlayerItemDuration
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:&kJXVideoViewKVOContext];
    
    [self addObserver:self
           forKeyPath:kJXVideoViewKVOKeyPathLayerReadyForDisplay
              options:NSKeyValueObservingOptionNew
              context:&kJXVideoViewKVOContext];
    
    [self addObserver:self
           forKeyPath:kJXVideoViewKVOKeyPathPlayerItemLoadedTimeRanges
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
              context:&kJXVideoViewKVOContext];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemDidPlayToEndTimeNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveAVPlayerItemPlaybackStalledNotification:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    if ([self.playerLayer isKindOfClass:[AVPlayerLayer class]]) {
        self.playerLayer.player = self.player;
    }
    
    _shouldPlayAfterPrepareFinished = NO;
    _shouldReplayWhenFinish = NO;
    _shouldChangeOrientationToFitVideo = NO;
    _prepareStatus = JXVideoViewPrepareStatusNotPrepared;
    
    [self initCoverView];
    [self initOperationButton];
    [self initTime];
    [self initWithPlayControlGesture];
    
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kJXVideoViewKVOKeyPathPlayerItemStatus context:kJXVideoViewKVOContext];
    [self removeObserver:self forKeyPath:kJXVideoViewKVOKeyPathPlayerItemDuration context:kJXVideoViewKVOContext];
    [self removeObserver:self forKeyPath:kJXVideoViewKVOKeyPathLayerReadyForDisplay context:kJXVideoViewKVOContext];
    [self removeObserver:self forKeyPath:kJXVideoViewKVOKeyPathPlayerItemLoadedTimeRanges context:kJXVideoViewKVOContext];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self deallocCoverView];
    [self deallocMenuView];
    [self deallocOperationButton];
    [self deallocTime];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutCoverView];
    [self layoutOperationButton];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != &kJXVideoViewKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:kJXVideoViewKVOKeyPathPlayerItemStatus]) {
        NSNumber *newStatusAsNumber = change[NSKeyValueChangeNewKey];
        AVPlayerItemStatus newStatus = [newStatusAsNumber isKindOfClass:[NSNumber class]] ? newStatusAsNumber.integerValue : AVPlayerItemStatusUnknown;
        
        if (newStatus == AVPlayerItemStatusFailed) {
            NSLog(@"%@", self.player.currentItem.error);
        }
    }
    
    if ([keyPath isEqualToString:kJXVideoViewKVOKeyPathPlayerItemDuration]) {
        [self durationDidLoadedWithChange:change];
    }
    
    if ([keyPath isEqualToString:kJXVideoViewKVOKeyPathLayerReadyForDisplay]) {
        if ([change[@"new"] boolValue] == YES) {
            [self setNeedsDisplay];
            if (self.prepareStatus == JXVideoViewPrepareStatusPrepareFinished) {
                if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewDidFinishPrepare:)]) {
                    [self.operationDelegate jx_videoViewDidFinishPrepare:self];
                }
            }
        }
    }
    
    if ([keyPath isEqualToString:kJXVideoViewKVOKeyPathPlayerItemLoadedTimeRanges]) {
        NSTimeInterval ti = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat rate = ti / totalDuration;
        if ([self.timeDelegate respondsToSelector:@selector(jx_videoView:didBufferToProgress:)]) {
            [self.timeDelegate jx_videoView:self didBufferToProgress:rate];
        }
    }
    
}

#pragma mark - Notification
- (void)didReceiveAVPlayerItemDidPlayToEndTimeNotification:(NSNotification *)notification {
    if (notification.object == self.player.currentItem) {
        if (self.shouldReplayWhenFinish) {
            [self replay];
        } else {
            [self.player seekToTime:kCMTimeZero];
            [self showPlayButton];
        }
        
        if ([self.operationDelegate respondsToSelector:@selector(jx_videoViewDidFinishPlaying:)]) {
            [self.operationDelegate jx_videoViewDidFinishPlaying:self];
        }
    }
}

- (void)didReceiveAVPlayerItemPlaybackStalledNotification:(NSNotification *)notification {
    if (notification.object == self.player.currentItem) {
       
    }
}

#pragma mark - help method
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - getter and setter
- (void)setAssetToPlay:(AVAsset *)assetToPlay {
    _assetToPlay = assetToPlay;
    if (assetToPlay) {
        self.isVideoUrlChanged = YES;
        self.prepareStatus = JXVideoViewPrepareStatusNotPrepared;
        self.videoUrlType = JXVideoViewVideoUrlTypeAsset;
        self.actualVideoUrlType = JXVideoViewVideoUrlTypeAsset;
    }
}

- (void)setIsMuted:(BOOL)isMuted {
    self.player.muted = isMuted;
}

- (BOOL)isMuted {
    return self.player.isMuted;
}


- (AVPlayer *)player {
    if (_player == nil) {
        _player = [AVPlayer new];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if (_videoUrl && [_videoUrl isEqual:videoUrl]) {
        self.isVideoUrlChanged = NO;
    } else {
        self.isVideoUrlChanged = YES;
        self.prepareStatus = JXVideoViewPrepareStatusNotPrepared;
    }
    
    _videoUrl = videoUrl;
    
    if (self.isVideoUrlChanged) {
        [self refreshUrl];
    }
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem != playerItem) {
        _playerItem = playerItem;
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    }
}

- (BOOL)isPlaying {
    return self.player.rate >= 1.0;
}

#pragma mark - methods override
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
@end
