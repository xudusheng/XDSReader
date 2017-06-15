//
//  XDSBookModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSBookModel.h"

@implementation XDSBookModel

NSString *const kBookModelContentEncodeKey = @"content";
NSString *const kBookModelMarksEncodeKey = @"marks";
NSString *const kBookModelNotesEncodeKey = @"notes";
NSString *const kBookModelChaptersEncodeKey = @"chapters";
NSString *const kBookModelRecordEncodeKey = @"record";
NSString *const kBookModelResourceEncodeKey = @"resource";
NSString *const kBookModelMarksRecordEncodeKey = @"marksRecord";
NSString *const kBookModelBookTypeEncodeKey = @"bookType";

-(instancetype)initWithContent:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        NSMutableArray *charpter = [NSMutableArray array];
        [XDSReadOperation separateChapter:&charpter content:content];
        _chapters = charpter;
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[XDSRecordModel alloc] init];
        _record.chapterModel = charpter.firstObject;
        _record.totalChapters = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _bookType = XDSEBookTypeTxt;
    }
    return self;
}
-(instancetype)initWithePub:(NSString *)ePubPath;
{
    self = [super init];
    if (self) {
        _chapters = [XDSReadOperation ePubFileHandle:ePubPath];
        _notes = [NSMutableArray array];
        _marks = [NSMutableArray array];
        _record = [[XDSRecordModel alloc] init];
        _record.chapterModel = _chapters.firstObject;
        _record.totalChapters = _chapters.count;
        _marksRecord = [NSMutableDictionary dictionary];
        _bookType = XDSEBookTypeEpub;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:kBookModelContentEncodeKey];
    [aCoder encodeObject:self.marks forKey:kBookModelMarksEncodeKey];
    [aCoder encodeObject:self.notes forKey:kBookModelNotesEncodeKey];
    [aCoder encodeObject:self.chapters forKey:kBookModelChaptersEncodeKey];
    [aCoder encodeObject:self.record forKey:kBookModelRecordEncodeKey];
    [aCoder encodeObject:self.resource forKey:kBookModelResourceEncodeKey];
    [aCoder encodeObject:self.marksRecord forKey:kBookModelMarksRecordEncodeKey];
    [aCoder encodeObject:@(self.bookType) forKey:kBookModelBookTypeEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:kBookModelContentEncodeKey];
        self.marks = [aDecoder decodeObjectForKey:kBookModelMarksEncodeKey];
        self.notes = [aDecoder decodeObjectForKey:kBookModelNotesEncodeKey];
        self.chapters = [aDecoder decodeObjectForKey:kBookModelChaptersEncodeKey];
        self.record = [aDecoder decodeObjectForKey:kBookModelRecordEncodeKey];
        self.resource = [aDecoder decodeObjectForKey:kBookModelResourceEncodeKey];
        self.marksRecord = [aDecoder decodeObjectForKey:kBookModelMarksRecordEncodeKey];
        self.bookType = [[aDecoder decodeObjectForKey:kBookModelBookTypeEncodeKey] integerValue];
    }
    return self;
}
+(void)updateLocalModel:(XDSBookModel *)readModel url:(NSURL *)url{
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getLocalModelWithURL:(NSURL *)url
{
    NSString *key = [url.path lastPathComponent];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!data) {
        if ([[key pathExtension] isEqualToString:@"txt"]) {
            XDSBookModel *model = [[XDSBookModel alloc] initWithContent:[XDSReaderUtil encodeWithURL:url]];
            model.resource = url;
            [XDSBookModel updateLocalModel:model url:url];
            return model;
        }
        else if ([[key pathExtension] isEqualToString:@"epub"]){
            NSLog(@"this is epub");
            XDSBookModel *model = [[XDSBookModel alloc] initWithePub:url.path];
            model.resource = url;
            [XDSBookModel updateLocalModel:model url:url];
            return model;
        }
        else{
            @throw [NSException exceptionWithName:@"FileException" reason:@"文件格式错误" userInfo:nil];
        }
        
    }
    NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //主线程操作
    XDSBookModel *model = [unarchive decodeObjectForKey:key];
    return model;
}

@end
