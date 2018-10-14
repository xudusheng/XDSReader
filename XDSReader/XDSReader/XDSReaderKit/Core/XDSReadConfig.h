//
//  XDSReadConfig.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XDSReadThemeType) {
    XDSReadThemeTypeNone = 0,//无效果，白间模式
    
    XDSReadThemeTypeBlack,//夜间模式
    
    
};

@interface XDSReadConfig : NSObject <NSCoding, NSCopying>

@property (nonatomic, readonly) CGFloat cachefontSize;
@property (nonatomic, readonly) NSString *cacheFontName;
@property (nonatomic, readonly) CGFloat cacheLineSpace;
@property (nonatomic, readonly) UIColor *cacheTextColor;
@property (nonatomic, readonly) UIColor *cacheTheme;


//用与更新全部章节内容。当字体，字号，主题变化时，仅更新record章节内容而非全部章节
@property (nonatomic, assign) CGFloat currentFontSize;
@property (nonatomic, copy) NSString *currentFontName;
@property (nonatomic) CGFloat currentLineSpace;
@property (nonatomic,strong) UIColor *currentTextColor;
@property (nonatomic,strong) UIColor *currentTheme;

+ (instancetype)shareInstance;

- (BOOL)isReadConfigChanged;//if config changed, we need to load content for all chapters, and reset cache config。

@end
