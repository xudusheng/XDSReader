# XDSReader
XDSReader是一个支持epub与txt格式的电子书阅读器，支持目录、添加笔记、添加书签、字体切换、章节切换等功能。epub目前仅支持显示查看文本与图片，后续将继续添加标注、图片点击、笔记点击等功能。

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
##### 1、关闭阅读器
```objective-c
    [[XDSReadManager sharedManager] closeReadView];
```
##### 2、更换主题
```objective-c
UIColor *theme = [UIColor whiteColor];
    [[XDSReadManager sharedManager] configReadTheme:theme];
```

##### 3、设置字体
```objective-c
NSString *fontName = @"STXingkai";
[[XDSReadManager sharedManager] configReadFontName: fontName];
```
##### 4、字号变化	
```objective-c
BOOL plusSize = YES;
[[XDSReadManager sharedManager] configReadFontSize:plusSize];
```
##### 5、更新阅读记录
```objective-c
_chapter = 10;
_page = 2;
[[XDSReadManager sharedManager] updateReadModelWithChapter:_chapter page:_page];
```

##### 6、添加或删除书签
```objective-c
//如果书签存在则删除，不存在则添加
[[XDSReadManager sharedManager] addBookMark];
self.markButton.selected = [CURRENT_RECORD.chapterModel isMarkAtPage:CURRENT_RECORD.currentPage];
```

##### 7、添加笔记（这一部分基本上与menu的UI关系不大，可以不管）
```objective-c
XDSNoteModel *model = [[XDSNoteModel alloc] init];
model.content = [_content substringWithRange:_selectRange];
model.note = alertController.textFields.firstObject.text;
model.date = [NSDate date];
XDSChapterModel *chapterModel = CURRENT_RECORD.chapterModel;
model.locationInChapterContent = _selectRange.location + [chapterModel.pageArray[CURRENT_RECORD.currentPage] integerValue];
[[XDSReadManager sharedManager] addNoteModel:model];
```
##### 8、跳转到指定章节
```objective-c	
    NSInteger selectedChapter = [CURRENT_BOOK_MODEL.chapters indexOfObject:chapterModel];
    NSInteger page = 0;
    [[XDSReadManager sharedManager] readViewJumpToChapter:&selectedChapter page:&page];   
```
##### 9跳转到指定笔记位置
```objective-c
[[XDSReadManager sharedManager] readViewJumpToNote:noteModel];

```

#####	10、跳转到指定书签位置
```objective-c
[[XDSReadManager sharedManager] readViewJumpToMark:markModel];
```

##### 11、目录、笔记、书签列表的数据源（DataSource）  
```objective-c
@interface XDSBookModel : NSObject <NSCoding>
	@property (nonatomic,strong) NSMutableArray <XDSChapterModel *>*chapters;//全部章节
	@property (nonatomic,readonly) NSArray <XDSChapterModel*> *chapterContainNotes;//包含笔记的章节
	@property (nonatomic,readonly) NSArray <XDSChapterModel *>*chapterContainMarks;//包含书签的章节
@end

@interface XDSChapterModel : NSObject<NSCopying,NSCoding>
	@property (nonatomic,copy) NSArray<XDSNoteModel *>*notes;
	@property (nonatomic,copy) NSArray<XDSMarkModel *>*marks;
@end
```