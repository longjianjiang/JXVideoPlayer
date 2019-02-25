//
//  ViewController.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"

#import "JXVideoPlayer.h"
#import "JXVideoPlayMenu.h"
#import "JXGestureSeekProgressView.h"
#import "UIApplication+TopViewController.h"

#import <HandyFrame/UIView+LayoutMethods.h>
#include <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()<JXVideoViewOperationDelegate, JXVideoViewTimeDelegate, JXVideoViewPlayControlDelegate, JXVideoViewFullScreenDelegate, JXVideoViewOperationButtonDelegate, JXVideoPlayMenuDelegate> {
    BOOL _isMoveSlider;
    BOOL _statusBarIsShouldHidden;
    BOOL _isPauseByBackgroundMode;
    UIStatusBarStyle _sbStyle;
}

@property (nonatomic, strong) JXVideoView *videoView;
@property (nonatomic, strong) JXGestureSeekProgressView *gesturePreviewView;
@property (nonatomic, strong) JXVideoPlayMenu *menu;

@end


@implementation ViewController

#pragma mark - life cycle

- (void)dealloc {
    [self resignNotification];
    [self.videoView stopWithReleaseVideo:YES];
    self.videoView.timeDelegate = nil;
    self.videoView.operationDelegate = nil;
    self.videoView.operationButtonDelegate = nil;
    self.videoView.playControlDelegate = nil;
    self.videoView.fullScreenDelegate = nil;
}

- (void)bind {
    @weakify(self);
    [[RACObserve(self.videoView.menuView, hidden) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.videoView.isFullScreen) {
            self->_statusBarIsShouldHidden = [x boolValue];
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerNotification];
    [self bind];
    [self setupSubview];
}

- (void)setupSubview {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.videoView];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_entereBackgroundMode) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_enterForegroundMode) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)resignNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification method
- (void)_entereBackgroundMode {
    if (self.menu.hidden && self.videoView.isFullScreen) {
        [self.videoView controlWhetherShowMenuView];
    }
    if (self.videoView.isPlaying == NO) {
        return;
    }
    _isPauseByBackgroundMode = YES;
    [self.videoView pause];
}

- (void)_enterForegroundMode {
    if (_isPauseByBackgroundMode == NO) {
        return;
    }

    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *vc = [UIApplication topViewControllerFromVC:rootVC];
    if (self.presentedViewController == nil && vc == self && self.videoView.prepareStatus == JXVideoViewPrepareStatusPrepareFinished) {
        [self.videoView play];
        // 没有这个判断，进后台后，退出全屏后导航栏显示异常
        if (self.menu.hidden && self.videoView.isFullScreen) {
            [self.videoView controlWhetherShowMenuView];
        }
        _isPauseByBackgroundMode = NO;
    }
}

#pragma mark - JXVideoViewOperationDelegate
- (void)jx_videoViewDidFinishPlaying:(JXVideoView *)videoView {
    [self.menu resetMenu];
    [self.videoView makeMenuHide];
    if (self.videoView.isFullScreen) {
        [self.videoView exitFullScreen];
        _statusBarIsShouldHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - JXVideoViewTimeDelegate
- (void)jx_videoView:(JXVideoView *)videoView didPlayToSecond:(CGFloat)second {
    if (_isMoveSlider == NO) {
        [self.menu updateSliderValue:second];
    }
}

- (void)jx_videoView:(JXVideoView *)videoView didBufferToProgress:(CGFloat)progress {
    [self.menu updateProgressViewValue:progress];
}

- (void)jx_videoViewDidLoadVideoDuration:(JXVideoView *)videoView {
    [self.menu setVideoDuration:videoView.totalPlaySecond];
    [self.menu setMenuTitle:@"Title"];
}

- (void)jx_videoView:(JXVideoView *)videoView didFinishedMoveToTime:(CMTime)time {
    _isMoveSlider = NO;
    [self.videoView makeMenuViewAutoHide];
    if (self.videoView.isPlaying == NO) {
        [self.menu updatePlayOrPauseButton];
    }
}

- (void)showGesturePreviewView {
    self.gesturePreviewView.quickSecond = self.videoView.currentPlaySpeed;
    [self.gesturePreviewView sizeToFit];
    self.gesturePreviewView.alpha = 0;
    [self.videoView addSubview:self.gesturePreviewView];
    [self.gesturePreviewView centerEqualToView:self.videoView];
    [UIView animateWithDuration:0.3 animations:^{
        self.gesturePreviewView.alpha = 1;
    }];
}

- (void)hideGesturePreviewView {
    [UIView animateWithDuration:0.4 animations:^{
        self.gesturePreviewView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.gesturePreviewView removeFromSuperview];
    }];
}

- (void)updateGesturePreView:(CGFloat)second {
    self.gesturePreviewView.quickSecond = second;
}

#pragma mark - JXVideoViewPlayControlDelegate
- (void)jx_videoViewShowPlayControlIndicator:(JXVideoView *)videoView {
    _isMoveSlider = YES;

    self.gesturePreviewView.quickSecond = videoView.currentPlaySecond;
    [self.gesturePreviewView sizeToFit];
    self.gesturePreviewView.alpha = 0;
    [self.videoView addSubview:self.gesturePreviewView];
    [self.gesturePreviewView centerEqualToView:videoView];
    [UIView animateWithDuration:0.3 animations:^{
        self.gesturePreviewView.alpha = 1;
    }];
}

- (void)jx_videoViewHidePlayControlIndicator:(JXVideoView *)videoView {
    [UIView animateWithDuration:0.4 animations:^{
        self.gesturePreviewView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.gesturePreviewView removeFromSuperview];
    }];
}

