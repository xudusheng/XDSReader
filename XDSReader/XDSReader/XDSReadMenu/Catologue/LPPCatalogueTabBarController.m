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

@end

@implementation LPPCatalogueTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    LPPCatalogueViewController *catalogueVC = [[LPPCatalogueViewController alloc] initWithStyle:UITableViewStyleGrouped];
    catalogueVC.title = @"目录";
    
    LPPNoteViewController *noteVC = [[LPPNoteViewController alloc] initWithStyle:UITableViewStylePlain];
    noteVC.title = @"笔记";
    LPPMarkViewController *markVC = [[LPPMarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    markVC.title = @"书签";
    
    self.viewControllers = @[catalogueVC, noteVC, markVC];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
