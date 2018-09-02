//
//  XDSReaderWebViewController.m
//  XDSReader
//
//  Created by Hmily on 2017/9/9.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReaderWebViewController.h"

@interface XDSReaderWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XDSReaderWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"chapter12.html" ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
