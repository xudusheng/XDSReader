//
//  XDSReadSettingView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSReadRootView.h"

@protocol XDSReadSettingViewDelegatge;
@interface XDSReadSettingView : XDSReadRootView
@property (weak, nonatomic) id <XDSReadSettingViewDelegatge> svDelegate;

- (void)startHaloAnimate;//开启光环动画

@end

@protocol XDSReadSettingViewDelegatge <NSObject>

- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedTheme:(UIColor *)theme;
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedEffect:(UIColor *)effect;
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedFont:(NSString *)font;
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedFontSize:(BOOL)plusSize;

@end
