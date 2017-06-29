//
//  XDSMenuBottomView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/18.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSReadRootView.h"

@protocol XDSMenuBottomViewDelegate;

@interface XDSMenuBottomView : XDSReadRootView

@property (weak, nonatomic) id <XDSMenuBottomViewDelegate> bvDelegate;

- (void)setReadProgram:(CGFloat)program;

@end

@protocol XDSMenuBottomViewDelegate <NSObject>

- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedFuctionButton:(UIButton *)button;
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedPreviousButton:(UIButton *)previousButton;
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedNextButton:(UIButton *)nextButton;
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedSliderValueChanged:(UISlider *)slider;


@end
