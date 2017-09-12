//
//  XDSReaderGlobleConst.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const kReadViewMarginTop;
UIKIT_EXTERN CGFloat const kReadViewMarginBottom;
UIKIT_EXTERN CGFloat const kReadViewMarginLeft;
UIKIT_EXTERN CGFloat const kReadViewMarginRight;


#define DEVICE_MAIN_SCREEN_WIDTH_XDSR [UIScreen mainScreen].bounds.size.width
#define DEVICE_MAIN_SCREEN_HEIGHT_XDSR [UIScreen mainScreen].bounds.size.height

#define DISTANCE_FROM_TOP_GUIDEN(__view__)  (__view__.frame.origin.y + __view__.frame.size.height)
#define DISTANCE_FROM_LEFT_GUIDEN(__view__) (__view__.frame.origin.x + __view__.frame.size.width)

#define RGB(__R__, __G__, __B__) [UIColor colorWithRed:(__R__)/255.0 green:(__G__)/255.0 blue:(__B__)/255.0 alpha:1.0]

#define SELECTED_AREA_DOC_COLOR RGB(0,0,255)
#define SELECTED_AREA_BACKGROUND_COLOR [UIColor colorWithRed:0 green:0 blue:1 alpha:0.2]

//沙盒document路径
#define APP_SANDBOX_DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

//epub文件所在文件夹名称
#define EPUB_FOLDER @"epub/"
//epub解压包所在文件夹名称
#define EPUB_EXTRACTION_FOLDER @"epubExtraction/"


UIKIT_EXTERN CGFloat const kXDSReadViewMinFontSize;
UIKIT_EXTERN CGFloat const kXDSReadViewMaxFontSize;
UIKIT_EXTERN CGFloat const kXDSReadViewDefaultFontSize;
