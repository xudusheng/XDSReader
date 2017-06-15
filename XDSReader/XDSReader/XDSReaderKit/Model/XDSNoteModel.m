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
NSString *const kNoteModelRecordModelEncodeKey = @"recordModel";

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.date forKey:kNoteModelDateEncodeKey];
    [aCoder encodeObject:self.note forKey:kNoteModelNoteEncodeKey];
    [aCoder encodeObject:self.content forKey:kNoteModelContentEncodeKey];
    [aCoder encodeObject:self.recordModel forKey:kNoteModelRecordModelEncodeKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.date = [aDecoder decodeObjectForKey:kNoteModelDateEncodeKey];
        self.note = [aDecoder decodeObjectForKey:kNoteModelNoteEncodeKey];
        self.content = [aDecoder decodeObjectForKey:kNoteModelContentEncodeKey];
        self.recordModel = [aDecoder decodeObjectForKey:kNoteModelRecordModelEncodeKey];
    }
    return self;
}

@end
