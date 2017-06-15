//
//  XDSNoteModel.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDSNoteModel : NSObject<NSCoding>

@property (nonatomic,strong) NSDate *date;//添加笔记的日期
@property (nonatomic,copy) NSString *note;//笔记
@property (nonatomic,copy) NSString *content;//笔记部分的文字内容
@property (nonatomic,strong) XDSRecordModel *recordModel;//笔记所在的位置

@end
