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

@interface XDSWIFIFileTransferViewController () <GCDWebUploaderDelegate> {
@private
    GCDWebUploader *webServer;
}

@property (weak, nonatomic) IBOutlet UILabel *ipAndPortLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@property (assign, nonatomic)NSInteger fileCount;//文件数量  许杜生添加 2015.12.22
@property (assign, nonatomic)UInt64 contentLength;//文件内容大小  许杜生添加 2015.12.22
@property (assign, nonatomic)UInt64 downloadLength;//已下载的文件内容大小  许杜生添加 2015.12.22
@property (nonatomic,assign) BOOL isUploading;

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
    
    
    //如果输入IP以后无法连接到设备，则尝试调用一下网络请求，激活网络连接以后再尝试
    [self demoRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([webServer isRunning]) {
        [webServer stop];
    }
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
        self.progressView.progress = (double)self.downloadLength/self.contentLength;
        self.progressLabel.text = [NSString stringWithFormat:@"正在上传第%ld文件，进度%zd%%", (long)self.fileCount, (NSInteger)(self.progressView.progress * 100)];

    });
    
}
#pragma mark - UI相关
- (void)createXDSWIFIFileTransferViewControllerUI{
    _progressView.progress = 0.0;
    
    self.closeButton.layer.cornerRadius = 20.f;
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.closeButton.layer.borderWidth = 1.f;
    [self.closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    webServer = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    webServer.delegate = self;
    webServer.allowHiddenItems = YES;
    if ([webServer start]) {
        _ipAndPortLabel.text = [NSString stringWithFormat:NSLocalizedString(@"http://%@", nil), [XDSIPHelper deviceIPAdress]];
    } else {
        _ipAndPortLabel.text = NSLocalizedString(@"GCDWebServer not running!", nil);
    }
}

#pragma mark - 代理方法
- (void)webUploader:(GCDWebUploader *)uploader didUploadFileAtPath:(NSString *)path {
    _progressLabel.text = [NSString stringWithFormat:@"第%ld文件已上传完成", (long)_fileCount];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
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
