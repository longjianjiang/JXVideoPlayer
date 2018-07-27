//
//  UIPanGestureRecognizer+SliderDirection.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "UIPanGestureRecognizer+SliderDirection.h"
#import <objc/runtime.h>

@implementation UIPanGestureRecognizer (SliderDirection)

- (JXUIPanGestureSlideDirection)sliderDirection {
    return [objc_getAssociatedObject(self, @selector(sliderDirection)) unsignedIntegerValue];
}

- (void)setSliderDirection:(JXUIPanGestureSlideDirection)sliderDirection {
    objc_setAssociatedObject(self, @selector(sliderDirection), @(sliderDirection), OBJC_ASSOCIATION_ASSIGN);
}

@end
