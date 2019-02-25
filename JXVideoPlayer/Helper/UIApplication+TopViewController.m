//
//  UIApplication+TopViewController.m
//  JXVideoPlayer
//
//  Created by zl on 2019/2/25.
//  Copyright © 2019 longjianjiang. All rights reserved.
//

#import "UIApplication+TopViewController.h"

@implementation UIApplication (TopViewController)

+ (UIViewController *)topViewControllerFromVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [self topViewControllerFromVC:nav.visibleViewController];
    }

    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)vc;
        if (tabbarVC.selectedViewController) {
            return [self topViewControllerFromVC:tabbarVC.selectedViewController];
        }
    }

    if (vc.presentedViewController) {
        return [self topViewControllerFromVC:vc.presentedViewController];
    }

    return vc;
}


@end
