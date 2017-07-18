//
//  XDSNoteModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSNoteModel.h"

@implementation XDSNoteModel

NSString *const kNoteModelDateEncodeKey = @"date";
NSString *const kNoteModelNoteEncodeKey = @"note";
NSString *const kNoteModelContentEncodeKey = @"content";
NSString *const kNoteModelChapterEncodeKey = @"chapter";
NSString *const kNoteModelLocationEncodeKey = @"locationInChapterContent";


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:kNoteModelDateEncodeKey];
    [aCoder encodeObject:self.note forKey:kNoteModelNoteEncodeKey];
    [aCoder encodeObject:self.content forKey:kNoteModelContentEncodeKey];
    [aCoder encodeInteger:self.chapter forKey:kNoteModelChapterEncodeKey];
    [aCoder encodeInteger:self.locationInChapterContent forKey:kNoteModelLocationEncodeKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:kNoteModelDateEncodeKey];
        self.note = [aDecoder decodeObjectForKey:kNoteModelNoteEncodeKey];
        self.content = [aDecoder decodeObjectForKey:kNoteModelContentEncodeKey];
        self.chapter = [aDecoder decodeIntegerForKey:kNoteModelChapterEncodeKey];
        self.locationInChapterContent = [aDecoder decodeIntegerForKey:kNoteModelLocationEncodeKey];
    }
    return self;
}

- (NSInteger)page{
    LPPChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapters[self.chapter];
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
