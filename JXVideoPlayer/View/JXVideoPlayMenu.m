//
//  JXVideoPlayMenu.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoPlayMenu.h"
#import <Masonry/Masonry.h>
#import "NSString+Extension.h"

@interface JXVideoPlayMenu ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UISlider *playSlider;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) CAGradientLayer *bottomGradientLayer;

@end


@implementation JXVideoPlayMenu
- (void)setMenuTitle:(NSString *)title {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.titleLabel.text = title;
    }];
}

- (void)setVideoDuration:(CGFloat)videoDuration {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.playSlider.maximumValue = videoDuration;
        self.totalTimeLabel.text = [NSString timeMsgBySeconds:videoDuration];
    }];
}

- (void)updateSliderValue:(CGFloat)currentValue {
    self.playSlider.value = currentValue;
}

- (void)updateProgressViewValue:(CGFloat)progress {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.progressView.progress = progress;
    }];
}

- (void)updatePlayOrPauseButton {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
}

- (void)updateFullScreenButton {
    self.fullScreenBtn.selected = !self.fullScreenBtn.isSelected;
}

- (void)resetMenu {
    self.playOrPauseBtn.selected = NO;
    self.progressView.progress = 0;
    self.fullScreenBtn.selected = NO;
}

- (void)showTopView {
    self.topView.hidden = NO;
}

- (void)hideTopView {
    self.topView.hidden = YES;
}

#pragma mark - life cycle
- (void)setupSubview {
    [self addSubview:self.topView];
    [self.topView.layer addSublayer:self.gradientLayer];
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.titleLabel];

    [self addSubview:self.bottomView];
    [self.bottomView.layer addSublayer:self.bottomGradientLayer];
    [self.bottomView addSubview:self.playOrPauseBtn];
    [self.bottomView addSubview:self.progressView];
    [self.bottomView addSubview:self.playSlider];
    [self.bottomView addSubview:self.totalTimeLabel];
    [self.bottomView addSubview:self.fullScreenBtn];


    [self hideTopView];
}

- (void)addSomeConstraints {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(60);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(30);
        make.leading.equalTo(self.topView).offset(16);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.top.equalTo(self.topView).offset(30);

    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.leading.equalTo(self.bottomView).offset(16);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.trailing.equalTo(self.bottomView).offset(-16);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.trailing.equalTo(self.fullScreenBtn.mas_leading).offset(-16);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.playOrPauseBtn.mas_trailing).offset(16);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-16);
        make.centerY.equalTo(self.bottomView).offset(0.5);
    }];
    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.leading.equalTo(self.playOrPauseBtn.mas_trailing).offset(16);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-16);
    }];

}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.gradientLayer.frame = self.topView.bounds;
    self.gradientLayer.colors = @[(__bridge id)([UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor), (__bridge id)([UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor)];
    self.gradientLayer.locations = @[@0.0, @1];

    self.bottomGradientLayer.frame = self.bottomView.bounds;
    self.bottomGradientLayer.colors = @[(__bridge id)([UIColor colorWithRed:0 green:0 blue:0 alpha:0].CGColor), (__bridge id)([UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor)];
    self.bottomGradientLayer.locations = @[@0.0, @1];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
        [self addSomeConstraints];
    }
    return self;
}

#pragma mark - response method
- (void)didClickPlayOrPauseButton:(UIButton *)btn {
    BOOL isSelected = btn.isSelected;

    if (isSelected == NO) { // click pause btn
        if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidClickPauseButton:)]) {
            [self.delegate jx_videoMenuDidClickPauseButton:self];
        }
    } else { // click play btn
        if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidClickPlayButton:)]) {
            [self.delegate jx_videoMenuDidClickPlayButton:self];
        }
    }

}

- (void)didClickEnterOrExitFullScreenButton:(UIButton *)btn {
    BOOL isSelected = btn.isSelected;

    if (isSelected == NO) { // click enter full screen btn
        if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidClickEnterFullScreenButton:)]) {
            [self.delegate jx_videoMenuDidClickEnterFullScreenButton:self];
        }
    } else { // click exit full screen btn
        if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidClickExitFullScreenButton:)]) {
            [self.delegate jx_videoMenuDidClickExitFullScreenButton:self];
        }
    }

    btn.selected = !btn.isSelected;
}

- (void)didClickBackBtn {
    if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidClickTopViewBackButton:)]) {
        [self.delegate jx_videoMenuDidClickTopViewBackButton:self];
    }
}

- (void)endSeekSlider {
    NSLog(@"user end move slider");
    if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidEndMoveSlider:seekValue:)]) {
        [self.delegate jx_videoMenuDidEndMoveSlider:self seekValue:self.playSlider.value];
    }
}

- (void)startSeekSlider {
    NSLog(@"user start move slider");
    if ([self.delegate respondsToSelector:@selector(jx_videoMenuDidStartMoveSlider:)]) {
        [self.delegate jx_videoMenuDidStartMoveSlider:self];
    }
}

- (void)sliderValueChanged:(UISlider *)slider {
    if ([self.delegate respondsToSelector:@selector(jx_videoMenuSliderValueChanged:)]) {
        [self.delegate jx_videoMenuSliderValueChanged:slider.value];
    }
}

#pragma mark - getter and setter
- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [UIView new];
    }
    return _bottomView;
}
- (UIButton *)playOrPauseBtn {
    if (_playOrPauseBtn == nil) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"video_menu_pause"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"video_menu_play"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(didClickPlayOrPauseButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _playOrPauseBtn;
}
- (UISlider *)playSlider {
    if (_playSlider == nil) {
        _playSlider = [UISlider new];
        [_playSlider setThumbImage:[UIImage imageNamed:@"video_menu_slider_thumb"] forState:UIControlStateNormal];
        _playSlider.minimumTrackTintColor = [UIColor orangeColor];
        _playSlider.maximumTrackTintColor = [UIColor clearColor]; //[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [_playSlider addTarget:self action:@selector(endSeekSlider) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [_playSlider addTarget:self action:@selector(startSeekSlider) forControlEvents:UIControlEventTouchDown];
        [_playSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _playSlider;
}
- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        _progressView.trackTintColor    = [UIColor grayColor];
    }
    return _progressView;
}
- (UILabel *)totalTimeLabel {
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textAlignment = NSTextAlignmentRight;
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.text = @"2:34";
    }
    return _totalTimeLabel;
}
- (UIButton *)fullScreenBtn {
    if (_fullScreenBtn == nil) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"video_menu_max"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"video_menu_min"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(didClickEnterOrExitFullScreenButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _fullScreenBtn;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [UIView new];
    }
    return _topView;
}
- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav_menu_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(didClickBackBtn) forControlEvents:UIControlEventTouchDown];
    }
    return _backBtn;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

- (CAGradientLayer *)bottomGradientLayer {
    if (_bottomGradientLayer == nil) {
        _bottomGradientLayer = [CAGradientLayer layer];
    }
    return _bottomGradientLayer;
}

@end

