//
//  ViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "ViewController.h"

#import "XDSWIFIFileTransferViewController.h"

#import "LPPReadMenu.h"
@interface ViewController ()

@property (strong, nonatomic) LPPReadMenu *readMenuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"每天懂一点好玩心理学"withExtension:@"epub"];
        [self showReadPageViewControllerWithFileURL:fileURL];
    }else if(indexPath.row == 1){
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml"withExtension:@"txt"];
        [self showReadPageViewControllerWithFileURL:fileURL];
    }else if(indexPath.row == 2){
//        XDSWIFIFileTransferViewController *wifiTransferVC = [XDSWIFIFileTransferViewController newInstance];
//        [self.navigationController pushViewController:wifiTransferVC animated:YES];
        
        [self.view addSubview:self.readMenuView];
        
    }
}

- (void)showReadPageViewControllerWithFileURL:(NSURL *)fileURL{
    if (nil == fileURL) {
        return;
    }
    
    XDSReadPageViewController *pageView = [[XDSReadPageViewController alloc] init];
    pageView.resourceURL = fileURL;    //文件位置
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        pageView.bookModel = [XDSBookModel getLocalModelWithURL:fileURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}



- (LPPReadMenu *)readMenuView{
    if (nil == _readMenuView) {
        _readMenuView = [[LPPReadMenu alloc] initWithFrame:self.view.bounds];
        _readMenuView.backgroundColor = [UIColor redColor];
    }
    return _readMenuView;
}
@end
