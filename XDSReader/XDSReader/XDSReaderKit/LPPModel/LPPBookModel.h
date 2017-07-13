//
//  LPPBookModel.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LPPBookInfoModel : NSObject

@end

@interface LPPBookModel : NSObject <NSCoding>
@property (nonatomic,strong) NSURL *resource;//资源路径
@property (nonatomic, strong) LPPBookInfoModel *bookInfo;//书籍基本信息
@property (nonatomic,copy) NSString *content;//电子书文本内容
@property (nonatomic,assign) LPPEBookType bookType;//电子书类型（txt, epub）
@property (nonatomic,readonly) NSArray <LPPChapterModel*> *chapters;//章节
@property (nonatomic,readonly) NSArray <LPPChapterModel*> *chapterContainNotes;//包含笔记的章节
@property (nonatomic,readonly) NSArray <LPPChapterModel*> *chapterContainMarks;//包含书签的章节

@property (nonatomic,strong) LPPRecordModel *record;//阅读进度

- (instancetype)initWithContent:(NSString *)content;
- (instancetype)initWithePub:(NSString *)ePubPath;
+ (void)updateLocalModel:(LPPBookModel *)bookModel url:(NSURL *)url;
+ (id)getLocalModelWithURL:(NSURL *)url;


- (void)deleteNote:(XDSNoteModel *)noteModel;
- (void)addNote:(XDSNoteModel *)noteModel;

- (void)deleteMark:(XDSMarkModel *)markModel;
- (void)addMark:(XDSMarkModel *)markModel;
@end
