//
//  XDSReaderUtil.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSReaderUtil : NSObject

+ (NSString *)encodeWithURL:(NSURL *)url;

+(UIButton *)commonButtonSEL:(SEL)sel target:(id)target;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (BOOL)isPhoneX;
+ (UIEdgeInsets)safeAreaInsets;
@end
