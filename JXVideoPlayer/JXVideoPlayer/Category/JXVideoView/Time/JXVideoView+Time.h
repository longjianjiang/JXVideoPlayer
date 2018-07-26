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

- (void)initTime;
- (void)deallocTime;

- (void)moveToSecond:(CGFloat)second shouldPlay:(BOOL)shouldPlay;

@end

