//
//  XDSReaderUtil.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (XDSReader)
/**
 *  获取当前可见ViewController
 *
 *  NS_EXTENSION_UNAVAILABLE_IOS
 *  标记iOS插件不能使用这些API,后面有一个参数，可以作为提示，用什么API替换
 */

+ (UIViewController *)xds_visiableViewController NS_EXTENSION_UNAVAILABLE_IOS("iOS插件不能使用这些API，请参考实现方法重新定义API");
@end


@interface XDSReaderUtil : NSObject

+ (NSString *)encodeWithURL:(NSURL *)url;

+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (BOOL)isPhoneX;
+ (UIEdgeInsets)safeAreaInsets;
@end
