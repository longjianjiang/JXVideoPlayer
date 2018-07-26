//
//  JXVideoView+OperationButton.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+OperationButton.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import <objc/runtime.h>

@implementation JXVideoView (OperationButton)

#pragma mark - life cycle
-(void)initOperationButton {
    [self showPlayButton];
}

- (void)deallocOperationButton {
    self.operationButtonDelegate = nil;
}

- (void)layoutOperationButton {
    if (self.playButton.superview) {
        self.playButton.ct_size = CGSizeMake(68, 68);
        [self.playButton centerEqualToView:self];
        
        if ([self.operationButtonDelegate respondsToSelector:@selector(jx_videoView:layoutPlayButton:)]) {
            [self.operationButtonDelegate jx_videoView:self layoutPlayButton:self.playButton];
        }
    }
    
    if (self.replayButton.superview) {
        self.replayButton.ct_size = CGSizeMake(68, 68);
        [self.replayButton centerEqualToView:self];
        
        if ([self.operationButtonDelegate respondsToSelector:@selector(jx_videoView:layoutReplayButton:)]) {
            [self.operationButtonDelegate jx_videoView:self layoutReplayButton:self.replayButton];
        }
    }
}

#pragma mark - public method
- (void)showPlayButton {
    [self hideReplayButton];
    
    if (self.shouldShowOperationButton && self.playButton.superview == nil) {
        [self addSubview:self.playButton];
        [self layoutOperationButton];
    }
}

- (void)hidePlayButton {
    if (self.playButton.superview) {
        [self.playButton removeFromSuperview];
    }
}

- (void)showReplayButton {
    [self hidePlayButton];
    
    if (self.shouldShowOperationButton && self.replayButton.superview == nil) {
        [self addSubview:self.replayButton];
        [self layoutOperationButton];
    }
}

- (void)hideReplayButton {
    if (self.replayButton.superview) {
        [self.replayButton removeFromSuperview];
    }
}

#pragma mark - response method
- (void)didTappedPlayButton:(UIButton *)sender {
    if ([self.operationButtonDelegate respondsToSelector:@selector(jx_videoView:didTappedPlayButton:)]) {
        [self.operationButtonDelegate jx_videoView:self didTappedPlayButton:sender];
    }
    
    [self hidePlayButton];
    [self play];
}

- (void)didTappedReplayButton:(UIButton *)sender {
    if ([self.operationButtonDelegate respondsToSelector:@selector(jx_videoView:didTappedReplayButton:)]) {
        [self.operationButtonDelegate jx_videoView:self didTappedReplayButton:sender];
    }
    
    [self hideReplayButton];
    [self replay];
}

#pragma mark - getter and setter
- (BOOL)shouldShowOperationButton {
    return objc_getAssociatedObject(self, @selector(shouldShowOperationButton));
}

- (void)setShouldShowOperationButton:(BOOL)shouldShowOperationButton {
    objc_setAssociatedObject(self, @selector(shouldShowOperationButton), @(shouldShowOperationButton), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (shouldShowOperationButton) {
        [self showPlayButton];
    }
}

- (UIButton *)playButton {
    UIButton *playButton = objc_getAssociatedObject(self, @selector(playButton));
    if (playButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        objc_setAssociatedObject(self, @selector(playButton), btn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        playButton = btn;
    }
    [playButton addTarget:self action:@selector(didTappedPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    playButton.layer.zPosition = 1;
    return playButton;
}

- (void)setPlayButton:(UIButton *)playButton {
    objc_setAssociatedObject(self, @selector(playButton), playButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.shouldShowOperationButton) {
        [self showPlayButton];
    }
}

- (UIButton *)replayButton {
    UIButton *replayButton = objc_getAssociatedObject(self, @selector(replayButton));
    if (replayButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"video_replay"] forState:UIControlStateNormal];
        objc_setAssociatedObject(self, @selector(replayButton), btn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        replayButton = btn;
    }
    [replayButton addTarget:self action:@selector(didTappedReplayButton:) forControlEvents:UIControlEventTouchUpInside];
    replayButton.layer.zPosition = 1;
    return replayButton;
}

- (void)setReplayButton:(UIButton *)replayButton {
    objc_setAssociatedObject(self, @selector(replayButton), replayButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<JXVideoViewOperationButtonDelegate>)operationButtonDelegate {
    return objc_getAssociatedObject(self, @selector(operationButtonDelegate));
}

- (void)setOperationButtonDelegate:(id<JXVideoViewOperationButtonDelegate>)operationButtonDelegate {
    objc_setAssociatedObject(self, @selector(operationButtonDelegate), operationButtonDelegate, OBJC_ASSOCIATION_ASSIGN);
}

@end
