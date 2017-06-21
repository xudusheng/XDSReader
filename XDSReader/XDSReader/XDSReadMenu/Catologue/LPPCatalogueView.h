//
//  LPPCatalogueView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPReadRootView.h"

@interface LPPCatalogueView : LPPReadRootView

@property (weak, nonatomic) id<LPPCatalogueViewDelegate>cvDelegate;

@end
