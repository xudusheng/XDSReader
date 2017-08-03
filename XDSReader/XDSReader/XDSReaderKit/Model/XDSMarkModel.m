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
NSString *const kMarkModelContentEncodeKey = @"content";
NSString *const kMarkModelChapterEncodeKey = @"chapter";
NSString *const kMarkModelLocationEncodeKey = @"locationInChapterContent";

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:kMarkModelDateEncodeKey];
    [aCoder encodeObject:self.content forKey:kMarkModelContentEncodeKey];
    [aCoder encodeInteger:self.chapter forKey:kMarkModelChapterEncodeKey];
    [aCoder encodeInteger:self.locationInChapterContent forKey:kMarkModelLocationEncodeKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:kMarkModelDateEncodeKey];
        self.content = [aDecoder decodeObjectForKey:kMarkModelContentEncodeKey];
        self.chapter = [aDecoder decodeIntegerForKey:kMarkModelChapterEncodeKey];
        self.locationInChapterContent = [aDecoder decodeIntegerForKey:kMarkModelLocationEncodeKey];
    }
    return self;
}

- (NSInteger)page{
    XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapters[self.chapter];
    NSInteger page = 0;
    if (chapterModel.pageLocations.count < 1) {
        page = 0;
    }else if (self.locationInChapterContent >= [chapterModel.pageLocations.lastObject integerValue]) {
        page = chapterModel.pageLocations.count - 1;
    }else{
        for (int i = 0; i < chapterModel.pageLocations.count; i ++) {
            NSInteger location = [chapterModel.pageLocations[i] integerValue];
            if (self.locationInChapterContent < location) {
                page = (i > 0)? (i - 1):0;
                break;
            }
        }
    }
    return page;
}
@end
