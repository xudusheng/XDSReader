//
//  XDSRecordModel.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSRecordModel : NSObject<NSCopying,NSCoding>
@property (nonatomic,strong) XDSChapterModel *chapterModel;  //阅读的章节
@property (nonatomic) NSUInteger currentPage;    //阅读的页数
@property (nonatomic) NSUInteger currentChapter; //阅读的章节
@property (nonatomic) NSUInteger totalChapters;  //总章节数

@end
