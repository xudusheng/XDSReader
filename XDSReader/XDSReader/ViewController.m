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
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"zoubianzhongguo"withExtension:@"epub"];
        [self showReadPageViewControllerWithFileURL:fileURL];
    }else if(indexPath.row == 1){
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"妖神记"withExtension:@"txt"];
        [self showReadPageViewControllerWithFileURL:fileURL];
    }else if(indexPath.row == 2){
        XDSWIFIFileTransferViewController *wifiTransferVC = [XDSWIFIFileTransferViewController newInstance];
        [self.navigationController pushViewController:wifiTransferVC animated:YES];
        
//        XDSDemoViewController *demoVC = [[XDSDemoViewController alloc] init];
//        [self.navigationController presentViewController:demoVC animated:YES completion:nil];
//        [self.navigationController pushViewController:demoVC animated:YES];
        
//        LPPReadPageViewController *readPageVC = [[LPPReadPageViewController alloc] init];
//        [self presentViewController:readPageVC animated:YES completion:nil];

//        NSString *path = [[NSBundle mainBundle] pathForResource:@"XDSShareConfig.plist" ofType:nil];
//        NSArray *array = [NSArray arrayWithContentsOfFile:path];
//        
//        NSURL *url = [NSURL URLWithString:@"reader://share/home"];
//        
//        for (NSDictionary *dict in array) {
//            if ([dict[@"exact_url"] isEqualToString:url.absoluteString]) {
//                NSString *object = dict[@"object"];
//                if ([object hasPrefix:@"#"]) {
//                    object = [object substringFromIndex:1];
//                    Class class = NSClassFromString(object);
//                    if (class) {
//                        UIViewController *controller = [[class alloc] init];
//                        [controller.view setValue:[UIColor redColor] forKey:@"backgroundColor"];
//                        [controller setValuesForKeysWithDictionary:@{}];
//                        [self.navigationController pushViewController:controller animated:YES];
////                        [self presentViewController:controller animated:YES completion:nil];
//                    }
//                    break;
//                }
//            }
//        }
        

        
//        NSLog(@"url = %@", url);
        
    }
}

- (void)showReadPageViewControllerWithFileURL:(NSURL *)fileURL{
    if (nil == fileURL) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LPPBookModel *bookModel = [LPPBookModel getLocalModelWithURL:fileURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            LPPReadPageViewController *pageView = [[LPPReadPageViewController alloc] init];
            [[XDSReadManager sharedManager] setResourceURL:fileURL];//文件位置
            [[XDSReadManager sharedManager] setBookModel:bookModel];
            [[XDSReadManager sharedManager] setRmDelegate:pageView];
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}

@end
