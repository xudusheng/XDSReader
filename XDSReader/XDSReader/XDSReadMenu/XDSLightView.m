
//
//  XDSLightView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSLightView.h"

@interface XDSLightView ()

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UISlider *slider;//进度条
@property (nonatomic, strong) UILabel *typeLabel;//类型

@end

@implementation XDSLightView

//MARK: -  override super method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self dataInit];
        [self createUI];
    }
    return self;
}



//MARK: - ABOUT UI UI相关
- (void)createUI{
    
    self.titleLabel = ({
        CGRect frame = CGRectMake(0, 0, 45, CGRectGetHeight(self.frame));
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = @"亮度";
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor whiteColor];
        label.font = FONT_SYSTEM_XDS_12;
        [self addSubview:label];
        label;
    });
    
    self.typeLabel = ({
        CGFloat typeLabelW = 32.f;
        CGFloat typeLabelH = 16.f;
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame) - typeLabelW - kSpace_xds_15,
                                  (CGRectGetHeight(self.frame) - typeLabelH)/2,
                                  typeLabelW,
                                  typeLabelH);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = @"系统";
        label.font = FONT_SYSTEM_XDS_10;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blueColor];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        label;
    });
    
    self.slider = ({
        // 进度条
        CGFloat sliderX = CGRectGetMaxX(_titleLabel.frame) + kSpace_xds_15;
        CGFloat sliderW = CGRectGetMinX(_typeLabel.frame) - kSpace_xds_15 - sliderX;
        CGRect frame = CGRectMake(sliderX, 0, sliderW, CGRectGetHeight(self.frame));
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        slider.tintColor = TEXT_COLOR_XDS_2;
        [slider setThumbImage:[UIImage imageNamed:@"RM_3"] forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        slider.value = [UIScreen mainScreen].brightness;
        [self addSubview:slider];
        slider;
    });
}
//MARK: - DELEGATE METHODS 代理方法

//MARK: - ABOUT REQUEST 网络请求

//MARK: - ABOUT EVENTS 事件响应
- (void)sliderValueChanged:(UISlider *)slider{
    [UIScreen mainScreen].brightness = slider.value;
}
//MARK: - OTHER PRIVATE METHODS 私有方法

//MARK: - ABOUT MEMERY 内存管理
- (void)dataInit{
    
}


@end
