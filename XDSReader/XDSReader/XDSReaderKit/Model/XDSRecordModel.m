//
//  XDSRecordModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSRecordModel.h"

@interface XDSRecordModel ()
@property (nonatomic, assign) NSInteger currentPage;    //阅读的页数
@property (nonatomic, assign) NSInteger totalPage;  //该章总页数
@property (nonatomic, assign) NSInteger totalChapters;  //总章节数

@end

@implementation XDSRecordModel

NSString *const kXDSRecordModelChapterModelEncodeKey = @"chapterModel";
NSString *const kXDSRecordModelCurrentChapterEncodeKey = @"currentChapter";
NSString *const kXDSRecordModelLocationEncodeKey = @"location";

-(id)copyWithZone:(NSZone *)zone{
    XDSRecordModel *recordModel = [[XDSRecordModel allocWithZone:zone]init];
    recordModel.chapterModel = [self.chapterModel copy];
    recordModel.location = self.location;
    recordModel.currentChapter = self.currentChapter;
    return recordModel;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.chapterModel forKey:kXDSRecordModelChapterModelEncodeKey];
    [aCoder encodeInteger:self.location forKey:kXDSRecordModelLocationEncodeKey];
    [aCoder encodeInteger:self.currentChapter forKey:kXDSRecordModelCurrentChapterEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.chapterModel = [aDecoder decodeObjectForKey:kXDSRecordModelChapterModelEncodeKey];
        self.currentChapter = [aDecoder decodeIntegerForKey:kXDSRecordModelCurrentChapterEncodeKey];
        self.location = [aDecoder decodeIntegerForKey:kXDSRecordModelLocationEncodeKey];
    }
    return self;
}


- (NSInteger)totalPage{
    return self.chapterModel.pageCount;
}
- (NSInteger)totalChapters{
    return CURRENT_BOOK_MODEL.chapters.count;
}
- (NSInteger)currentPage{
    if (self.chapterModel.pageLocations.count < 1) {
        return 0;
    }
    
    NSInteger page = 0;
    if (self.location == [self.chapterModel.pageLocations.lastObject integerValue]) {
        page = self.chapterModel.pageLocations.count - 1;
    }else{
        for (int i = 0; i < self.chapterModel.pageLocations.count; i ++) {
            NSInteger location = [self.chapterModel.pageLocations[i] integerValue];
            if (self.location < location) {
                page = (i > 0)? (i - 1):0;
                break;
            }
        }
    }
    return page;
}




@end
