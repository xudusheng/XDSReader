//
//  XDSReadOperation.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XDSEPUB)

- (NSString *)fullPath;
- (NSString *)relativePath;
- (NSString *)archiverPath;

@end

@interface XDSReadOperation : NSObject

+ (void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content;

/**
 * ePub格式处理
 * 返回章节信息数组
 */
+ (NSMutableArray *)ePubFileHandle:(NSString *)path bookInfoModel:(LPPBookInfoModel *)bookInfoModel;


/**
 获取epub的基本信息

 @param url epub的url
 @return epub的基本信息模型
 */
+ (LPPBookInfoModel *)getBookInfoWithFile:(NSURL *)url ;

/**
 根据bookBaseInfo获取章节

 @param bookInfo epub基本信息
 @return 章节数组
 */
+ (NSMutableArray *)readChaptersWithBookInfo:(LPPBookInfoModel *)bookInfo;
@end
