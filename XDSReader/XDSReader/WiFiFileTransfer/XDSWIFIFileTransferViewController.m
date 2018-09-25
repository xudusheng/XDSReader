//
//  XDSWIFIFileTransferViewController.m
//  XDSPractice
//
//  Created by zhengda on 15/12/21.
//  Copyright © 2015年 zhengda. All rights reserved.
//

#import "XDSWIFIFileTransferViewController.h"
#import "XDSIPHelper.h"

#import "GCDWebUploader.h"
#import "XDSReaderWifiView.h"

#define XDS_WIFI_VIEW_HEIGHT 370.f
#define XDS_WIFI_VIEW_SHOW_ORIGINY (DEVICE_MAIN_SCREEN_HEIGHT_XDSR - XDS_WIFI_VIEW_HEIGHT)
#define XDS_WIFI_VIEW_HIDDEN_ORIGINY DEVICE_MAIN_SCREEN_HEIGHT_XDSR

@interface XDSWIFIFileTransferViewController () <GCDWebUploaderDelegate> {
@private
    GCDWebUploader *webServer;
}

@property (nonatomic,strong) XDSReaderWifiView *wifiView;
@property (assign, nonatomic)NSInteger fileCount;//文件数量  许杜生添加 2015.12.22
@property (assign, nonatomic)UInt64 contentLength;//文件内容大小  许杜生添加 2015.12.22
@property (assign, nonatomic)UInt64 downloadLength;//已下载的文件内容大小  许杜生添加 2015.12.22
@property (nonatomic,assign) BOOL isUploading;

@end

@implementation XDSWIFIFileTransferViewController

+ (instancetype)newInstance{
    XDSWIFIFileTransferViewController *wifiVC = [[XDSWIFIFileTransferViewController alloc] init];
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
    
    
    //如果输入IP以后无法连接到设备，则尝试调用一下网络请求，激活网络连接以后再尝试
    [self demoRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startAnimation:YES];
}

- (void)receiveANewFileNotification:(NSNotification *)notification{
    self.fileCount += 1;
    self.contentLength = [notification.object integerValue];
    self.downloadLength = 0;
    self.isUploading = YES;
}

- (void)receiveDownloadProcessBodyDataNotification:(NSNotification *)notification{
    if (!self.isUploading) {
        return;
    }
    self.downloadLength += [notification.object integerValue];
    // 主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        self.wifiView.progressView.progress = (double)self.downloadLength/self.contentLength;
        self.wifiView.progressLabel.text = [NSString stringWithFormat:@"正在上传第%ld文件，进度%zd%%", (long)self.fileCount, (NSInteger)(self.wifiView.progressView.progress * 100)];
    });
    
}
#pragma mark - UI相关
- (void)createXDSWIFIFileTransferViewControllerUI{
    self.wifiView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XDSReaderWifiView class]) owner:self options:nil].firstObject;
    self.wifiView.frame = CGRectMake(0, XDS_WIFI_VIEW_HIDDEN_ORIGINY, DEVICE_MAIN_SCREEN_WIDTH_XDSR, XDS_WIFI_VIEW_HEIGHT);
    [self.view addSubview:self.wifiView];
    
    self.wifiView.progressView.progress = 0.0;
    [self.wifiView.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    webServer.delegate = self;
    webServer.allowHiddenItems = YES;
    if ([webServer start]) {
        self.wifiView.ipAndPortLabel.text = [NSString stringWithFormat:NSLocalizedString(@"http://%@", nil), [XDSIPHelper deviceIPAdress]];
        self.wifiView.wifiNameLabel.text = [NSString stringWithFormat:@"已连接WiFi：%@", [XDSIPHelper getWifiName]];
    } else {
        self.wifiView.ipAndPortLabel.text = @"";
    }
}

#pragma mark - 代理方法
- (void)webUploader:(GCDWebUploader *)uploader didUploadFileAtPath:(NSString *)path {
    self.wifiView.progressLabel.text = [NSString stringWithFormat:@"第%ld文件已上传完成", (long)_fileCount];
    self.isUploading = NO;
}
#pragma mark - 网络请求

-(void)demoRequest{
    //访问百度首页
    
    //1. 创建一个网络请求
    NSURL *url = [NSURL URLWithString:@"http://m.baidu.com"];
    
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"网络响应：response：%@",response);
    }];
    
    //5.执行任务
    [dataTask resume];
}
#pragma mark - 点击事件处理
- (void)closeButtonClick:(UIButton *)closeButton {
    if ([webServer isRunning]) {
        [webServer stop];
    }
    
    [self startAnimation:NO];
}
#pragma mark - 其他私有方法

- (void)startAnimation:(BOOL)isViewAppear{
    CGFloat originY = isViewAppear?XDS_WIFI_VIEW_SHOW_ORIGINY:XDS_WIFI_VIEW_HIDDEN_ORIGINY;
    CGRect frame = self.wifiView.frame;
    frame.origin.y = originY;
    [UIView animateWithDuration:0.25 animations:^{
        self.wifiView.frame = frame;
    } completion:^(BOOL finished) {
        if (!isViewAppear) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }];
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
