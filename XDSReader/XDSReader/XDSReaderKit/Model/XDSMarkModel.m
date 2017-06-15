//
//  XDSMarkModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMarkModel.h"

@implementation XDSMarkModel
NSString *const kMarkModelDateEncodeKey = @"date";
NSString *const kMarkModelRecordModelEncodeKey = @"recordModel";

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:kMarkModelDateEncodeKey];
    [aCoder encodeObject:self.recordModel forKey:kMarkModelRecordModelEncodeKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:kMarkModelDateEncodeKey];
        self.recordModel = [aDecoder decodeObjectForKey:kMarkModelRecordModelEncodeKey];
    }
    return self;
}

@end
