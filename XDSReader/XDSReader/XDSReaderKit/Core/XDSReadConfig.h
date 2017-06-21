//
//  XDSReadConfig.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XDSReadConfig : NSObject <NSCoding>

@property (nonatomic) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *theme;

+ (instancetype)shareInstance;


@end
