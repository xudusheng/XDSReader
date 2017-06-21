//
//  LPPReadViewConst.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEVICE_MAIN_SCREEN_WIDTH_LPPR [UIScreen mainScreen].bounds.size.width
#define DEVICE_MAIN_SCREEN_HEIGHT_LPPR [UIScreen mainScreen].bounds.size.height

// MARK: -- 字体支持
#define FONT_SYSTEM_LPP_10 [UIFont systemFontOfSize:10]
#define FONT_SYSTEM_LPP_12 [UIFont systemFontOfSize:12]
#define FONT_SYSTEM_LPP_18 [UIFont systemFontOfSize:12]

//MARK: -- 颜色支持
#define TEXT_COLOR_LPP_1 RGB_LPP(51, 51, 51)/// 灰色
#define TEXT_COLOR_LPP_2 RGB_LPP(253, 85, 103)/// 粉红色
#define TEXT_COLOR_LPP_3 RGB_LPP(127, 136, 138)/// 阅读上下状态栏颜色
#define TEXT_COLOR_LPP_4 RGB_LPP(127, 136, 138)// 小说阅读上下状态栏字体颜色
#define TEXT_COLOR_LPP_5 RGB_LPP(145, 145, 145)/// 小说阅读颜色
#define TEXT_COLOR_LPP_6 RGB_LPP(200, 200, 200)/// LeftView文字颜色



//MARK: -- 阅读背景颜色支持
#define RGB_LPP(__R__, __G__, __B__) [UIColor colorWithRed:(__R__)/255.0 green:(__G__)/255.0 blue:(__B__)/255.0 alpha:1.0]
#define READ_BACKGROUND_COLOC_1 RGB_LPP(238, 224, 202)
#define READ_BACKGROUND_COLOC_2 RGB_LPP(205, 239, 205)
#define READ_BACKGROUND_COLOC_3 RGB_LPP(206, 233, 241)
#define READ_BACKGROUND_COLOC_4 RGB_LPP(251, 237, 199)// 牛皮黄
#define READ_BACKGROUND_COLOC_5 RGB_LPP(51, 51, 51)

//MARK: -- 菜单背景颜色
#define READ_BACKGROUND_COLOC [[UIColor blackColor] colorWithAlphaComponent:0.85f]


// MARK: -- 间距支持
#define kSpace_lpp_15 15
#define kSpace_lpp_25 25
#define kSpace_lpp_1 1
#define kSpace_lpp_10 10
#define kSpace_lpp_20 20
#define kSpace_lpp_5 5

#define kNavgationBarHeight 64.f// 导航栏高度
#define kTabBarHeight 49.f// TabBar高度
#define kStatusBarHeight 20.f// StatusBar高度

//MARK: -- 尺寸计算 以iPhone6为比例
#define SIZE_WIDHT_LPP(__size__) __size__ * (DEVICE_MAIN_SCREEN_WIDTH_LPPR / 375)
#define SIZE_HEIGHT_LPP(__size__) __size__ * (DEVICE_MAIN_SCREEN_HEIGHT_LPPR / 667)


@protocol LPPCatalogueViewDelegate <NSObject>
- (void)catalogueViewDidSelectedChapter:(XDSChapterModel *)chapterModel;
- (void)catalogueViewDidSelectedNote:(XDSNoteModel *)NodeModel;
- (void)catalogueViewDidSelectedMark:(XDSMarkModel *)markModel;
@end




