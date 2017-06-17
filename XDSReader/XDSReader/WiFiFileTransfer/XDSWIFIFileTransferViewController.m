//
//  XDSWIFIFileTransferViewController.m
//  XDSPractice
//
//  Created by zhengda on 15/12/21.
//  Copyright © 2015年 zhengda. All rights reserved.
//

#import "XDSWIFIFileTransferViewController.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "MyHTTPConnection.h"
#import "XDSIPHelper.h"
@interface XDSWIFIFileTransferViewController (){
    HTTPServer *httpServer;
}

@property (weak, nonatomic) IBOutlet UILabel *ipAndPortLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@property (assign, nonatomic)NSInteger fileCount;//文件数量  许杜生添加 2015.12.22
@property (assign, nonatomic)UInt64 contentLength;//文件内容大小  许杜生添加 2015.12.22
@property (assign, nonatomic)UInt64 downloadLength;//已下载的文件内容大小  许杜生添加 2015.12.22
@property (copy, nonatomic)NSString *curentDownloadFileName;//正在下载的文件名称  许杜生添加 2016.06.25
@property (assign, nonatomic)UInt64 curentDownloadFileCount;//第几个文件正在被下载  许杜生添加 2016.06.25

//self.fileCount += 1;
//self.contentLength = contentLength;
//self.downloadLength = 0;
@end

@implementation XDSWIFIFileTransferViewController

+ (instancetype)newInstance{
    XDSWIFIFileTransferViewController *wifiVC = [[XDSWIFIFileTransferViewController alloc] initWithNibName:@"XDSWIFIFileTransferViewController" bundle:nil];
    return wifiVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self XDSWIFIFileTransferViewControllerDataInit];
    [self createXDSWIFIFileTransferViewControllerUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receiveANewFileNotification:)
                                                name:kGetContentLengthNotificationName
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receiveDownloadProcessBodyDataNotification:)
                                                name:kDownloadProcessBodyDataNotificationName
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(processStartOfPartWithHeaderNotification:)
                                                name:kGetProcessStartOfPartWithHeaderNotificationName
                                              object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([httpServer isRunning]) {
        [httpServer stop];
    }
}


- (void)receiveANewFileNotification:(NSNotification *)notification{
    NSLog(@"class = %@", notification.class);
    self.fileCount += 1;
    self.contentLength = [notification.object integerValue];
    self.downloadLength = 0;
}

- (void)receiveDownloadProcessBodyDataNotification:(NSNotification *)notification{
    self.downloadLength += [notification.object integerValue];
    // 主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        _progressView.progress = (double)_downloadLength/_contentLength;
        _progressLabel.text = [NSString stringWithFormat:@"正在下载第%zd文件：%@ %zd%%", _fileCount, _curentDownloadFileName, (NSInteger)(_progressView.progress * 100)];

    });
    
}
- (void)processStartOfPartWithHeaderNotification:(NSNotification *)notification{
    _curentDownloadFileName = notification.object;
    _curentDownloadFileCount += 1;
}
#pragma mark - UI相关
- (void)createXDSWIFIFileTransferViewControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];
    _progressView.progress = 0.0;
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    // webPath是server搜寻HTML等文件的路径
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    [httpServer setDocumentRoot:webPath];
    [httpServer setConnectionClass:[MyHTTPConnection class]];
    NSLog(@"connectionClass = %@", [httpServer connectionClass]);
    
    NSError *err;
    if ([httpServer start:&err]) {
        NSLog(@"IP %@",[XDSIPHelper deviceIPAdress]);
        NSLog(@"port %hu",[httpServer listeningPort]);
        _ipAndPortLabel.text = [NSString stringWithFormat:@"http://%@:%hu", [XDSIPHelper deviceIPAdress], [httpServer listeningPort]];
    }else{
        NSLog(@"%@",err);
    }

}

#pragma mark - 代理方法

#pragma mark - 网络请求

#pragma mark - 点击事件处理

#pragma mark - 其他私有方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"keyPath = %@", keyPath);
    NSLog(@"object = %@", object);
    NSLog(@"change = %@", change);
}
#pragma mark - 内存管理相关
- (void)XDSWIFIFileTransferViewControllerDataInit{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGetContentLengthNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDownloadProcessBodyDataNotificationName object:nil];
}

@end
