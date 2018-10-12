//
//  XDSReadManager.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadManager.h"

@implementation XDSReadManager

static XDSReadManager *readManager;

+ (XDSReadManager *)sharedManager{
    if (readManager == nil) {
        readManager = [[self alloc] init];
    } 
    return readManager;
} 

+ (id)allocWithZone:(NSZone *)zone{
    static dispatch_once_t onceToken; 
    dispatch_once(&onceToken, ^{ 
        readManager = [super allocWithZone:zone];
    }); 
    return readManager;
}

+ (CGRect)readViewFrame {
    CGRect frame = CGRectMake(0,
                               0,
                               DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                               DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    return frame;
}

+ (UIEdgeInsets)readViewEdgeInsets {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(DEVICE_STATUS_BAR_HEIGHT,
                                               kReadViewMarginLeft,
                                               kReadViewMarginBottom,
                                               kReadViewMarginRight);
    return edgeInsets;
}


+ (CGRect)readViewContentFrame {
    CGRect frame = [self readViewFrame];
    UIEdgeInsets edgeInsets = [self readViewEdgeInsets];
    
    CGRect bounds = CGRectZero;
    bounds.origin.x = frame.origin.x - edgeInsets.left;
    bounds.origin.y = frame.origin.y - edgeInsets.top;
    bounds.size.height = frame.size.height - edgeInsets.top - edgeInsets.bottom;
    bounds.size.width = frame.size.width - edgeInsets.left - edgeInsets.right;
    return bounds;
}

//MARK: - //获取对于章节页码的radViewController
- (XDSReadViewController *)readViewWithChapter:(NSInteger *)chapter
                                          page:(NSInteger *)page
                                       pageUrl:(NSString *)pageUrl{
    
    XDSChapterModel *currentChapterModel = _bookModel.chapters[*chapter];
    if (currentChapterModel.isReadConfigChanged) {
        [CURRENT_BOOK_MODEL loadContentInChapter:currentChapterModel];
        if (currentChapterModel == CURRENT_RECORD.chapterModel) {
            *page = CURRENT_RECORD.currentPage;
        }
    }
    
    if (*page < 0){
        *page = currentChapterModel.pageCount - 1;
    }
    
    XDSReadViewController *readView = [[XDSReadViewController alloc] init];
    readView.chapterNum = *chapter;
    readView.pageNum = *page;
    readView.pageUrl = pageUrl;
    return readView;
}

- (void)loadContentInChapter:(NSInteger)chapter{
    XDSChapterModel *chapterModel = _bookModel.chapters[chapter];
    if (!chapterModel.chapterAttributeContent) {
        [CURRENT_BOOK_MODEL loadContentInChapter:chapterModel];
    }
}
//MARK: - 跳转到指定章节（上一章，下一章，slider，目录）
- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page{
    //跳转到指定章节
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewJumpToChapter:page:)]) {
        [self.rmDelegate readViewJumpToChapter:chapter page:page];
    }
    //更新阅读记录
    [self updateReadModelWithChapter:chapter page:page];
}
//MARK: - 跳转到指定笔记，因为是笔记是基于位置查找的，使用page查找可能出错
- (void)readViewJumpToNote:(XDSNoteModel *)note{
    XDSChapterModel *currentChapterModel = _bookModel.chapters[note.chapter];
    if (currentChapterModel.isReadConfigChanged) {
        [CURRENT_BOOK_MODEL loadContentInChapter:currentChapterModel];
    }
    [self readViewJumpToChapter:note.chapter page:note.page];
}

