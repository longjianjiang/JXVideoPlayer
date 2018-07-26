//
//  JXVideoView.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

#import "Category/JXVideoView/CoverView/JXVideoView+CoverView.h"
#import "Category/JXVideoView/OperationButton/JXVideoView+OperationButton.h"

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
        [self.player play];
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
    
    if ([self.playerLayer isKindOfClass:[AVPlayerLayer class]]) {
        self.playerLayer.player = self.player;
    }
    
    _shouldPlayAfterPrepareFinished = NO;
    _shouldReplayWhenFinish = NO;
    _shouldChangeOrientationToFitVideo = NO;
    _prepareStatus = JXVideoViewPrepareStatusNotPrepared;
    
    [self initCoverView];
    [self initOperationButton];
}

- (void)dealloc {
    [self deallocCoverView];
    [self deallocOperationButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutCoverView];
    [self layoutOperationButton];
}


#pragma mark - getter and setter
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

#pragma mark - methods override
+ (Class)layerClass {
    return [AVPlayerLayer class];
}
@end
