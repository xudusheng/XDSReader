//
//  XDSChapterModel.h
//  XDSReader
//
//  Created by dusheng.xu on 06/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  NS_ENUM(NSInteger,LPPEBookType){
    LPPEBookTypeTxt,
    LPPEBookTypeEpub,
};

@interface XDSChapterModel : NSObject <NSCopying,NSCoding>

@property (nonatomic, copy) XDSReadConfig *currentConfig;

@property (nonatomic, copy) NSString *chapterSrc;//epub章节路径，加载epub内容时使用该字段
@property (nonatomic, copy) NSString *originContent;//txt原始内容，加载txt内容时使用该字段

@property (nonatomic, copy) NSString *chapterName;//章节名称
@property (nonatomic, readonly) NSAttributedString *chapterAttributeContent;//全章的富文本
@property (nonatomic, readonly) NSString *chapterContent;//全章的out文本
@property (nonatomic, readonly) NSArray *pageAttributeStrings;//每一页的富文本
@property (nonatomic, readonly) NSArray *pageStrings;//每一页的普通文本
@property (nonatomic, readonly) NSArray *pageLocations;//每一页在章节中的位置
@property (nonatomic, readonly) NSInteger pageCount;//章节总页数

@property (nonatomic, readonly) NSArray<NSString *> *imageSrcArray;//本章所有图片的链接
@property (nonatomic, readonly) NSArray<XDSNoteModel *>*notes;
@property (nonatomic, readonly) NSArray<XDSMarkModel *>*marks;

- (void)paginateEpubWithBounds:(CGRect)bounds;
- (void)addNote:(XDSNoteModel *)noteModel;//insert a book note into chapter 向该章节中插入一条笔记
- (void)addOrDeleteABookmark:(XDSMarkModel *)markModel;//insert a bookmark into chapter 向该章节中插入一条书签

- (BOOL)isMarkAtPage:(NSInteger)page;
- (NSArray *)notesAtPage:(NSInteger)page;

- (BOOL)isReadConfigChanged;


@end
