//
//  LPPRecordModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPRecordModel.h"

@interface LPPRecordModel ()
@property (nonatomic, assign) NSInteger currentPage;    //阅读的页数
@property (nonatomic, assign) NSInteger totalPage;  //该章总页数
@property (nonatomic, assign) NSInteger totalChapters;  //总章节数

@end

@implementation LPPRecordModel

NSString *const kLPPRecordModelChapterModelEncodeKey = @"chapterModel";
NSString *const kLPPRecordModelCurrentChapterEncodeKey = @"currentChapter";
NSString *const kLPPRecordModelLocationEncodeKey = @"location";

-(id)copyWithZone:(NSZone *)zone{
    LPPRecordModel *recordModel = [[LPPRecordModel allocWithZone:zone]init];
    recordModel.chapterModel = [self.chapterModel copy];
    recordModel.location = self.location;
    recordModel.currentChapter = self.currentChapter;
    return recordModel;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.chapterModel forKey:kLPPRecordModelChapterModelEncodeKey];
    [aCoder encodeInteger:self.location forKey:kLPPRecordModelLocationEncodeKey];
    [aCoder encodeInteger:self.currentChapter forKey:kLPPRecordModelCurrentChapterEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.chapterModel = [aDecoder decodeObjectForKey:kLPPRecordModelChapterModelEncodeKey];
        self.currentChapter = [aDecoder decodeIntegerForKey:kLPPRecordModelCurrentChapterEncodeKey];
        self.location = [aDecoder decodeIntegerForKey:kLPPRecordModelLocationEncodeKey];
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
