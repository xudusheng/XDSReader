//
//  XDSRecordModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSRecordModel.h"

@implementation XDSRecordModel

NSString *const kRecordModelChapterModelEncodeKey = @"chapterModel";
NSString *const kRecordModelCurrentPageEncodeKey = @"currentPage";
NSString *const kRecordModelCurrentChapterEncodeKey = @"currentChapter";
NSString *const kRecordModelTotalChaptersEncodeKey = @"totalChapters";

-(id)copyWithZone:(NSZone *)zone{
    XDSRecordModel *recordModel = [[XDSRecordModel allocWithZone:zone]init];
    recordModel.chapterModel = [self.chapterModel copy];
    recordModel.currentPage = self.currentPage;
    recordModel.currentChapter = self.currentChapter;
    return recordModel;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.chapterModel forKey:kRecordModelChapterModelEncodeKey];
    [aCoder encodeInteger:self.currentPage forKey:kRecordModelCurrentPageEncodeKey];
    [aCoder encodeInteger:self.currentChapter forKey:kRecordModelCurrentChapterEncodeKey];
    [aCoder encodeInteger:self.totalChapters forKey:kRecordModelTotalChaptersEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.chapterModel = [aDecoder decodeObjectForKey:kRecordModelChapterModelEncodeKey];
        self.currentPage = [aDecoder decodeIntegerForKey:kRecordModelCurrentPageEncodeKey];
        self.currentChapter = [aDecoder decodeIntegerForKey:kRecordModelCurrentChapterEncodeKey];
        self.totalChapters = [aDecoder decodeIntegerForKey:kRecordModelTotalChaptersEncodeKey];
    }
    return self;
}

@end
