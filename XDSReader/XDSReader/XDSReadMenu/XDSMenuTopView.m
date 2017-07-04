//
//  XDSMenuTopView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMenuTopView.h"

@interface XDSMenuTopView ()

@property (strong, nonatomic) UIButton *backButton;// 返回按钮
@property (strong, nonatomic) UIButton *markButton;// 书签

@end

@implementation XDSMenuTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self dataInit];
        [self createUI];
    }
    return self;
}

//MARK: -  override super method

//MARK: - ABOUT UI UI相关
- (void)createUI{
    CGFloat buttonW = 50;
    // 返回
    self.backButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, kStatusBarHeight, buttonW, CGRectGetHeight(self.frame) - kStatusBarHeight);
        [button setImage:[UIImage imageNamed:@"G_Back_0"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
    
    // 书签
    self.markButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(CGRectGetWidth(self.frame) - buttonW, kStatusBarHeight, buttonW, CGRectGetHeight(self.frame) - kStatusBarHeight);
        [button setImage:[UIImage imageNamed:@"RM_17"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"RM_18"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(markButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        button;
    });
}
//MARK: - DELEGATE METHODS 代理方法

//MARK: - ABOUT REQUEST 网络请求

//MARK: - ABOUT EVENTS 事件响应
- (void)closeButtonClick:(UIButton *)button{
    [[XDSReadManager sharedManager] closeReadView];
}
- (void)markButtonClick:(UIButton *)button{
    [[XDSReadManager sharedManager] addBookMark];
    [self updateMarkButtonState];
}
//MARK: - OTHER PRIVATE METHODS 私有方法
- (void)updateMarkButtonState{
    self.markButton.selected = [CURRENT_RECORD.chapterModel isMarkAtPage:CURRENT_RECORD.currentPage];
}
//MARK: - ABOUT MEMERY 内存管理
- (void)dataInit{
    
}

@end
