//
//  XDSHaloButton.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSHaloButton.h"
#import "XDSReadViewConst.h"
#import "UIView+YGPulseView.h"
@interface XDSHaloButton ()


@end
@implementation XDSHaloButton


- (instancetype)initWithFrame:(CGRect)frame haloColor:(UIColor *)haloColor{
    if (self = [super initWithFrame:frame]) {
        self.haloColor = haloColor;
        [self createHaloView];
        // 开启光晕
        [self openHalo];
    }
    return self;
}


- (void)createHaloView{
    self.imageView = ({
        CGRect frame = CGRectMake(kSpace_xds_10,
                                  kSpace_xds_10,
                                  CGRectGetWidth(self.frame) - kSpace_xds_20,
                                  CGRectGetHeight(self.frame) - kSpace_xds_20);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        // 圆角
        imageView.layer.cornerRadius = (CGRectGetWidth(self.frame) - kSpace_xds_20) / 2;
        [self addSubview:imageView];
        imageView;
    });
}


- (void)openHalo{
    if (self.haloColor) {
        // 开启按钮闪动
        [self.imageView startPulseWithColor:self.haloColor
                                  scaleFrom:1.0
                                         to:1.2
                                  frequency:1.0
                                    opacity:0.5
                                  animation:YGPulseViewAnimationTypeRegularPulsing];
    }
}

- (void)closeHalo{
    [self.imageView stopPulse];
}

- (void)setSelected:(BOOL)selected{
    if (selected) {
        if (self.selectImage) {
            self.imageView.image = self.selectImage;
        }else{
            self.imageView.layer.borderColor = TEXT_COLOR_XDS_2.CGColor;
            self.imageView.layer.borderWidth = 2.0;
        }
    }else{
        if (self.nomalImage) {
            self.imageView.image = self.nomalImage;
        }else{
            self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
            self.imageView.layer.borderWidth = 2.0;
        }
    }
}

@end
