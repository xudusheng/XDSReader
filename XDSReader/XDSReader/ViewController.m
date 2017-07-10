//
//  ViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "ViewController.h"

#import "XDSWIFIFileTransferViewController.h"
#import "XDSReadManager.h"
#import "XDSDemoViewController.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"走遍中国珍藏版(图说天下·国家地理系列)"withExtension:@"epub"];
        [self showReadPageViewControllerWithFileURL:fileURL];
    }else if(indexPath.row == 1){
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
        [self showReadPageViewControllerWithFileURL:fileURL];
    }else if(indexPath.row == 2){
//        XDSWIFIFileTransferViewController *wifiTransferVC = [XDSWIFIFileTransferViewController newInstance];
//        [self.navigationController pushViewController:wifiTransferVC animated:YES];
        
        XDSDemoViewController *demoVC = [[XDSDemoViewController alloc] init];
        [self.navigationController presentViewController:demoVC animated:YES completion:nil];
//        [self.navigationController pushViewController:demoVC animated:YES];
    }
}

- (void)showReadPageViewControllerWithFileURL:(NSURL *)fileURL{
    if (nil == fileURL) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        XDSBookModel *bookModel = [XDSBookModel getLocalModelWithURL:fileURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            XDSReadPageViewController *pageView = [[XDSReadPageViewController alloc] init];
            [[XDSReadManager sharedManager] setResourceURL:fileURL];//文件位置
            [[XDSReadManager sharedManager] setBookModel:bookModel];
            [[XDSReadManager sharedManager] setRmDelegate:pageView];
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}

@end
