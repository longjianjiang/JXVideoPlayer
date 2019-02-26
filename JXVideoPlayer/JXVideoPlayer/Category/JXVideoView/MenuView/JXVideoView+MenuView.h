//
//  JXVideoView+MenuView.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/29.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "JXVideoView.h"

@interface JXVideoView (MenuView)

@property (nonatomic, strong) UIView *menuView;

- (void)initMenuView;
- (void)deallocMenuView;

- (void)controlWhetherShowMenuView;
- (void)makeMenuViewNotAutoHide;
- (void)makeMenuViewAutoHide;

- (void)menuViewEnterFullScreen;
- (void)menuViewExitFullScreen;

@end

