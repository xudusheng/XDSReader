//
//  XDSNoteViewController.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSReadViewConst.h"

@interface XDSNoteViewController : UITableViewController

@property (weak, nonatomic) id<XDSCatalogueViewDelegate>cvDelegate;

@end
