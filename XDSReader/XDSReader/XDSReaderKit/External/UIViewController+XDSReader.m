//
//  UIViewController+XDSReader.m
//  XDSReader
//
//  Created by Hmily on 2018/9/21.
//  Copyright © 2018年 macos. All rights reserved.
//

#import "UIViewController+XDSReader.h"

@implementation UIViewController (XDSReader)
#pragma mark - 获取当前可见ViewController
+ (UIViewController *)xds_visiableViewController {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [UIViewController xds_topViewControllerForViewController:rootViewController];
}

+ (UIViewController *)xds_topViewControllerForViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self xds_topViewControllerForViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)viewController visibleViewController];
    } else {
        if (viewController.presentedViewController) {
            return [self xds_topViewControllerForViewController:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated: (BOOL)flag
            inRransparentForm:(BOOL)inRransparentForm
                   completion:(void (^ __nullable)(void))completion
{
    if (!inRransparentForm) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
        return;
    }
    viewControllerToPresent.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        viewControllerToPresent.providesPresentationContextTransitionStyle = YES;
        viewControllerToPresent.definesPresentationContext = YES;
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
@end
