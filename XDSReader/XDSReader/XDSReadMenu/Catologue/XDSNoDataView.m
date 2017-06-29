//
//  XDSNoDataView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/23.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSNoDataView.h"

@implementation XDSNoDataView

+ (instancetype)newInstance{
    XDSNoDataView *noView = [[NSBundle mainBundle] loadNibNamed:@"XDSNoDataView" owner:nil options:nil].firstObject;
    return noView;
}

@end
