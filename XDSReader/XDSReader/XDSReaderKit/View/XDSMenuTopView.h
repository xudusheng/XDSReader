//
//  XDSMenuTopView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSMenuViewDelegate;

@interface XDSMenuTopView : UIView

@property (assign ,nonatomic) BOOL isMarkExist; //(0--未保存过，1-－保存过)
@property (weak, nonatomic) id<XDSMenuViewDelegate> mvdelegate;

@end

