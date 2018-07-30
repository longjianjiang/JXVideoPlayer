//
//  JXVideoPlayMenu.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoPlayMenu.h"
#import <Masonry.h>

@interface JXVideoPlayMenu ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UISlider *playSlider;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;

@end


@implementation JXVideoPlayMenu

- (void)setVideoDuration:(CGFloat)videoDuration {
    self.playSlider.maximumValue = videoDuration;
    self.totalTimeLabel.text = [self timeFormatted:videoDuration];
}

- (void)updateSliderValue:(CGFloat)currentValue {
    self.playSlider.value = currentValue;
}

- (void)updateProgressViewValue:(CGFloat)progress {
    self.progressView.progress = progress;
}

- (void)updatePlayOrPauseButton {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
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
    [self.topView addSubview:self.backBtn];
    [self.topView addSubview:self.titleLabel];
    
    [self addSubview:self.bottomView];
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
        make.height.mas_equalTo(40);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.leading.equalTo(self.topView).offset(16);
        make.height.width.mas_equalTo(24);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.leading.equalTo(self.bottomView).offset(16);
        make.height.width.mas_equalTo(24);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.trailing.equalTo(self.bottomView).offset(-16);
        make.height.width.mas_equalTo(24);
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

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-self.safeAreaInsets.bottom);
        make.leading.equalTo(self).offset(self.safeAreaInsets.left);
        make.trailing.equalTo(self).offset(-self.safeAreaInsets.right);
    }];
    
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(self.safeAreaInsets.left);
        make.trailing.equalTo(self).offset(-self.safeAreaInsets.right);
    }];
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
        [_backBtn setImage:[UIImage imageNamed:@"nav_menu_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"Lesson One";
    }
    return _titleLabel;
}

#pragma mark - help method
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end
