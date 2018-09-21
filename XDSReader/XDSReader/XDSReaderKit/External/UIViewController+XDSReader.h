//
//  UIViewController+XDSReader.h
//  XDSReader
//
//  Created by Hmily on 2018/9/21.
//  Copyright © 2018年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (XDSReader)
/**
 背景透明的形式显示present
 
 @param viewControllerToPresent 目标控制器
 @param flag 是否动画
 @param inRransparentForm 是否透明
 @param completion 回调
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated: (BOOL)flag
            inRransparentForm:(BOOL)inRransparentForm
                   completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
@end
