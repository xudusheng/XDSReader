//
//  XDSMenuView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSMenuViewDelegate;

@interface XDSMenuView : UIView
@property (nonatomic,weak) id<XDSMenuViewDelegate> mvDelegate;
@property (nonatomic,strong) XDSRecordModel *recordModel;
@property (nonatomic,strong) XDSMenuTopView *menuTopView;
@property (nonatomic,strong) XDSMenuBottomView *menuBottomView;
-(void)showAnimation:(BOOL)animation;
-(void)hiddenAnimation:(BOOL)animation;

@end
