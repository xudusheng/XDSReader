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
    XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapters[self.chapter];
    for (int i = 0; i < chapterModel.pageArray.count; i ++) {
        NSInteger pageLocation = [chapterModel.pageArray[i] integerValue];
        if (pageLocation < self.locationInChapterContent) {
            return (i < 1)?0:(i-1);
        }
    }
    return 0;
}
@end
