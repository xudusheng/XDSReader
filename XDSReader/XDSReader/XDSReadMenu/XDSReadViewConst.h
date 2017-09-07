//
//  XDSReadViewConst.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/19.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEVICE_MAIN_SCREEN_WIDTH_XDSR [UIScreen mainScreen].bounds.size.width
#define DEVICE_MAIN_SCREEN_HEIGHT_XDSR [UIScreen mainScreen].bounds.size.height

// MARK: -- 间距支持
UIKIT_EXTERN CGFloat const kSpace_xds_15;
UIKIT_EXTERN CGFloat const kSpace_xds_25;
UIKIT_EXTERN CGFloat const kSpace_xds_1;
UIKIT_EXTERN CGFloat const kSpace_xds_10;
UIKIT_EXTERN CGFloat const kSpace_xds_20;
UIKIT_EXTERN CGFloat const kSpace_xds_5;

UIKIT_EXTERN CGFloat const kNavgationBarHeight;// 导航栏高度
UIKIT_EXTERN CGFloat const kTabBarHeight;// TabBar高度
UIKIT_EXTERN CGFloat const kStatusBarHeight;// StatusBar高度

// MARK: -- 字体支持
#define FONT_SYSTEM_XDS_10 [UIFont systemFontOfSize:10]
#define FONT_SYSTEM_XDS_12 [UIFont systemFontOfSize:12]
#define FONT_SYSTEM_XDS_18 [UIFont systemFontOfSize:12]

//MARK: -- 颜色支持
#define TEXT_COLOR_XDS_1 RGB_XDS(51, 51, 51)/// 灰色
#define TEXT_COLOR_XDS_2 RGB_XDS(253, 85, 103)/// 粉红色
#define TEXT_COLOR_XDS_3 RGB_XDS(127, 136, 138)/// 阅读上下状态栏颜色
#define TEXT_COLOR_XDS_4 RGB_XDS(127, 136, 138)// 小说阅读上下状态栏字体颜色
#define TEXT_COLOR_XDS_5 RGB_XDS(145, 145, 145)/// 小说阅读颜色
#define TEXT_COLOR_XDS_6 RGB_XDS(200, 200, 200)/// LeftView文字颜色



//MARK: -- 阅读背景颜色支持
#define RGB_XDS(__R__, __G__, __B__) [UIColor colorWithRed:(__R__)/255.0 green:(__G__)/255.0 blue:(__B__)/255.0 alpha:1.0]
#define READ_BACKGROUND_COLOC_1 RGB_XDS(238, 224, 202)
#define READ_BACKGROUND_COLOC_2 RGB_XDS(205, 239, 205)
#define READ_BACKGROUND_COLOC_3 RGB_XDS(206, 233, 241)
#define READ_BACKGROUND_COLOC_4 RGB_XDS(251, 237, 199)// 牛皮黄
#define READ_BACKGROUND_COLOC_5 RGB_XDS(51, 51, 51)

//MARK: -- 菜单背景颜色
#define READ_BACKGROUND_COLOC [[UIColor blackColor] colorWithAlphaComponent:0.85f]


//MARK: -- 尺寸计算 以iPhone6为比例
#define SIZE_WIDHT_XDS(__size__) __size__ * (DEVICE_MAIN_SCREEN_WIDTH_XDSR / 375)
#define SIZE_HEIGHT_XDS(__size__) __size__ * (DEVICE_MAIN_SCREEN_HEIGHT_XDSR / 667)


@protocol XDSCatalogueViewDelegate <NSObject>
- (void)catalogueViewDidSelecteCatalogue:(XDSCatalogueModel *)catalogueModel ;
- (void)catalogueViewDidSelectedNote:(XDSNoteModel *)NodeModel;
- (void)catalogueViewDidSelectedMark:(XDSMarkModel *)markModel;
@end




