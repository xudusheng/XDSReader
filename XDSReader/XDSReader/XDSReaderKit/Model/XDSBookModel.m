//
//  XDSBookModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSBookModel.h"
@interface XDSBookModel()
@property (nonatomic,strong) NSMutableArray<XDSChapterModel*> *chapters;//章节
@property (nonatomic,copy) NSArray <XDSChapterModel*> *chapterContainNotes;//包含笔记的章节
@property (nonatomic,copy) NSMutableArray <XDSChapterModel*> *chapterContainMarks;//包含笔记的章节
@end
@implementation XDSBookModel

NSString *const kBookModelResourceEncodeKey = @"resource";
NSString *const kBookModelContentEncodeKey = @"content";
NSString *const kBookModelBookTypeEncodeKey = @"bookType";
NSString *const kBookModelChaptersEncodeKey = @"chapters";
NSString *const kBookModelMarksRecordEncodeKey = @"marksRecord";
NSString *const kBookModelRecordEncodeKey = @"record";

- (instancetype)initWithContent:(NSString *)content{
    self = [super init];
    if (self) {
        _content = content;
        NSMutableArray *charpter = [NSMutableArray array];
        [XDSReadOperation separateChapter:&charpter content:content];
        _chapters = charpter;
        _record = [[XDSRecordModel alloc] init];
        _record.chapterModel = charpter.firstObject;
        _record.location = 0;
        _marksRecord = [NSMutableDictionary dictionary];
        _bookType = XDSEBookTypeTxt;
    }
    return self;
}
- (instancetype)initWithePub:(NSString *)ePubPath;{
    self = [super init];
    if (self) {
        _chapters = [XDSReadOperation ePubFileHandle:ePubPath bookInfoModel:nil];
        _record = [[XDSRecordModel alloc] init];
        _record.chapterModel = _chapters.firstObject;
        _record.location = 0;
        _marksRecord = [NSMutableDictionary dictionary];
        _bookType = XDSEBookTypeEpub;
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:kBookModelContentEncodeKey];
    [aCoder encodeObject:self.chapters forKey:kBookModelChaptersEncodeKey];
    [aCoder encodeObject:self.record forKey:kBookModelRecordEncodeKey];
    [aCoder encodeObject:self.resource forKey:kBookModelResourceEncodeKey];
    [aCoder encodeObject:self.marksRecord forKey:kBookModelMarksRecordEncodeKey];
    [aCoder encodeObject:@(self.bookType) forKey:kBookModelBookTypeEncodeKey];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:kBookModelContentEncodeKey];
        self.chapters = [aDecoder decodeObjectForKey:kBookModelChaptersEncodeKey];
        self.record = [aDecoder decodeObjectForKey:kBookModelRecordEncodeKey];
        self.resource = [aDecoder decodeObjectForKey:kBookModelResourceEncodeKey];
        self.marksRecord = [aDecoder decodeObjectForKey:kBookModelMarksRecordEncodeKey];
        self.bookType = [[aDecoder decodeObjectForKey:kBookModelBookTypeEncodeKey] integerValue];
    }
    return self;
}
+ (void)updateLocalModel:(XDSBookModel *)readModel url:(NSURL *)url{
    NSString *key = [url.path lastPathComponent];
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:readModel forKey:key];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getLocalModelWithURL:(NSURL *)url{
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

//TODO: Notes
- (void)deleteNote:(XDSNoteModel *)noteModel{
    
}
- (void)addNote:(XDSNoteModel *)noteModel{
    XDSChapterModel *chapterModel = self.chapters[noteModel.chapter];
    NSMutableArray *notes = [NSMutableArray arrayWithCapacity:0];
    if (chapterModel.notes) {
        [notes addObjectsFromArray:chapterModel.notes];
    }
    [notes addObject:noteModel];
    chapterModel.notes = notes;

    [XDSBookModel updateLocalModel:self url:self.resource]; //本地保存
    [self devideChaptersContainNotes];
}

- (void)devideChaptersContainNotes{
    NSMutableArray *chapterContainNotes = [NSMutableArray arrayWithCapacity:0];
    for (XDSChapterModel *chapterModel in self.chapters) {
        if (chapterModel.notes.count) {
            [chapterContainNotes addObject:chapterModel];
        }
    }
    self.chapterContainNotes = chapterContainNotes;
}

- (NSArray<XDSChapterModel *> *)chapterContainNotes{
    if (nil == _chapterContainNotes) {
        [self devideChaptersContainNotes];
    }
    return _chapterContainNotes;
}


//TODO: Marks
- (void)deleteMark:(XDSMarkModel *)markModel{
    [self addMark:markModel];
}
- (void)addMark:(XDSMarkModel *)markModel{
    XDSChapterModel *chapterModel = self.chapters[markModel.chapter];
    if (self.record.currentChapter != markModel.chapter) {//如果章节不同，先更新更加信息
        NSInteger pageNon = 0;
        [chapterModel updateFontAndGetNewPageFromOldPage:&pageNon];
    }
    NSMutableArray *marks = [NSMutableArray arrayWithCapacity:0];
    if (chapterModel.marks) {
        [marks addObjectsFromArray:chapterModel.marks];
    }
    
    if ([chapterModel isMarkAtPage:markModel.page]) { //contains mark 如果存在，移除书签信息
        for (XDSMarkModel *mark in marks) {
            if (mark.page == markModel.page) {
                [marks removeObject:mark];
            }
        }
    }else{// doesn't contain mark 记录书签信息
        [marks addObject:markModel];
    }
    chapterModel.marks = marks;
    [XDSBookModel updateLocalModel:self url:self.resource]; //本地保存
    [self devideChaptersContainMarks];
}

- (void)devideChaptersContainMarks{
    NSMutableArray *chapterContainMarks = [NSMutableArray arrayWithCapacity:0];
    for (XDSChapterModel *chapterModel in self.chapters) {
        if (chapterModel.marks.count) {
            [chapterContainMarks addObject:chapterModel];
        }
    }
    self.chapterContainMarks = chapterContainMarks;
}

- (NSArray<XDSChapterModel *> *)chapterContainMarks{
    if (nil == _chapterContainMarks) {
        [self devideChaptersContainMarks];
    }
    return _chapterContainMarks;
}


@end
