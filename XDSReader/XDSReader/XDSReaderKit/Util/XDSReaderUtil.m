//
//  XDSReaderUtil.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReaderUtil.h"

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
@end

@implementation XDSReaderUtil
+ (NSString *)encodeWithURL:(NSURL *)url{
    if (!url) {
        return @"";
    }
    NSString *content = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    //解决中文乱码
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
    }
    if (!content) {
        content = [NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
    }
    if (!content) {
        return @"";
    }
    
    NSString * regExpStr = @"( *)([(\\n)|(\\r)|(\\f)|(\\t)]+)( *)";
    NSString * replacement = @"\n";
    
    content = [content xds_replaceMatchRegex:regExpStr withString:replacement];
    
    return content;
    
}

+ (UIButton *)commonButtonSEL:(SEL)sel target:(id)target{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        action;
    })];

    [[UIViewController xds_visiableViewController] presentViewController:alertVC animated:YES completion:nil];;
}

+ (BOOL)isPhoneX {
#if TARGET_OS_IOS
    
    BOOL isPhoneX = NO;
    
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 0.0 ||
            [UIApplication sharedApplication].delegate.window.safeAreaInsets.left > 0.0) {
            isPhoneX = YES;
        }
    }
    
    return isPhoneX;
#else
    
    return NO;
    
#endif
}

+ (UIEdgeInsets)safeAreaInsets {
#if TARGET_OS_IOS
    
    UIEdgeInsets value = UIEdgeInsetsZero;
    
    if (@available(iOS 11.0, *)) {
        value = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
        if (![self isPhoneX]) {
            value.top = 20.f;
        }
    }
    
    return value;
    
#else
    
    UIEdgeInsets value = UIEdgeInsetsZero;
    
    if (@available(tvOS 11.0, *)) {
        value = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    
    return value;
    
#endif
    
}

@end
