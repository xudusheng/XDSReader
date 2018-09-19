//
//  XDSPhotoBrowser.m
//  XDSReader
//
//  Created by Hmily on 2017/9/2.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSPhotoBrowser.h"

@interface XDSPhotoBrowser ()

@end

@implementation XDSPhotoBrowser

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)viewDidLoad {
    [super viewDidLoad];

//UIBarButtonItem *closeItem = [UIBarButtonItem alloc] initWithImage:[] style:(UIBarButtonItemStyle) target:<#(nullable id)#> action:<#(nullable SEL)#>
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeButtonClick:)];
    self.navigationItem.rightBarButtonItem = closeItem;
}

- (void)closeButtonClick:(UIBarButtonItem *)buttonItem {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
