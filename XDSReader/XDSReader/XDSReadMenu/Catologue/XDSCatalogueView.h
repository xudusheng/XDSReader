//
//  XDSCatalogueView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadRootView.h"

@interface XDSCatalogueView : XDSReadRootView

@property (weak, nonatomic) id<XDSCatalogueViewDelegate>cvDelegate;

@end
