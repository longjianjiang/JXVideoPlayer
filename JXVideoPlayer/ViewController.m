//
//  ViewController.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"

#import "JXVideoPlayer/JXVideoPlayer.h"
#import <YYImage/YYImage.h>

#import "JXVideoPlayMenu.h"

@interface ViewController ()<JXVideoViewOperationDelegate, JXVideoViewTimeDelegate, JXVideoViewPlayControlDelegate, JXVideoViewFullScreenDelegate, JXVideoViewOperationButtonDelegate, JXVideoPlayMenuDelegate>

@property (nonatomic, strong) JXVideoView *videoView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;

@property (nonatomic, strong) JXVideoPlayMenu *menu;

@property (nonatomic, assign) BOOL statusBarIsShouldHidden;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoView prepare];
    [self.view addSubview:self.videoView];
    
    
    [self.view addSubview:self.imageView];
    [self.imageView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentAnimatedImageIndex"]) {
        if (object == self.imageView) {
//            NSLog(@"image frame idx %lu", (unsigned long)self.imageView.currentAnimatedImageIndex);
        }
    }
}

- (void)dealloc {
    [self.imageView removeObserver:self forKeyPath:@"currentAnimatedImageIndex"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch then start animation image");
    [self.imageView startAnimating];
}


#pragma mark - JXVideoViewOperationDelegate
- (void)jx_videoViewDidFinishPrepare:(JXVideoView *)videoView {
    NSLog(@"did finish prepare video");
    
    [self.menu setVideoDuration:videoView.totalPlaySecond];
}

#pragma mark - JXVideoViewTimeDelegate
- (void)jx_videoView:(JXVideoView *)videoView didPlayToSecond:(CGFloat)second {
    [self.menu updateSliderValue:second];
}

- (void)jx_videoView:(JXVideoView *)videoView didBufferToProgress:(CGFloat)progress {
    [self.menu updateProgressViewValue:progress];
}

#pragma mark - JXVideoViewPlayControlDelegate
- (void)jx_videoView:(JXVideoView *)videoView playControlDidMoveToSecond:(CGFloat)second direction:(JXVideoViewPlayControlDirection)direction {
    NSLog(@"quick value is %f", second);
    [self.menu updateSliderValue:second];
}

- (void)jx_videoViewBeTapOneTime:(JXVideoView *)videoView {
    [self.videoView controlWhetherShowMenuView];
}

- (void)jx_videoViewBeTapDoubleTime:(JXVideoView *)videoView {
    self.videoView.isPlaying ? [self jx_videoMenuDidClickPauseButton:self.menu] : [self jx_videoMenuDidClickPlayButton:self.menu];
}

#pragma mark - JXVideoViewFullScreenDelegate
- (void)jx_videoVidewDidFinishEnterFullScreen:(JXVideoView *)videoView {
    [self.menu showTopView];
}

- (void)jx_videoVidewDidFinishExitFullScreen:(JXVideoView *)videoView {
    [self.menu hideTopView];
}

- (void)jx_videoViewLayoutSubviewsWhenExitFullScreen:(JXVideoView *)videoView {
     _statusBarIsShouldHidden = NO;
     [self setNeedsStatusBarAppearanceUpdate];
}

- (void)jx_videoViewLayoutSubviewsWhenEnterFullScreen:(JXVideoView *)videoView {
     _statusBarIsShouldHidden = YES;
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
    [self.videoView exitFullScreen];
}

- (void)jx_videoMenuDidClickTopViewBackButton:(JXVideoPlayMenu *)videoMenu {
    [self.videoView exitFullScreen];
}

#pragma mark - getter and setter
- (JXVideoView *)videoView {
    if (_videoView == nil) {
        CGRect rect = CGRectMake(0, 100,  [UIScreen mainScreen].bounds.size.width, 211);
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

- (YYAnimatedImageView *)imageView {
    if (_imageView == nil) {
         UIImage *apng = [YYImage imageNamed:@"uploading"];
        _imageView = [[YYAnimatedImageView alloc] initWithImage:apng];;
        _imageView.frame = CGRectMake(0, 400, 375, 120);
        _imageView.autoPlayAnimatedImage = NO;
    }
    return _imageView;
}

- (JXVideoPlayMenu *)menu {
    if (_menu == nil) {
        _menu = [JXVideoPlayMenu new];
        _menu.delegate = self;
    }
    return _menu;
}

#pragma mark - screen
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarIsShouldHidden;
}
@end
