//
//  XDSReadMenuBottomView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/17.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadMenuBottomView.h"

@interface XDSReadMenuBottomView ()

/// 上一章
@property (strong, nonatomic) UIButton *previousChapter;

/// 下一章
@property (strong, nonatomic) UIButton *nextChapter;

/// 进度
@property (strong, nonatomic) UISlider *slider;

/// 功能按钮数组
@property (copy, nonatomic) NSArray *funcIcons;
//private(set) var funcIcons:[String] = ["read_bar_0","read_bar_1","read_bar_2","read_bar_3"]

@end


@implementation XDSReadMenuBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createButtomViewUI];
    }
    return self;
}

- (void)createButtomViewUI{
    self.funcIcons = @[@"read_bar_0",@"read_bar_1",@"read_bar_2",@"read_bar_3"];
    
    // 创建按钮
    for (int i = 0; i < self.funcIcons.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:self.funcIcons[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(funcButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

}


- (void)layoutSubviews{
    
}

//TODO: funcButtonClick
- (void)funcButtonClick:(UIButton *)funcButton{
    NSInteger index = funcButton.tag;
    
    if (index == 0) { // 目录
        
    }else if (index == 1) { // 亮度
        
    }else if (index == 2) { // 设置
        
    }else{ // 下载
        
    }
}
@end
