//
//  AVAsset+JXVideoView.m
//  JXVideoPlayer
//
//  Created by zl on 2018/7/27.
//  Copyright © 2018年 longjianjiang. All rights reserved.
//

#import "AVAsset+JXVideoView.h"

@implementation AVAsset (JXVideoView)

- (BOOL)jx_isVideoPortrait {
    BOOL isPortrait = NO;
    NSArray *trackList = [self tracksWithMediaType:AVMediaTypeVideo];
    if (trackList.count > 0) {
        AVAssetTrack *track = [trackList firstObject];
        
        CGAffineTransform t = track.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = NO;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = NO;
        }
    }
    return isPortrait;
}

@end
