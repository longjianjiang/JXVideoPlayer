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

@interface ViewController ()<JXVideoViewOperationDelegate, JXVideoViewTimeDelegate, JXVideoViewPlayControlDelegate, JXVideoPlayMenuDelegate>

@property (nonatomic, strong) JXVideoView *videoView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) JXVideoPlayMenu *menu;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoView prepare];
    [self.view addSubview:self.videoView];
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

#pragma mark - getter and setter
- (JXVideoView *)videoView {
    if (_videoView == nil) {
        CGRect rect = CGRectMake(0, 100,  [UIScreen mainScreen].bounds.size.width, 250);
        _videoView = [[JXVideoView alloc] initWithFrame:rect];
        _videoView.operationDelegate = self;
        _videoView.videoUrl = [NSURL URLWithString:@"http://v.hexiaoxiang.com/60fecd5a82b447a9b9cca400348ec23b/4567f2da45a14b82bf96301733f02f38-5287d2089db37e62345123a1be272f8b.mp4"];
        _videoView.shouldShowOperationButton = YES;
        _videoView.shouldShowCoverViewBeforePlay = YES;
        UILabel *coverView = [[UILabel alloc] init];
        coverView.text = @"Cover View";
        coverView.textAlignment = NSTextAlignmentCenter;
        coverView.backgroundColor = [UIColor orangeColor];
        _videoView.coverView = coverView;
        [_videoView setShouldObservePlayTime:YES timeGapToObserve:100];
        _videoView.timeDelegate = self;
        _videoView.playControlDelegate = self;
        
        _videoView.menuView = self.menu;
        
    }
    return _videoView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
         UIImage *apng = [YYImage imageNamed:@"uploading"];
        _imageView = [[YYAnimatedImageView alloc] initWithImage:apng];;
        _imageView.frame = CGRectMake(0, 400, 375, 120);
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

@end
