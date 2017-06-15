//
//  XDSMarkModel.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSMarkModel : NSObject<NSCoding>

@property (nonatomic,strong) NSDate *date;//添加书签的日期
@property (nonatomic,strong) XDSRecordModel *recordModel;//书签的位置

@end
