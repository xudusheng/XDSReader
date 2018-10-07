//
//  XDSHTMLReaderVC.m
//  XDSReader
//
//  Created by Hmily on 2018/10/7.
//  Copyright © 2018年 macos. All rights reserved.
//

#import "XDSHTMLReaderVC.h"


@interface XDSHTMLReaderVC ()<UIScrollViewDelegate>

@end

@implementation XDSHTMLReaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.alwaysShowToolbar = YES;
    // HTML Content to set in the editor
    NSString *html = @"<h1>BAT把持的小程序战场，今日头条入局还有想象空间吗？</h1>"
    "<p>今年是小程序的混战之年，继微信、支付宝和百度之后，今日头条成为第四家提供小程序入口的APP，于9月17日进行内测，正在努力追赶小程序爆发年的末班车。今日头条是目前BAT以外掌握流量和数据规模最大的平台，发展势头越来越猛，有望成为继BAT之后的第四极，与BAT共享小程序的硕果。对此，今日头条的未来可谓是喜忧参半。<br/><strong>流量优势之下，头条小程序有足够的想象空间</strong>.</p>";

    [self setHTML:html];

    return;

    //    self.view.backgroundColor = [UIColor whiteColor];
//    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 200, 44)];
//    textfield.placeholder = @"xxxx";
//    textfield.inputView = [[UIView alloc]initWithFrame:CGRectZero];;
//    [self.view addSubview:textfield];
//

    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [webView loadRequest:request];
    
}

@end
