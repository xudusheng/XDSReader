//
//  ViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMainReaderVC.h"
#import "XDSBookCell.h"
#import "XDSWIFIFileTransferViewController.h"
@interface XDSMainReaderVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray<LPPBookInfoModel*> * bookList;
@property (strong, nonatomic) UICollectionView * mCollectionView;

@end

@implementation XDSMainReaderVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self movieListViewControllerDataInit];
    [self createBookListViewControllerUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadLocalBooks];
    
}

#pragma mark - UI相关
- (void)createBookListViewControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    //    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    CGFloat itemMargin = 20;
    CGFloat width = (DEVICE_MAIN_SCREEN_WIDTH_XDSR - itemMargin * 4)/3-0.1;
    layout.itemSize = CGSizeMake(width, width*12/9 + 45);
    layout.sectionInset = UIEdgeInsetsMake(itemMargin, itemMargin, itemMargin, itemMargin);
    //创建collectionView 通过一个布局策略layout来创建
    self.mCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _mCollectionView.backgroundColor = [UIColor whiteColor];
    //代理设置
    _mCollectionView.delegate=self;
    _mCollectionView.dataSource=self;
    //注册item类型 这里使用系统的类型
    [self.view addSubview:_mCollectionView];
    
    [_mCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDSBookCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDSBookCell class])];
    _mCollectionView.frame = self.view.bounds;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加书籍" style:UIBarButtonItemStyleDone target:self action:@selector(showWifiView)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

#pragma mark - 网络请求


#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _bookList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XDSBookCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDSBookCell class]) forIndexPath:indexPath];
    
    LPPBookInfoModel *bookInfoModel = self.bookList[indexPath.row];
    UIImage *cover = [UIImage imageWithContentsOfFile:bookInfoModel.coverPath];
    cell.mImageView.image = cover;
    
    cell.mTitleLabel.text = bookInfoModel.title;
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LPPBookInfoModel *bookInfoModel = self.bookList[indexPath.row];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        XDSBookModel *bookModel = [XDSBookModel bookModelWithBaseInfo:bookInfoModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            XDSReadPageViewController *pageView = [[XDSReadPageViewController alloc] init];
            [[XDSReadManager sharedManager] setBookModel:bookModel];
            [[XDSReadManager sharedManager] setRmDelegate:pageView];
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}
#pragma mark - 点击事件处理
- (void)showReadPageViewControllerWithFileURL:(NSURL *)fileURL{
    if (nil == fileURL) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LPPBookInfoModel *bookInfo = [XDSReadOperation getBookInfoWithFile:fileURL];
        XDSBookModel *bookModel = [XDSBookModel bookModelWithBaseInfo:bookInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            XDSReadPageViewController *pageView = [[XDSReadPageViewController alloc] init];
            [[XDSReadManager sharedManager] setBookModel:bookModel];
            [[XDSReadManager sharedManager] setRmDelegate:pageView];
            [self presentViewController:pageView animated:YES completion:nil];
        });
    });
}

- (void)showWifiView {
    XDSWIFIFileTransferViewController *wifiTransferVC = [XDSWIFIFileTransferViewController newInstance];
    [self presentViewController:wifiTransferVC
                       animated: YES
              inRransparentForm:YES
                     completion:nil];
}

#pragma mark - 其他私有方法
- (void)loadLocalBooks {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = documentPaths.firstObject;
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    NSLog(@"%@", fileList);
    [self.bookList removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *fileName in fileList) {
            NSString *path = [NSString stringWithFormat:@"%@/%@", documentDir, fileName];
            LPPBookInfoModel *bookInfo = [XDSReadOperation getBookInfoWithFile:[NSURL fileURLWithPath:path]];
            bookInfo?[self.bookList addObject:bookInfo]:NULL;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mCollectionView reloadData];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mCollectionView reloadData];
        });
    });
    
    //本地文件
    fileList = @[@"不懂这些英文你就OUT了(正版).epub", @"Android从入门到精通.epub", @"三人成狼.txt", @"特种神医.txt"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *fileName in fileList) {
            
            //注意，url初始化方法与从documents读取文件的url初始化方法的区别
            NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
            
            LPPBookInfoModel *bookInfo = [XDSReadOperation getBookInfoWithFile:fileURL];
            bookInfo?[self.bookList addObject:bookInfo]:NULL;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mCollectionView reloadData];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mCollectionView reloadData];
        });
    });
    
}

#pragma mark - 内存管理相关
- (void)movieListViewControllerDataInit{
    self.bookList = [[NSMutableArray alloc] initWithCapacity:0];
}
@end
