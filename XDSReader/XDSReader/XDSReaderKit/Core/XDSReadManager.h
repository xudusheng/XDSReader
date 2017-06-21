//
//  XDSReadManager.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURRENT_BOOK_MODEL [XDSReadManager sharedManager].bookModel
#define CURRENT_RECORD [XDSReadManager sharedManager].bookModel.record

@protocol XDSReadManagerDelegate;

@interface XDSReadManager : NSObject
+ (XDSReadManager *)sharedManager;

@property (nonatomic,strong) NSURL *resourceURL;
@property (nonatomic,strong) XDSBookModel *bookModel;
@property (nonatomic,weak) id<XDSReadManagerDelegate> rmDelegate;

//获取对于章节页码的radViewController，并为其设置代理对象
- (XDSReadViewController *)readViewWithChapter:(NSUInteger)chapter
                                          page:(NSUInteger)page
                                      delegate:(id<XDSReadViewControllerDelegate>)rvDelegate;

- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page;//跳转到指定章节（上一章，下一章，slider，目录）
- (void)configReadFontSize:(BOOL)plus;//设置字体大小;
- (void)configReadFontName:(NSString *)fontName;//设置字体;
- (void)configReadTheme:(UIColor *)theme;//设置阅读背景
- (void)updateReadModelWithChapter:(NSInteger)chapter page:(NSInteger)page;//更新阅读记录
- (void)closeReadView;//关闭阅读器
- (BOOL)addBookMark;//添加或删除书签，返回添加结果
- (void)addNoteModel:(XDSNoteModel *)noteModel;//添加笔记

@end


@protocol XDSReadManagerDelegate <NSObject>
- (void)readViewDidClickCloseButton;//点击关闭按钮
- (void)readViewFontDidChanged;//字体改变
- (void)readViewThemeDidChanged;//主题改变
- (void)readViewEffectDidChanged;//翻页效果改变
- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page;//跳转到章节
- (void)readViewDidUpdateReadRecord;//更新阅读进度

@end
