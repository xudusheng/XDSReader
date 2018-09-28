//
//  XDSReadPageViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 11/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "XDSReadPageViewController.h"
#import "XDSReadMenu.h"
@interface XDSReadPageViewController ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate,
XDSReadManagerDelegate
>
{
    NSInteger _chapter;    //当前显示的章节
    NSInteger _page;       //当前显示的页数
    NSInteger _chapterChange;  //将要变化的章节
    NSInteger _pageChange;     //将要变化的页数
    
    UIStatusBarStyle lastStatusBarStyle;
    
    BOOL _isAnnimationFinished;//动画是否结束
}

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) XDSReadMenu *readMenuView;//菜单

@end

@implementation XDSReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readPageViewControllerDataInit];
    [self createReadPageViewControllerUI];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _pageViewController.view.frame = self.view.frame;
}

//MARK: - ABOUT UI
- (void)createReadPageViewControllerUI{
    [self addChildViewController:self.pageViewController];
    
    self->lastStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
    
    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:&_chapter
                                                                                   page:&_page
                                                                                pageUrl:nil];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    

}

#pragma mark - init
-(UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
//        _pageViewController.doubleSided = YES;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

//MARK: - DELEGATE METHODS
//TODO: XDSReadManagerDelegate
- (void)readViewDidClickCloseButton{
    [[UIApplication sharedApplication] setStatusBarStyle:self->lastStatusBarStyle];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)readViewFontDidChanged {
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:&_chapter
                                                                                   page:&_page
                                                                                pageUrl:nil];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}
- (void)readViewThemeDidChanged{
    XDSReadViewController *readView = _pageViewController.viewControllers.firstObject;
    UIColor *theme = [XDSReadConfig shareInstance].currentTheme?[XDSReadConfig shareInstance].currentTheme:[XDSReadConfig shareInstance].cacheTheme;
    readView.view.backgroundColor = theme;
    readView.readView.backgroundColor = theme;
}
- (void)readViewEffectDidChanged{}
- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page{
    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:&chapter
                                                                                   page:&page
                                                                                pageUrl:nil];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}
- (void)readViewDidUpdateReadRecord{
    [self.readMenuView updateReadRecord];
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
}

- (void)readViewDidAddNoteSuccess {
    [XDSReaderUtil showAlertWithTitle:nil message:@"保存笔记成功"];
    [self readViewFontDidChanged];
}

//TODO: UIGestureRecognizerDelegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[DTAttributedTextContentView class]] ||
        [touch.view isKindOfClass:[DTAttributedTextView class]] ||
        [touch.view isKindOfClass:[XDSReadView class]]) {
        return YES;
    }
    return  NO;
}

//TODO: UIPageViewControllerDelegate, UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController{

    NSLog(@"444444444444444444444===%zd count", pageViewController.viewControllers.count);
    if (!_isAnnimationFinished) {
        return nil;
    }
    _pageChange = _page;
    _chapterChange = _chapter;
    
    if (_chapterChange + _pageChange == 0) {
        [self showToolMenu];//已经是第一页了，显示菜单准备返回
        return nil;
    }
    
    
    if (_pageChange == 0) {
        _chapterChange--;
    }
    _pageChange--;
    
    _isAnnimationFinished = NO;
    return [[XDSReadManager sharedManager] readViewWithChapter:&_chapterChange
                                                          page:&_pageChange
                                                       pageUrl:nil];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController{
    NSLog(@"333333333333333333333333===%zd count", pageViewController.viewControllers.count);
    if (!_isAnnimationFinished) {
        return nil;
    }
    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == CURRENT_BOOK_MODEL.chapters.lastObject.pageCount-1 && _chapterChange == CURRENT_BOOK_MODEL.chapters.count-1) {
        //最后一页，这里可以处理一下，添加已读完页面。
        [self showToolMenu];//已经是最后一页了，显示菜单准备返回
        return nil;
    }
    if (_pageChange == CURRENT_RECORD.totalPage-1) {
        _chapterChange++;
        _pageChange = 0;
    }else{
        _pageChange++;
    }
    
    _isAnnimationFinished = NO;
    return [[XDSReadManager sharedManager] readViewWithChapter:&_chapterChange
                                                          page:&_pageChange
                                                       pageUrl:nil];
}

#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSLog(@"22222222222222222222222222");

    _chapter = _chapterChange;
    _page = _pageChange;
}
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    NSLog(@"1111111111111111111 == %ld == %ld", finished, completed);
    _isAnnimationFinished = finished;
    if (!completed) {
        XDSReadViewController *readView = previousViewControllers.firstObject;
        _page = readView.pageNum;
        _chapter = readView.chapterNum;
    }
    else{
        _chapter = _chapterChange;
        _page = _pageChange;
        [[XDSReadManager sharedManager] updateReadModelWithChapter:_chapter page:_page];
    }
}
//MARK: - ABOUT REQUEST
//MARK: - ABOUT EVENTS
-(void)showToolMenu{
    XDSReadViewController *readView = _pageViewController.viewControllers.firstObject;
    [readView.readView cancelSelected];
    [self.view addSubview:self.readMenuView];
}
//MARK: - OTHER PRIVATE METHODS
- (XDSReadMenu *)readMenuView{
    if (nil == _readMenuView) {
        _readMenuView = [[XDSReadMenu alloc] initWithFrame:self.view.bounds];
        _readMenuView.backgroundColor = [UIColor clearColor];
    }
    return _readMenuView;
}
//MARK: - ABOUT MEMERY
- (void)readPageViewControllerDataInit{
    _isAnnimationFinished = YES;
}


@end
