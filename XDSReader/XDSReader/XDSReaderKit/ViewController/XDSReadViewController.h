//
//  XDSReadViewController.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSReadViewController : UIViewController

@property (nonatomic,strong) NSString *content; //显示的内容
@property (nonatomic,strong) id epubFrameRef;  //epub显示内容
@property (nonatomic,strong) NSArray *imageArray;  //epub显示的图片
@property (nonatomic,assign) XDSEBookType bookType;   //文本类型
@property (nonatomic,strong) XDSRecordModel *recordModel;   //阅读进度
@property (nonatomic,strong) XDSReadView *readView;
@property (nonatomic,weak) id<XDSReadViewControllerDelegate> rvdelegate;

@end
