//
//  JXGestureSeekProgressView.m
//  JXVideoPlayer
//
//  Created by zl on 2019/2/25.
//  Copyright © 2019 longjianjiang. All rights reserved.
//

#import "JXGestureSeekProgressView.h"
#include <ReactiveObjC/ReactiveObjC.h>
#import "NSString+Extension.h"

@interface JXGestureSeekProgressView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *rectView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation JXGestureSeekProgressView

#pragma mark - life cycle
- (void)setupSubview {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.rectView];
    [self.rectView addSubview:self.timeLabel];
    [self.rectView addSubview:self.progressView];
}

- (void)addSomeConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(45);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.rectView);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.rectView);
    }];
}

- (void)bind {
    @weakify(self);
    [[RACObserve(self, quickSecond) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGFloat second = [x floatValue];
        NSString *currentTime = [NSString stringWithFormat:@"%@", [NSString timeMsgBySeconds:second]];
        NSString *totalTime = [NSString stringWithFormat:@"%@",[NSString timeMsgBySeconds:self.totalSecond]];
        NSString *timeText = [NSString stringWithFormat:@"%@/%@",currentTime, totalTime];

        NSRange currentRange = [timeText rangeOfString:currentTime];
        NSRange totalRange = [timeText rangeOfString:[NSString stringWithFormat:@"/%@",totalTime]];

        NSMutableAttributedString *mutableAttriStr = [[NSMutableAttributedString alloc] initWithString:timeText];
        [mutableAttriStr addAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} range:currentRange];
        [mutableAttriStr addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:totalRange];

        self.timeLabel.attributedText = mutableAttriStr;

        self.progressView.progress = second / self.totalSecond;
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self bind];
        [self setupSubview];
        [self addSomeConstraints];
    }
    return self;
}

#pragma mark - getter and setter
- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bgView;
}
- (UIView *)rectView {
    if (_rectView == nil) {
        _rectView = [UIView new];
        _rectView.backgroundColor = [UIColor clearColor];
    }
    return _rectView;
}
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}
- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor orangeColor];
        _progressView.trackTintColor    = [UIColor grayColor];
    }
    return _progressView;
}

@end
