//
//  LPPCatalogueView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/20.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPCatalogueView.h"
#import "LPPCatalogueTabBarController.h"


@interface LPPCatalogueView ()
@property (nonatomic, strong) LPPCatalogueTabBarController *tabbarVC;
@end
@implementation LPPCatalogueView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self dataInit];
        [self createUI];
    }
    return self;
}


//MARK: -  override super method

//MARK: - ABOUT UI UI相关
- (void)createUI{
    self.tabbarVC = [[LPPCatalogueTabBarController alloc] init];
    _tabbarVC.view.frame = self.bounds;
    [self addSubview:_tabbarVC.view];
}
//MARK: - DELEGATE METHODS 代理方法

//MARK: - ABOUT REQUEST 网络请求

//MARK: - ABOUT EVENTS 事件响应

//MARK: - OTHER PRIVATE METHODS 私有方法

//MARK: - ABOUT MEMERY 内存管理
- (void)dataInit{
    
}

@end
