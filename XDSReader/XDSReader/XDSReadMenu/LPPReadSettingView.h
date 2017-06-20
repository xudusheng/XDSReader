//
//  LPPReadSettingView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPReadRootView.h"

@protocol LPPReadSettingViewDelegatge;
@interface LPPReadSettingView : LPPReadRootView
@property (weak, nonatomic) id <LPPReadSettingViewDelegatge> svDelegate;

- (void)startHaloAnimate;//开启光环动画

@end

@protocol LPPReadSettingViewDelegatge <NSObject>

- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedTheme:(UIColor *)theme;
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedEffect:(UIColor *)effect;
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedFont:(NSString *)font;
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedFontSize:(BOOL)plusSize;

@end
