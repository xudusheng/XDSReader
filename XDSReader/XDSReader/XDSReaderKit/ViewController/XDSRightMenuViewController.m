//
//  XDSRightMenuViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSRightMenuViewController.h"

@interface XDSRightMenuViewController ()

@property (nonatomic,copy) NSArray *titleArray;
@end

@implementation XDSRightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rightMenuViewControllerDataInit];
    [self createRightMenuViewControllerUI];
}


//MARK: - ABOUT UI
- (void)createRightMenuViewControllerUI{
    self.view.backgroundColor = [UIColor yellowColor];
}
//MARK: - DELEGATE METHODS

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
- (void)reload{
    NSLog(@"reload ==========");
}
//MARK: - OTHER PRIVATE METHODS

//MARK: - ABOUT MEMERY
- (void)rightMenuViewControllerDataInit{

}

@end
