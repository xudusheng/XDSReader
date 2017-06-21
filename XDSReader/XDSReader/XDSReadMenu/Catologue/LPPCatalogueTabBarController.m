//
//  LPPCatalogueTabBarController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPCatalogueTabBarController.h"
#import "LPPCatalogueViewController.h"
#import "LPPNoteViewController.h"
#import "LPPMarkViewController.h"
#import "LPPReadViewConst.h"
@interface LPPCatalogueTabBarController ()
@property (strong, nonatomic) LPPCatalogueViewController *catalogueVC;
@property (strong, nonatomic) LPPNoteViewController *noteVC;
@property (strong, nonatomic) LPPMarkViewController *markVC;

@end

@implementation LPPCatalogueTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    _catalogueVC = [[LPPCatalogueViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _catalogueVC.title = @"目录";
    
    _noteVC = [[LPPNoteViewController alloc] initWithStyle:UITableViewStylePlain];
    _noteVC.title = @"笔记";

    _markVC = [[LPPMarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _markVC.title = @"书签";
    
    self.viewControllers = @[_catalogueVC, _noteVC, _markVC];
    self.tabBar.translucent = NO;
    [self.tabBar setBarTintColor:READ_BACKGROUND_COLOC];
    for (UITabBarItem *item in self.tabBar.items) {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -13)];
        [item setTitleTextAttributes:@{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                                            }
                                                 forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{
                                                            NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                            NSForegroundColorAttributeName:TEXT_COLOR_LPP_2
                                                            }
                                                 forState:UIControlStateSelected];
    }
}

- (void)setCvDelegate:(id<LPPCatalogueViewDelegate>)cvDelegate{
    _cvDelegate = cvDelegate;
    _catalogueVC.cvDelegate = _cvDelegate;
    _noteVC.cvDelegate = _cvDelegate;
    _markVC.cvDelegate = _cvDelegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
