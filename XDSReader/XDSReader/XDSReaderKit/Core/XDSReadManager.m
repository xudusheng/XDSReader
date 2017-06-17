//
//  XDSReadManager.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadManager.h"

@implementation XDSReadManager

static XDSReadManager *readManager;

+ (XDSReadManager *)sharedManager{
    if (readManager == nil) {
        readManager = [[self alloc] init];
    } 
    return readManager;
} 

+ (id)allocWithZone:(NSZone *)zone{
    static dispatch_once_t onceToken; 
    dispatch_once(&onceToken, ^{ 
        readManager = [super allocWithZone:zone];
    }); 
    return readManager;
}

@end
