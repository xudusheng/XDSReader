//
//  LPPCatalogueViewController.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPReadViewConst.h"

@interface LPPCatalogueViewController : UITableViewController

@property (weak, nonatomic) id<LPPCatalogueViewDelegate>cvDelegate;

@end