//MARK: - 跳转到指定书签，因为是书签是基于位置查找的，使用page查找可能出错
- (void)readViewJumpToMark:(XDSMarkModel *)mark{
    
    XDSChapterModel *currentChapterModel = _bookModel.chapters[mark.chapter];
    if (currentChapterModel.isReadConfigChanged) {
        [CURRENT_BOOK_MODEL loadContentInChapter:currentChapterModel];
    }
    
    [self readViewJumpToChapter:mark.chapter page:mark.page];
}
//MARK: - 设置字体
- (void)configReadFontSize:(BOOL)plus{
    if ([XDSReadConfig shareInstance].currentFontSize < 1) {
        [XDSReadConfig shareInstance].currentFontSize = [XDSReadConfig shareInstance].cachefontSize;
    }
    if (plus) {
        [XDSReadConfig shareInstance].currentFontSize++;
        if (floor([XDSReadConfig shareInstance].currentFontSize) >= floor(kXDSReadViewMaxFontSize)) {
            [XDSReadConfig shareInstance].currentFontSize = kXDSReadViewMaxFontSize;
        }
    }else{
        [XDSReadConfig shareInstance].currentFontSize--;
        if (floor([XDSReadConfig shareInstance].currentFontSize) <= floor(kXDSReadViewMinFontSize)){
            [XDSReadConfig shareInstance].currentFontSize = kXDSReadViewMinFontSize;
        }
    }
    
    if (CURRENT_RECORD.chapterModel.isReadConfigChanged) {
        [CURRENT_BOOK_MODEL loadContentInChapter:CURRENT_RECORD.chapterModel];
    }
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewFontDidChanged)]) {
        [self.rmDelegate readViewFontDidChanged];
    }
}

- (void)configReadFontName:(NSString *)fontName{
    
    //更新字体信息
    [[XDSReadConfig shareInstance] setCurrentFontName:fontName];
    
    //重新加载章节内容
    XDSChapterModel *currentChapterModel = CURRENT_RECORD.chapterModel;
    [CURRENT_BOOK_MODEL loadContentInChapter:currentChapterModel];
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewFontDidChanged)]) {
        [self.rmDelegate readViewFontDidChanged];
    }
}

- (void)configReadTheme:(UIColor *)theme{
    [XDSReadConfig shareInstance].currentTheme = theme;
    
    XDSChapterModel *currentChapterModel = CURRENT_RECORD.chapterModel;
    [CURRENT_BOOK_MODEL loadContentInChapter:currentChapterModel];
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewThemeDidChanged)]) {
        [self.rmDelegate readViewThemeDidChanged];
    }
}
//MARK: - 更新阅读记录
-(void)updateReadModelWithChapter:(NSInteger)chapter page:(NSInteger)page{
    if (chapter < 0) {
        chapter = 0;
    }
    if (page < 0) {
        page = 0;
    }
    _bookModel.record.chapterModel = _bookModel.chapters[chapter];
    _bookModel.record.location = [_bookModel.record.chapterModel.pageLocations[page] integerValue];
    _bookModel.record.currentChapter = chapter;
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewDidUpdateReadRecord)]) {
        [self.rmDelegate readViewDidUpdateReadRecord];
    }
}


//MARK: - 关闭阅读器
- (void)closeReadView{
    
    //关闭前保存阅读记录
    [self.bookModel saveBook];
    
    //release memery 释放内存
    self.bookModel = nil;
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewDidClickCloseButton)]) {
        [self.rmDelegate readViewDidClickCloseButton];
    }
}

//MARK: - 添加或删除书签
- (void)addBookMark{
    XDSMarkModel *markModel = [[XDSMarkModel alloc] init];
    XDSChapterModel *currentChapterModel = _bookModel.record.chapterModel;
    NSInteger currentPage = _bookModel.record.currentPage;
    NSInteger currentChapter = _bookModel.record.currentChapter;
    markModel.date = [NSDate date];
    markModel.content = currentChapterModel.pageStrings[currentPage];
    markModel.chapter = currentChapter;
    markModel.locationInChapterContent = [currentChapterModel.pageLocations[currentPage] integerValue];
    [CURRENT_BOOK_MODEL addMark:markModel];
}

- (void)addNoteModel:(XDSNoteModel *)noteModel{
    noteModel.chapter = CURRENT_RECORD.currentChapter;
    [CURRENT_BOOK_MODEL addNote:noteModel];

//    //绘制笔记下划线
//    [CURRENT_BOOK_MODEL loadContentInChapter:_bookModel.record.chapterModel];

//    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewDidAddNoteSuccess)]) {
//        [self.rmDelegate readViewDidAddNoteSuccess];
//    }
}
@end
