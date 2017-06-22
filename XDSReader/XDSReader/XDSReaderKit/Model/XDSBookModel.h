//
//  XDSBookModel.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSBookModel : NSObject <NSCoding>
@property (nonatomic,strong) NSURL *resource;//资源路径
@property (nonatomic,copy) NSString *content;//电子书文本内容
@property (nonatomic,assign) XDSEBookType bookType;//电子书类型（txt, epub）
@property (nonatomic,strong) NSMutableArray <XDSMarkModel *>*marks;//书签，用于目录展示
@property (nonatomic,strong) NSMutableArray <XDSNoteModel *>*notes;//笔记不分组
@property (nonatomic,readonly) NSArray <XDSNoteModel *>*notesDevideByChapter;//笔记按章节分组
@property (nonatomic,strong) NSMutableArray <XDSChapterModel *>*chapters;//章节
@property (nonatomic,strong) NSMutableDictionary *marksRecord;//保存书签的字典，用于标记书签位置
@property (nonatomic,strong) XDSRecordModel *record;//阅读进度

- (instancetype)initWithContent:(NSString *)content;
- (instancetype)initWithePub:(NSString *)ePubPath;
+ (void)updateLocalModel:(XDSBookModel *)bookModel url:(NSURL *)url;
+ (id)getLocalModelWithURL:(NSURL *)url;


- (void)addNote:(XDSNoteModel *)noteModel;
@end
