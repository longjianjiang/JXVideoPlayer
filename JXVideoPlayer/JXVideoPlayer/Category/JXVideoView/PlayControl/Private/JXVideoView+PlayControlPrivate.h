//
//  JXVideoView+PlayControlPrivate.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

@interface JXVideoView (PlayControlPrivate)<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat secondToMove;

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *twoTapGestureRecognizer;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *oneTapGestureRecognizer;
@property (nonatomic, strong, readonly) UISlider *volumeSlider;

- (void)initWithPlayControlGesture;

@end

