//
//  JXVideoPlayMenu.h
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXVideoPlayMenu;

@protocol JXVideoPlayMenuDelegate <NSObject>

@optional
- (void)jx_videoMenuDidClickPauseButton:(JXVideoPlayMenu *)videoMenu;
- (void)jx_videoMenuDidClickPlayButton:(JXVideoPlayMenu *)videoMenu;
- (void)jx_videoMenuDidClickEnterFullScreenButton:(JXVideoPlayMenu *)videoMenu;
- (void)jx_videoMenuDidClickExitFullScreenButton:(JXVideoPlayMenu *)videoMenu;
- (void)jx_videoMenuDidClickTopViewBackButton:(JXVideoPlayMenu *)videoMenu;
@end


@interface JXVideoPlayMenu : UIView

@property (nonatomic, weak) id<JXVideoPlayMenuDelegate> delegate;

- (void)setVideoDuration:(CGFloat)videoDuration;
- (void)updateSliderValue:(CGFloat)currentValue;
- (void)updatePlayOrPauseButton;

- (void)showTopView;
- (void)hideTopView;

@end

