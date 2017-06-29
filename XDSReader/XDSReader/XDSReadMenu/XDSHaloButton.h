//
//  XDSHaloButton.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSHaloButton : UIControl

@property (strong, nonatomic) UIImageView *imageView;// imageView
@property (strong, nonatomic) UIColor *haloColor;// 光晕颜色
@property (strong, nonatomic) UIImage *nomalImage;// 默认图片
@property (strong, nonatomic) UIImage *selectImage;// 选中图片

- (instancetype)initWithFrame:(CGRect)frame haloColor:(UIColor *)haloColor;

- (void)openHalo;
- (void)closeHalo;

@end
