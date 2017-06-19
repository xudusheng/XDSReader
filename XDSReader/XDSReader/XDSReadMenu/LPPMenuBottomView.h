//
//  LPPMenuBottomView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/18.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPReadRootView.h"

@protocol LPPMenuBottomViewDelegate;

@interface LPPMenuBottomView : LPPReadRootView
@property (weak, nonatomic) id <LPPMenuBottomViewDelegate> bvDelegate;

@end

@protocol LPPMenuBottomViewDelegate <NSObject>

- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedFuctionButton:(UIButton *)button;
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedPreviousButton:(UIButton *)previousButton;
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedNextButton:(UIButton *)nextButton;


@end
