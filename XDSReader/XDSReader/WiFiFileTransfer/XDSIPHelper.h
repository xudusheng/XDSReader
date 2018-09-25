//
//  XDSIPHelper.h
//  XDSPractice
//
//  Created by zhengda on 15/12/21.
//  Copyright © 2015年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XDSIPHelper : NSObject

/**
 获取设备当前的IP地址

 @return 当前IP地址
 */
+ (NSString *)deviceIPAdress;

/**
 获取当前连接的WiFi名称

 @return WiFi名称
 */
+ (NSString *)getWifiName;

/**
 总存储空间

 @return **G
 */
+ (NSString *)getMaxSpace;

/**
 剩余可用存储空间

 @return **G
 */
+ (NSString *)getFreeSpace;
@end
