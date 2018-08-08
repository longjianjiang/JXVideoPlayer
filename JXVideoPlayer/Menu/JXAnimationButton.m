//
//  JXAnimationButton.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/30.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXAnimationButton.h"
#import <objc/runtime.h>

#import <YYImage/YYImage.h>

@interface JXAnimationButton() {
    NSString *_normalImageName;
    NSString *_selectedImageName;
    BOOL _jxIsSelected;
    BOOL _jxIsShouldObserve;
}

@property (nonatomic, strong) YYAnimatedImageView *imageView;

@end


@implementation JXAnimationButton

#pragma mark - life cycle
- (instancetype)initWithNormalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName {
    self = [super init];
    if (self) {
        _jxIsSelected = NO;
        _jxIsShouldObserve = NO;
        
        _normalImageName = normalImageName;
        _selectedImageName = selectedImageName;
        
        [self addSubview:self.imageView];
        [[self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
        [[self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
        [[self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:YES];
        [[self.imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:YES];
        
        [self.imageView addObserver:self forKeyPath:@"currentIsPlayingAnimation" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIsPlayingAnimation"]) {
        
        if (object == self.imageView && _jxIsShouldObserve) {
            if (self.imageView.currentIsPlayingAnimation) {
                NSLog(@"play animation");
            } else {
                NSLog(@"stop animation");
                
                _jxIsShouldObserve = NO;
                self.imageView.image = nil;
                NSString *currentImageName = _jxIsSelected ? _selectedImageName : _normalImageName;
                YYImage *currentImage = [YYImage imageNamed:currentImageName];
                self.imageView.image = currentImage;
                
            }
        }
    }
}

- (void)dealloc {
    [self.imageView removeObserver:self forKeyPath:@"currentIsPlayingAnimation"];
}

#pragma mark - getter and setter
- (void)setSelected:(BOOL)selected {
    if (self.imageView.currentIsPlayingAnimation) {
        return;
    }
    
    _jxIsSelected = selected;
    
    [self.imageView startAnimating];
    _jxIsShouldObserve = YES;
}

- (BOOL)isSelected {
    return _jxIsSelected;
}

- (YYAnimatedImageView *)imageView {
    if (_imageView == nil) {
        YYImage *image = [YYImage imageNamed:_normalImageName];
        _imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.autoPlayAnimatedImage = NO;
    }
    return _imageView;
}


@end
