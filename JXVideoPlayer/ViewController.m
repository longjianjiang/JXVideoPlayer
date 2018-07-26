//
//  ViewController.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/26.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "ViewController.h"

#import "JXVideoPlayer/JXVideoPlayer.h"



@interface ViewController ()<JXVideoViewOperationDelegate>

@property (nonatomic, strong) JXVideoView *videoView;

@end

@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.videoView prepare];
    [self.view addSubview:self.videoView];
}

#pragma mark - JXVideoViewOperationDelegate
- (void)jx_videoViewDidFinishPrepare:(JXVideoView *)videoView {
    NSLog(@"did finish prepare video");
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
    }
    return _videoView;
}



@end
