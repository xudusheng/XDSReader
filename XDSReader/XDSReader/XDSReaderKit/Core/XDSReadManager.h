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
- (void)configReadFontSize:(BOOL)plus;//设置字体;
- (void)configReadTheme:(UIColor *)theme;//设置阅读背景
- (void)updateReadModelWithChapter:(NSInteger)chapter page:(NSInteger)page;//更新阅读记录
- (void)closeReadView;//关闭阅读器
- (BOOL)addBookMark;//添加或删除书签，返回添加结果

@end


@protocol XDSReadManagerDelegate <NSObject>
- (void)readViewDidClickCloseButton;
- (void)readViewFontDidChanged;
- (void)readViewFontSizeDidChanged;
- (void)readViewThemeDidChanged;
- (void)readViewEffectDidChanged;
- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page;


@end
