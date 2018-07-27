//
//  JXVideoView+PlayControlPrivate.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView+PlayControlPrivate.h"
#import <objc/runtime.h>

#import "JXVideoView+Time.h"
#import "UIPanGestureRecognizer+SliderDirection.h"
#import "JXVideoView+PlayControl.h"

#import "JXVideoView+FullScreen.h"
@implementation JXVideoView (PlayControlPrivate)

#pragma mark - life cycle
- (void)initWithPlayControlGesture {
    [self addGestureRecognizer:self.tapGestureRecognizer];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark - gesture method
- (void)didTapVideoView:(UITapGestureRecognizer *)gesture {
//    [self pause];
    if (!self.isFullScreen) {
        [self enterFullScreen];
    } else {
        [self exitFullScreen];
    }
}

- (void)didReceivePanGesture:(UIPanGestureRecognizer *)gesture {
    
    CGPoint velocityPoint = [gesture velocityInView:self];
    CGPoint locationPoint = [gesture locationInView:self];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            
            CGFloat absoluteX = fabs(velocityPoint.x);
            CGFloat absoluteY = fabs(velocityPoint.y);
            
            if (absoluteX > absoluteY) {
                self.panGestureRecognizer.sliderDirection = JXUIPanGestureSlideDirectionHorizontal;
                self.secondToMove = self.currentPlaySecond;
                if ([self.playControlDelegate respondsToSelector:@selector(jx_videoViewShowPlayControlIndicator:)]) {
                    [self.playControlDelegate jx_videoViewShowPlayControlIndicator:self];
                }
            }
            
            if (absoluteY > absoluteX) {
                self.panGestureRecognizer.sliderDirection = JXUIPanGestureSlideDirectionVertical;
                if ([self.playControlDelegate respondsToSelector:@selector(jx_videoViewHidePlayControlIndicator:)]) {
                    [self.playControlDelegate jx_videoViewHidePlayControlIndicator:self];
                }
            }
            
            break;
        }
        
        case UIGestureRecognizerStateChanged: {
            
            if (gesture.sliderDirection == JXUIPanGestureSlideDirectionHorizontal) {
                [self moveToSecondWithVelocityX:velocityPoint.x];
            }
            
            if (gesture.sliderDirection == JXUIPanGestureSlideDirectionVertical) {
                [self changeVolumeOrBrightnessWithVelocityY:velocityPoint.y
                                                   isVolume:locationPoint.x > self.bounds.size.width / 2];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            if (gesture.sliderDirection == JXUIPanGestureSlideDirectionHorizontal) {
//                [self.player play];
                 [self moveToSecond:self.secondToMove shouldPlay:YES];
                
                if ([self.playControlDelegate respondsToSelector:@selector(jx_videoViewHidePlayControlIndicator:)]) {
                    [self.playControlDelegate jx_videoViewHidePlayControlIndicator:self];
                }
            }
            
            if (gesture.sliderDirection == JXUIPanGestureSlideDirectionVertical) {
                
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - private method
- (void)moveToSecondWithVelocityX:(CGFloat)velocityX {
    JXVideoViewPlayControlDirection direction = JXVideoViewPlayControlDirectionMoveForward;
    if (velocityX < 0) {
        direction = JXVideoViewPlayControlDirectionMoveBackward;
    }
    
    self.secondToMove += velocityX / self.speedOfSecondToMove;
    if (self.secondToMove > self.totalPlaySecond) {
        self.secondToMove = self.totalPlaySecond;
    }
    if (self.secondToMove < 0) {
        self.secondToMove = 0;
    }

    if ([self.playControlDelegate respondsToSelector:@selector(jx_videoView:playControlDidMoveToSecond:direction:)]) {
        [self.playControlDelegate jx_videoView:self playControlDidMoveToSecond:self.secondToMove direction:direction];
    }
}

- (void)changeVolumeOrBrightnessWithVelocityY:(CGFloat)velocityY isVolume:(BOOL)isVolume {
    isVolume ? (self.volumeSlider.value -= velocityY / self.speedOfVolumeOrBrightnessChange) : ([UIScreen mainScreen].brightness -= velocityY / self.speedOfVolumeOrBrightnessChange);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - getter and setter
- (CGFloat)secondToMove {
    return [objc_getAssociatedObject(self, @selector(secondToMove)) floatValue];
}

- (void)setSecondToMove:(CGFloat)secondToMove {
    objc_setAssociatedObject(self, @selector(secondToMove), @(secondToMove), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    UITapGestureRecognizer *tapGesture = objc_getAssociatedObject(self, @selector(tapGestureRecognizer));
    if (tapGesture == nil) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapVideoView:)];
        tapGesture.numberOfTapsRequired = 2;
        tapGesture.delegate = self;
        
        objc_setAssociatedObject(self, @selector(tapGestureRecognizer), tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tapGesture;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, @selector(panGestureRecognizer));
    if (panGesture == nil) {
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePanGesture:)];
        panGesture.maximumNumberOfTouches = 1;
        panGesture.minimumNumberOfTouches = 1;
        panGesture.delegate = self;
        
        objc_setAssociatedObject(self, @selector(panGestureRecognizer), panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return panGesture;
}

- (UISlider *)volumeSlider {
    UISlider *volumeSlider = objc_getAssociatedObject(self, @selector(volumeSlider));
    if (volumeSlider == nil) {
        for (UIView *view in [self.volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeSlider = (UISlider *)view;
                objc_setAssociatedObject(self, @selector(volumeSlider), volumeSlider, OBJC_ASSOCIATION_ASSIGN);
                break;
            }
        }
    }
    return volumeSlider;
}
@end
