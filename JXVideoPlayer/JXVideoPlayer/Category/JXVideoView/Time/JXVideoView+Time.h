//
//  JXVideoView+Time.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

@interface JXVideoView (Time)

@property (nonatomic, assign, readonly) CGFloat currentPlaySecond;
@property (nonatomic, assign, readonly) CGFloat totalPlaySecond;
@property (nonatomic, assign, readonly) BOOL shouldObservePlayTime;
@property (nonatomic, assign, readonly) CGFloat timeGapToObserve;

@property (nonatomic, assign) CGFloat currentPlaySpeed;
@property (nonatomic, weak) id<JXVideoViewTimeDelegate> timeDelegate;

- (void)initTime;
- (void)deallocTime;

- (void)willStartPlay;
- (void)moveToSecond:(CGFloat)second shouldPlay:(BOOL)shouldPlay;
- (void)setShouldObservePlayTime:(BOOL)shouldObservePlayTime timeGapToObserve:(CGFloat)timeGapToObserve;

- (void)durationDidLoadedWithChange:(NSDictionary *)change;

@end

