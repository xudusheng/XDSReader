# XDSReader
XDSReader是一个支持epub与txt格式的电子书阅读器，支持目录、添加笔记、添加书签、字体切换、章节切换等功能。其中epub目前仅支持显示查看文本与图片。  

```objective-c 
	使用方法：  
	1、将工程中的XDSReaderKit与XDSReadMenu两个文件夹add到工程中；  
	2、由于需要xml解析，需要添加相应的库支持  

	添加libz.tbd
 	other link flag 添加  -lxml2
 	Header Search Paths 添加  usr/include/libxml2
 	
 	//.pch文件中
 	//工程中引用第三方库ZipArchive进行文件解压，其中包含c代码，
 	//需要在.pch文件添加一句话#ifdef __OBJC__ #endif，
 	//然后将所有#import<>/#import ""都要放置到这句话的中间
 	#ifdef __OBJC__
		#import <UIKit/UIKit.h>
		#import <Foundation/Foundation.h>
		#import "XDSReaderHeader.h"
	#endif
```	

XDSReader已经将Menu的UI显示与逻辑进行了剥离，使用时可以根据业务需要自行定义UI界面。  

```objective-c  
	//获取对于章节页码的radViewController，并为其设置代理对象
	- (XDSReadViewController *)readViewWithChapter:(NSInteger *)chapter
                                          page:(NSInteger *)page
                                      delegate:(id<XDSReadViewControllerDelegate>)rvDelegate;

	- (void)readViewJumpToChapter:(NSInteger *)chapter page:(NSInteger *)page;//跳转到指定章节（上一章，下一章，slider，目录）
	- (void)readViewJumpToNote:(XDSNoteModel *)note;//跳转到指定笔记，因为是笔记是基于位置查找的，使用page查找可能出错
	- (void)readViewJumpToMark:(XDSMarkModel *)mark;//跳转到指定书签，因为是书签是基于位置查找的，使用page查找可能出错
	- (void)configReadFontSize:(BOOL)plus;//设置字体大小;
	- (void)configReadFontName:(NSString *)fontName;//设置字体;
	- (void)configReadTheme:(UIColor *)theme;//设置阅读背景
	- (void)updateReadModelWithChapter:(NSInteger)chapter page:(NSInteger)page;//更新阅读记录
	- (void)closeReadView;//关闭阅读器
	- (void)addBookMark;//添加或删除书签
	- (void)addNoteModel:(XDSNoteModel *)noteModel;//添加笔记
```