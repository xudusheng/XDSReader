//
//  XDSReadOperation.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSReadOperation : NSObject

+ (void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content;

/**
 * ePub格式处理
 * 返回章节信息数组
 */
+ (NSMutableArray *)ePubFileHandle:(NSString *)path bookInfoModel:(LPPBookInfoModel *)bookInfoModel;

@end
