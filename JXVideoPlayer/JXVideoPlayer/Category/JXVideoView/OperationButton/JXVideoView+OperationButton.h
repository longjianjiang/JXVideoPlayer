//
//  JXVideoView+OperationButton.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

@interface JXVideoView (OperationButton)

@property (nonatomic, assign) BOOL shouldShowOperationButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, weak) id<JXVideoViewOperationButtonDelegate> operationButtonDelegate;

- (void)initOperationButton;
- (void)deallocOperationButton;

- (void)showPlayButton;
- (void)hidePlayButton;

- (void)layoutOperationButton;

@end

