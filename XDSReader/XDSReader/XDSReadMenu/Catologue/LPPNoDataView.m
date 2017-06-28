//
//  LPPNoDataView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/23.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPNoDataView.h"

@implementation LPPNoDataView

+ (instancetype)newInstance{
    LPPNoDataView *noView = [[NSBundle mainBundle] loadNibNamed:@"LPPNoDataView" owner:nil options:nil].firstObject;
    return noView;
}

@end
