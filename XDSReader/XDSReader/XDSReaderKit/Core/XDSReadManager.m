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


//MARK: - //获取对于章节页码的radViewController，并为其设置代理对象
- (XDSReadViewController *)readViewWithChapter:(NSInteger *)chapter page:(NSInteger *)page delegate:(id<XDSReadViewControllerDelegate>)rvDelegate{
    
    NSInteger selectedChapter = *chapter;
    if (_bookModel.record.currentChapter != selectedChapter) {
        //新的一章需要先更新字体以获取正确的章节数据
        [_bookModel.chapters[selectedChapter] updateFontAndGetNewPageFromOldPage:page];
        if (_bookModel.bookType == XDSEBookTypeEpub) {
            [self readChapterContent:selectedChapter];
        }
    }

    NSInteger selectedPage = *page;
    XDSReadViewController *readView = [[XDSReadViewController alloc] init];
    readView.recordModel = _bookModel.record;
    if (_bookModel.bookType == XDSEBookTypeEpub) {
        readView.bookType = XDSEBookTypeEpub;
        [self readChapterContent:selectedChapter];
        readView.epubFrameRef = _bookModel.chapters[selectedChapter].epubframeRef[selectedPage];
        readView.imageArray = _bookModel.chapters[selectedChapter].imageArray;
        readView.content = _bookModel.chapters[selectedChapter].content;
    }else{
        readView.bookType = XDSEBookTypeTxt;
        readView.content = [_bookModel.chapters[selectedChapter] stringOfPage:selectedPage];
    }
    readView.rvdelegate = rvDelegate;
    return readView;
}

- (void)readChapterContent:(NSInteger)chapter{
    XDSChapterModel *chapterModel = _bookModel.chapters[chapter];
    if (!chapterModel.epubframeRef) {
        
        NSString *chapterFullPath = [APP_SANDBOX_DOCUMENT_PATH stringByAppendingString:chapterModel.chapterpath];
        NSURL *fileURL = [NSURL fileURLWithPath:chapterFullPath];
        NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:fileURL] encoding:NSUTF8StringEncoding];
        
        chapterModel.content = [html stringByConvertingHTMLToPlainText];
        [chapterModel parserEpubToDictionary];

    }else{
        CGRect rect = CGRectMake(0,
                                 0,
                                 DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight,
                                 DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom);
        [chapterModel paginateEpubWithBounds:rect];
    }
}


//MARK: - 跳转到指定章节（上一章，下一章，slider，目录）
- (void)readViewJumpToChapter:(NSInteger *)chapter page:(NSInteger *)page{
    if (_bookModel.record.currentChapter != *chapter) {
        //新的一章需要先更新字体以获取正确的章节数据x
        XDSChapterModel *chapterModel = _bookModel.chapters[*chapter];
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
        XDSChapterModel *chapterModel = _bookModel.chapters[note.chapter];
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
        XDSChapterModel *chapterModel = _bookModel.chapters[mark.chapter];
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
    

    NSInteger page =
    (_bookModel.record.currentPage>_bookModel.record.chapterModel.pageCount-1)?
    _bookModel.record.chapterModel.pageCount-1:
    _bookModel.record.currentPage;
    
    //优化，添加串行队列，遍历所有章节进行updateFont。如果目录需要显示页码。
    //更新字体信息并保存阅读记录
    [_bookModel.record.chapterModel updateFontAndGetNewPageFromOldPage:&page];
    [self updateReadModelWithChapter:_bookModel.record.currentChapter page:page];
    
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
    _bookModel.record.location = [_bookModel.record.chapterModel.pageArray[page] integerValue];
    _bookModel.record.currentChapter = chapter;
    [XDSBookModel updateLocalModel:_bookModel url:_resourceURL];
    
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
    XDSChapterModel *currentChapterModel = _bookModel.record.chapterModel;
    NSInteger currentPage = _bookModel.record.currentPage;
    NSInteger currentChapter = _bookModel.record.currentChapter;
    markModel.date = [NSDate date];
    markModel.content = [currentChapterModel stringOfPage:currentPage];
    markModel.chapter = currentChapter;
    markModel.locationInChapterContent = [currentChapterModel.pageArray[currentPage] integerValue];
    [CURRENT_BOOK_MODEL addMark:markModel];
}

- (void)addNoteModel:(XDSNoteModel *)noteModel{
    noteModel.chapter = CURRENT_RECORD.currentChapter;
    [CURRENT_BOOK_MODEL addNote:noteModel];
    [XDSReaderUtil showAlertWithTitle:nil message:@"保存笔记成功"];
}
@end
