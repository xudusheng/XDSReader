//
//  XDSMenuBottomView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/18.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMenuBottomView.h"
@interface XDSMenuBottomView ()

@property (strong, nonatomic) UIButton *previousChapter;// 上一章
@property (strong, nonatomic) UIButton *nextChapter;// 下一章
@property (strong, nonatomic) UISlider *slider;// 进度
@property (copy, nonatomic) NSArray *funcIcons;//// 功能按钮数组
@end

@implementation XDSMenuBottomView
- (void)layoutSubviews{
    [super layoutSubviews];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self dataInit];
        [self createUI];
    }
    return self;
}
//MARK: - ABOUT UI UI相关
- (void)createUI{
    
    // 上一章
    self.previousChapter = ({
        CGRect frame = CGRectMake(0, kSpace_xds_10, 55, 32);
        UIButton *previousChapter = [UIButton buttonWithType:UIButtonTypeCustom];
        previousChapter.frame = frame;
        previousChapter.showsTouchWhenHighlighted = YES;
        previousChapter.titleLabel.font = FONT_SYSTEM_XDS_12;
        previousChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [previousChapter setTitle:@"上一章" forState:UIControlStateNormal];
        [previousChapter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [previousChapter addTarget:self action:@selector(previousChapterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:previousChapter];
        previousChapter;
    });
    
    // 下一章
    self.nextChapter = ({
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(_previousChapter.frame),
                                  kSpace_xds_10,
                                  CGRectGetWidth(_previousChapter.frame),
                                  CGRectGetHeight(_previousChapter.frame));
        UIButton *nextChapter = [UIButton buttonWithType:UIButtonTypeCustom];
        nextChapter.frame = frame;
        nextChapter.showsTouchWhenHighlighted = YES;
        nextChapter.titleLabel.font = FONT_SYSTEM_XDS_12;
        nextChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [nextChapter setTitle:@"下一章" forState:UIControlStateNormal];
        [nextChapter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextChapter addTarget:self action:@selector(nextChapterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextChapter];
        nextChapter;
    });

    // 进度条
    self.slider = ({
        CGFloat sliderX = CGRectGetMaxX(_previousChapter.frame) + kSpace_xds_10;
        CGFloat sliderW = CGRectGetWidth(self.frame) - 2*sliderX;
        CGRect frame = CGRectMake(sliderX,
                                  kSpace_xds_10,
                                  sliderW,
                                  CGRectGetHeight(_previousChapter.frame));
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];;
        [slider setThumbImage:[UIImage imageNamed:@"RM_3"] forState:UIControlStateNormal];
        slider.minimumValue = 0;
        slider.maximumValue = 1;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:slider];
        slider;
    });
    
    
    // 创建按钮
    NSInteger count = _funcIcons.count;
    CGFloat buttonY = CGRectGetMaxY(_previousChapter.frame);
    CGFloat buttonH = CGRectGetHeight(self.frame) - buttonY;
    CGFloat buttonW = CGRectGetWidth(self.frame) / count;
    for (int i = 0; i < _funcIcons.count; i ++) {
        CGRect frame = CGRectMake(buttonW * i, buttonY, buttonW, buttonH);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.showsTouchWhenHighlighted = YES;
        [button setImage:[UIImage imageNamed:_funcIcons[i]] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }

}

- (void)setReadProgram:(CGFloat)program{
    if (_slider.state == UIControlStateNormal) {
        _slider.value = program;
    }
}
//MARK: - DELEGATE METHODS 代理方法

//MARK: - ABOUT REQUEST 网络请求

//MARK: - ABOUT EVENTS 事件响应
//上一章
- (void)previousChapterButtonClick:(UIButton *)button{
    if ([self.bvDelegate respondsToSelector:@selector(menuBottomView:didSelectedPreviousButton:)]) {
        [self.bvDelegate menuBottomView:self didSelectedPreviousButton:button];
    }
}
//下一章
- (void)nextChapterButtonClick:(UIButton *)button{
    if ([self.bvDelegate respondsToSelector:@selector(menuBottomView:didSelectedNextButton:)]) {
        [self.bvDelegate menuBottomView:self didSelectedNextButton:button];
    }
}
- (void)sliderValueChanged:(UISlider *)slider{
    if ([self.bvDelegate respondsToSelector:@selector(menuBottomView:didSelectedSliderValueChanged:)]) {
        [self.bvDelegate menuBottomView:self didSelectedSliderValueChanged:slider];
    }
}
//功能按钮
- (void)functionButtonClick:(UIButton *)button{
    if ([self.bvDelegate respondsToSelector:@selector(menuBottomView:didSelectedFuctionButton:)]) {
        [self.bvDelegate menuBottomView:self didSelectedFuctionButton:button];
    }
}
//MARK: - OTHER PRIVATE METHODS 私有方法

//MARK: - ABOUT MEMERY 内存管理
- (void)dataInit{
    self.funcIcons = @[@"read_bar_0",@"read_bar_1",@"read_bar_2"];
}


@end
