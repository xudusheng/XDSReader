//
//  XDSCatalogueTabBarController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSCatalogueTabBarController.h"
#import "XDSCatalogueViewController.h"
#import "XDSNoteViewController.h"
#import "XDSMarkViewController.h"
#import "XDSReadViewConst.h"
@interface XDSCatalogueTabBarController ()
@property (strong, nonatomic) XDSCatalogueViewController *catalogueVC;
@property (strong, nonatomic) XDSNoteViewController *noteVC;
@property (strong, nonatomic) XDSMarkViewController *markVC;

@end

@implementation XDSCatalogueTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    _catalogueVC = [[XDSCatalogueViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _catalogueVC.title = @"目录";
    
    _noteVC = [[XDSNoteViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _noteVC.title = @"笔记";

    _markVC = [[XDSMarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
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
                                                            NSForegroundColorAttributeName:TEXT_COLOR_XDS_2
                                                            }
                                                 forState:UIControlStateSelected];
    }
}

- (void)setCvDelegate:(id<XDSCatalogueViewDelegate>)cvDelegate{
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
