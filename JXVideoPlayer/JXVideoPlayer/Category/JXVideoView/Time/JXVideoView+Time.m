//
//  JXVideoView+Time.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+Time.h"
#import <objc/runtime.h>
#import "JXVideoView+CoverView.h"
#import "JXVideoView+OperationButton.h"

@interface JXVideoView (PrivateAboutTime)

@property (nonatomic, strong) id<NSObject> timeObserverToken;
@property (nonatomic, strong) id<NSObject> videoStartTimeObserverToken;
@end


@implementation JXVideoView (PrivateAboutTime)

- (void)addTimeObserver {
    if (self.timeObserverToken) {
        [self removeTimeObserver];
    }
    
    WeakSelf
    self.timeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(self.timeGapToObserve, 100) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        StrongSelf
        
        if ([strongSelf.timeDelegate respondsToSelector:@selector(jx_videoView:didPlayToSecond:)]) {
            CGFloat second = CMTimeGetSeconds(time);
            [strongSelf.timeDelegate jx_videoView:strongSelf didPlayToSecond:second];
        }
    }];
}

- (void)addVideoStartTimeObserver {
    if (self.videoStartTimeObserverToken) {
        [self removeVideoStartTimeObserver];
    }
    
    WeakSelf
    self.videoStartTimeObserverToken = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 60) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        StrongSelf
        CGFloat second = CMTimeGetSeconds(time);
        
        if (strongSelf.isPlaying && second > 0 && second < 0.1) {
            if ([strongSelf.operationDelegate respondsToSelector:@selector(jx_videoViewDidStartPlaying:)]) {
                [strongSelf.operationDelegate jx_videoViewDidStartPlaying:strongSelf];
            }
            
            [strongSelf hidePlayButton];
            [strongSelf hideCoverView];
            [strongSelf removeVideoStartTimeObserver];
        }
        
        if (second > 0.1) {
            [strongSelf removeVideoStartTimeObserver];
        }
    }];
}


- (void)removeTimeObserver {
    if (self.timeObserverToken) {
        [self.player removeTimeObserver:self.timeObserverToken];
        self.timeObserverToken = nil;
    }
}

- (void)removeVideoStartTimeObserver {
    if (self.videoStartTimeObserverToken) {
        [self.player removeTimeObserver:self.videoStartTimeObserverToken];
        self.videoStartTimeObserverToken = nil;
    }
}


#pragma mark - getter and setter
- (id<NSObject>)timeObserverToken {
    return objc_getAssociatedObject(self, @selector(timeObserverToken));
}

- (void)setTimeObserverToken:(id<NSObject>)timeObserverToken {
    objc_setAssociatedObject(self, @selector(timeObserverToken), timeObserverToken, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<NSObject>)videoStartTimeObserverToken {
    return objc_getAssociatedObject(self, @selector(videoStartTimeObserverToken));
}

- (void)setVideoStartTimeObserverToken:(id<NSObject>)videoStartTimeObserverToken {
    objc_setAssociatedObject(self, @selector(videoStartTimeObserverToken), videoStartTimeObserverToken, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation JXVideoView (Time)

#pragma mark - life cycle
- (void)initTime {
    [self addVideoStartTimeObserver];
}

- (void)deallocTime {
    [self removeTimeObserver];
    [self removeVideoStartTimeObserver];
    self.timeDelegate = nil;
}

#pragma mark - public method
- (void)willStartPlay {
    [self addVideoStartTimeObserver];
}

- (void)moveToSecond:(CGFloat)second shouldPlay:(BOOL)shouldPlay {
    CMTime time = CMTimeMake(second, 1.0f);
    WeakSelf
    [self.player seekToTime:CMTimeMakeWithSeconds(second, 600) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        StrongSelf
        
        if ([strongSelf.timeDelegate respondsToSelector:@selector(jx_videoView:didFinishedMoveToTime:)]) {
            [strongSelf.timeDelegate jx_videoView:strongSelf didFinishedMoveToTime:time];
        }
        
        if (shouldPlay) {
            [strongSelf play];
        }
    }];
}

- (void)setShouldObservePlayTime:(BOOL)shouldObservePlayTime timeGapToObserve:(CGFloat)timeGapToObserve {
    self.shouldObservePlayTime = shouldObservePlayTime;
    self.timeGapToObserve = timeGapToObserve;
}

- (void)durationDidLoadedWithChange:(NSDictionary *)change {
    if ([change[NSKeyValueChangeNewKey] isEqual:[NSNull null]]) {
        return;
    }
    
    NSValue *newDurationValue = change[NSKeyValueChangeNewKey];
    CMTime newDuration = [newDurationValue isKindOfClass:[NSValue class]] ? newDurationValue.CMTimeValue : kCMTimeZero;
    BOOL hasValidDuration = CMTIME_IS_NUMERIC(newDuration) && newDuration.value != 0;
    self.totalPlaySecond = hasValidDuration ? CMTimeGetSeconds(newDuration) : 0.0f;
    if (self.totalPlaySecond > 0) {
        if ([self.timeDelegate respondsToSelector:@selector(jx_videoViewDidLoadVideoDuration:)]) {
            [self.timeDelegate jx_videoViewDidLoadVideoDuration:self];
        }
    }
}

#pragma mark - getter and setter
- (CGFloat)currentPlaySecond {
    return CMTimeGetSeconds(self.playerItem.currentTime);
}

- (CGFloat)timeGapToObserve {
    CGFloat timeGapToObserve = [objc_getAssociatedObject(self, @selector(timeGapToObserve)) floatValue];
    if (timeGapToObserve == 0) {
        timeGapToObserve = 100.0f;
        [self setTimeGapToObserve:timeGapToObserve];
    }
    return timeGapToObserve;
}

- (void)setTimeGapToObserve:(CGFloat)timeGapToObserve {
    objc_setAssociatedObject(self, @selector(timeGapToObserve), @(timeGapToObserve), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)totalPlaySecond {
    return [objc_getAssociatedObject(self, @selector(totalPlaySecond)) floatValue];
}

- (void)setTotalPlaySecond:(CGFloat)totalPlaySecond {
    objc_setAssociatedObject(self, @selector(totalPlaySecond), @(totalPlaySecond), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)shouldObservePlayTime {
    return [objc_getAssociatedObject(self, @selector(shouldObservePlayTime)) boolValue];
}

- (void)setShouldObservePlayTime:(BOOL)shouldObservePlayTime {
    objc_setAssociatedObject(self, @selector(shouldObservePlayTime), @(shouldObservePlayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (shouldObservePlayTime == YES) {
        [self addTimeObserver];
    }
    
    if (shouldObservePlayTime == NO) {
        [self removeTimeObserver];
    }
}

- (id<JXVideoViewTimeDelegate>)timeDelegate {
    return objc_getAssociatedObject(self, @selector(timeDelegate));
}

- (void)setTimeDelegate:(id<JXVideoViewTimeDelegate>)timeDelegate {
    objc_setAssociatedObject(self, @selector(timeDelegate), timeDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)currentPlaySpeed {
    return self.player.rate / 1.0f;
}

- (void)setCurrentPlaySpeed:(CGFloat)currentPlaySpeed {
    self.player.rate = 1.0 * currentPlaySpeed;
}

@end
