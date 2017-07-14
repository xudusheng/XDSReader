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

+ (CGRect)readViewBounds {
    CGRect bounds = CGRectMake(0,
                             0,
                             DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight,
                             DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom);
    return bounds;
}
//MARK: - //获取对于章节页码的radViewController
- (LPPReadViewController *)readViewWithChapter:(NSInteger)chapter
                                          page:(NSInteger)page
                                       pageUrl:(NSString *)pageUrl{
    if (nil == _bookModel.record.chapterModel.chapterAttributeContent) {//如果阅读记录中的chapterModel没有内容，则先加载内容
        LPPChapterModel *currentChapterModel = _bookModel.chapters[CURRENT_RECORD.currentChapter];
        [CURRENT_BOOK_MODEL loadContentInChapter:currentChapterModel];        
        CURRENT_RECORD.chapterModel = currentChapterModel;
        page = CURRENT_RECORD.currentPage;
        [LPPBookModel updateLocalModel:_bookModel url:self.resourceURL];
    }
    
    LPPReadViewController *readView = [[LPPReadViewController alloc] init];
    readView.chapterNum = chapter;
    readView.pageNum = page;
    readView.pageUrl = pageUrl;
    return readView;
}

//MARK: - 跳转到指定章节（上一章，下一章，slider，目录）
- (void)readViewJumpToChapter:(NSInteger *)chapter page:(NSInteger *)page{
    if (_bookModel.record.currentChapter != *chapter) {
        //新的一章需要先更新字体以获取正确的章节数据x
        LPPChapterModel *chapterModel = _bookModel.chapters[*chapter];
        [chapterModel updateFontAndGetNewPageFromOldPage:page];
    }
    
    //跳转到指定章节
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewJumpToChapter:page:)]) {
        [self.rmDelegate readViewJumpToChapter:*chapter page:*page];
    }
    //更新阅读记录
    [self updateReadModelWithChapter:*chapter page:*page];
}
//MARK: - 跳转到指定笔记，因为是笔记是基于位置查找的，使用page查找可能出错
- (void)readViewJumpToNote:(XDSNoteModel *)note{
    if (_bookModel.record.currentChapter != note.chapter) {
        //新的一章需要先更新字体以获取正确的章节数据x
        LPPChapterModel *chapterModel = _bookModel.chapters[note.chapter];
        NSInteger page = 0;
        [chapterModel updateFontAndGetNewPageFromOldPage:&page];
    }
    
    [self updateReadModelWithChapter:note.chapter page:note.page];
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewJumpToChapter:page:)]) {
        [self.rmDelegate readViewJumpToChapter:note.chapter page:note.page];
    }
}

//MARK: - 跳转到指定书签，因为是书签是基于位置查找的，使用page查找可能出错
- (void)readViewJumpToMark:(XDSMarkModel *)mark{
    if (_bookModel.record.currentChapter != mark.chapter) {
        //新的一章需要先更新字体以获取正确的章节数据x
        LPPChapterModel *chapterModel = _bookModel.chapters[mark.chapter];
        NSInteger page = 0;
        [chapterModel updateFontAndGetNewPageFromOldPage:&page];
    }
    
    [self updateReadModelWithChapter:mark.chapter page:mark.page];
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewJumpToChapter:page:)]) {
        [self.rmDelegate readViewJumpToChapter:mark.chapter page:mark.page];
    }
}
//MARK: - 设置字体
- (void)configReadFontSize:(BOOL)plus{
    if (plus) {
        if (floor([XDSReadConfig shareInstance].fontSize) == floor(kXDSReadViewMaxFontSize)) {
            return;
        }
        [XDSReadConfig shareInstance].fontSize++;
    }else{
        if (floor([XDSReadConfig shareInstance].fontSize) == floor(kXDSReadViewMinFontSize)){
            return;
        }
        [XDSReadConfig shareInstance].fontSize--;
    }
    
    //更新字体，主要是更新pageArray，其他的不需要处理
    NSInteger page = 0;
    [_bookModel.record.chapterModel updateFontAndGetNewPageFromOldPage:&page];
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewFontDidChanged)]) {
        [self.rmDelegate readViewFontDidChanged];
    }
}

- (void)configReadFontName:(NSString *)fontName{
    [[XDSReadConfig shareInstance] setFontName:fontName];
    //优化，添加串行队列，遍历所有章节进行updateFont。如果目录需要显示页码。
    //更新字体信息并保存阅读记录
    NSInteger nonPage = 0;
    [_bookModel.record.chapterModel updateFontAndGetNewPageFromOldPage:&nonPage];
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewFontDidChanged)]) {
        [self.rmDelegate readViewFontDidChanged];
    }
}

- (void)configReadTheme:(UIColor *)theme{
    [XDSReadConfig shareInstance].theme = theme;
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
    [LPPBookModel updateLocalModel:_bookModel url:_resourceURL];
    
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewDidUpdateReadRecord)]) {
        [self.rmDelegate readViewDidUpdateReadRecord];
    }
}


//MARK: - 关闭阅读器
- (void)closeReadView{
    if (self.rmDelegate && [self.rmDelegate respondsToSelector:@selector(readViewDidClickCloseButton)]) {
        [self.rmDelegate readViewDidClickCloseButton];
    }
}

//MARK: - 添加或删除书签
- (void)addBookMark{
    XDSMarkModel *markModel = [[XDSMarkModel alloc] init];
    LPPChapterModel *currentChapterModel = _bookModel.record.chapterModel;
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
    [XDSReaderUtil showAlertWithTitle:nil message:@"保存笔记成功"];
}
@end