- (void)jx_videoView:(JXVideoView *)videoView playControlDidMoveToSecond:(CGFloat)second direction:(JXVideoViewPlayControlDirection)direction {
    [self.menu updateSliderValue:second];
    self.gesturePreviewView.quickSecond = second;
}

- (void)jx_videoViewBeTapOneTime:(JXVideoView *)videoView {
    if (self.videoView.playButton.superview == nil) {
        [self.videoView controlWhetherShowMenuView];
    }
}

- (void)jx_videoViewBeTapDoubleTime:(JXVideoView *)videoView {
    if (self.videoView.playButton.superview == nil) {
        self.videoView.isPlaying ? [self jx_videoMenuDidClickPauseButton:self.menu] : [self jx_videoMenuDidClickPlayButton:self.menu];
    }
}


#pragma mark - JXVideoViewFullScreenDelegate
- (void)jx_videoVidewDidFinishEnterFullScreen:(JXVideoView *)videoView {
    [self.menu showTopView];
}

- (void)jx_videoVidewDidFinishExitFullScreen:(JXVideoView *)videoView {
    self.menu.alpha = 1;
    [self.menu hideTopView];
}

- (void)jx_videoViewLayoutSubviewsWhenExitFullScreen:(JXVideoView *)videoView {
    _sbStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)jx_videoViewLayoutSubviewsWhenEnterFullScreen:(JXVideoView *)videoView {
    _sbStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - JXVideoViewOperationButtonDelegate
- (void)jx_videoView:(JXVideoView *)videoView didTappedPlayButton:(UIButton *)playButton {
    if (self.videoView.menuView.frame.size.height) { // 判断menu是否真的已经显示，否则不更新按钮状态
        [self.menu updatePlayOrPauseButton];
    }
}

#pragma mark - JXVideoPlayMenuDelegate
- (void)jx_videoMenuDidClickPauseButton:(JXVideoPlayMenu *)videoMenu {
    [self.videoView pause];
    [videoMenu updatePlayOrPauseButton];
}

- (void)jx_videoMenuDidClickPlayButton:(JXVideoPlayMenu *)videoMenu {
    [self.videoView play];
    [videoMenu updatePlayOrPauseButton];
}

- (void)jx_videoMenuDidClickEnterFullScreenButton:(JXVideoPlayMenu *)videoMenu {
    [self.videoView enterFullScreen];
}

- (void)jx_videoMenuDidClickExitFullScreenButton:(JXVideoPlayMenu *)videoMenu {
    [self.videoView makeMenuViewNotAutoHide];
    self.menu.alpha = 0;
    [self.videoView exitFullScreen];
}

- (void)jx_videoMenuDidClickTopViewBackButton:(JXVideoPlayMenu *)videoMenu {
    [self.videoView makeMenuViewNotAutoHide];
    self.menu.alpha = 0;
    [self.videoView exitFullScreen];
    [videoMenu updateFullScreenButton];
}

- (void)jx_videoMenuDidStartMoveSlider:(JXVideoPlayMenu *)videoMenu {
    _isMoveSlider = YES;
    [self showGesturePreviewView];
    [self.videoView makeMenuViewNotAutoHide];
}

- (void)jx_videoMenuSliderValueChanged:(CGFloat)second {
    [self updateGesturePreView:second];
}

- (void)jx_videoMenuDidEndMoveSlider:(JXVideoPlayMenu *)videoMenu seekValue:(CGFloat)seekValue {
    [self hideGesturePreviewView];
    [self.videoView moveToSecond:seekValue shouldPlay:YES];
}

#pragma mark - getter and setter
- (JXVideoView *)videoView {
    if (_videoView == nil) {
        CGRect rect = CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, SCREEN_WIDTH * 9 / 16);
        _videoView = [[JXVideoView alloc] initWithFrame:rect];
        _videoView.backgroundColor = [UIColor blackColor];
        _videoView.operationDelegate = self;
        _videoView.videoUrl = [NSURL URLWithString:@"http://v.hexiaoxiang.com/60fecd5a82b447a9b9cca400348ec23b/4567f2da45a14b82bf96301733f02f38-5287d2089db37e62345123a1be272f8b.mp4"];
        _videoView.shouldShowOperationButton = YES;
        _videoView.operationButtonDelegate = self;
        _videoView.shouldShowCoverViewBeforePlay = YES;
        UILabel *coverView = [[UILabel alloc] init];
        coverView.text = @"Cover View";
        coverView.textAlignment = NSTextAlignmentCenter;
        coverView.backgroundColor = [UIColor orangeColor];
        _videoView.coverView = coverView;
        [_videoView setShouldObservePlayTime:YES timeGapToObserve:100];
        _videoView.timeDelegate = self;
        _videoView.playControlDelegate = self;
        _videoView.fullScreenDelegate = self;
        _videoView.menuView = self.menu;
        
    }
    return _videoView;
}

- (JXVideoPlayMenu *)menu {
    if (_menu == nil) {
        _menu = [JXVideoPlayMenu new];
        _menu.delegate = self;
    }
    return _menu;
}

- (JXGestureSeekProgressView *)gesturePreviewView {
    if (_gesturePreviewView == nil) {
        _gesturePreviewView = [JXGestureSeekProgressView new];
        _gesturePreviewView.backgroundColor = [UIColor whiteColor];
        _gesturePreviewView.totalSecond = self.videoView.totalPlaySecond;
    }
    return _gesturePreviewView;
}

#pragma mark - screen
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarIsShouldHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _sbStyle;
}

@end
