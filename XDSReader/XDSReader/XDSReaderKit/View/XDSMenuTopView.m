//
//  XDSMenuTopView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMenuTopView.h"

@interface XDSMenuTopView ()

@property (nonatomic,strong) UIButton *back;
@property (nonatomic,strong) UIButton *more;

@end

@implementation XDSMenuTopView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self addSubview:self.back];
    [self addSubview:self.more];
}
-(void)setState:(BOOL)state{
    _isMarkExist = state;
    if (state) {
        [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        return;
    }
    [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
}
-(UIButton *)back{
    if (!_back) {
        _back = [XDSReaderUtil commonButtonSEL:@selector(backView) target:self];
        [_back setImage:[UIImage imageNamed:@"bg_back_white"] forState:UIControlStateNormal];
    }
    return _back;
}
-(UIButton *)more{
    if (!_more) {
        _more = [XDSReaderUtil commonButtonSEL:@selector(moreOption) target:self];
        [_more setImage:[[UIImage imageNamed:@"sale_discount_yellow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
        [_more setImageEdgeInsets:UIEdgeInsetsMake(7.5, 12.5, 7.5, 12.5)];
    }
    return _more;
}
-(void)moreOption{
    if ([self.mvdelegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.mvdelegate menuViewMark:self];
    }
}
-(void)backView{
    [[UIViewController xds_visiableViewController] dismissViewControllerAnimated:YES completion:nil];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _back.frame = CGRectMake(0, 24, 40, 40);
    _more.frame = CGRectMake(CGRectGetWidth(self.frame)-50, 24, 40, 40);
}

@end
