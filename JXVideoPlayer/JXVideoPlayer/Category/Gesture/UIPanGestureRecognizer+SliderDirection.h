//
//  UIPanGestureRecognizer+SliderDirection.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JXUIPanGestureSlideDirection) {
    JXUIPanGestureSlideDirectionNotDefined,
    JXUIPanGestureSlideDirectionVertical,
    JXUIPanGestureSlideDirectionHorizontal
};

@interface UIPanGestureRecognizer (SliderDirection)

@property (nonatomic, assign) JXUIPanGestureSlideDirection sliderDirection;

@end

