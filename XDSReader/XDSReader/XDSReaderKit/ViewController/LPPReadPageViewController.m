//
//  LPPReadPageViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 11/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "LPPReadPageViewController.h"
#import "XDSReadMenu.h"
@interface LPPReadPageViewController ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate
>
{
    NSInteger _chapter;    //当前显示的章节
    NSInteger _page;       //当前显示的页数
    NSInteger _chapterChange;  //将要变化的章节
    NSInteger _pageChange;     //将要变化的页数
}

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) XDSReadMenu *readMenuView;//菜单

@end

@implementation LPPReadPageViewController

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
    
    LPPReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:CURRENT_RECORD.currentChapter
                                                                                   page:CURRENT_RECORD.currentPage
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
    
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
}

#pragma mark - init
-(UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

//MARK: - DELEGATE METHODS
//TODO: XDSReadManagerDelegate
- (void)readViewDidClickCloseButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)readViewFontDidChanged {
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
    LPPReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:_chapter
                                                                                   page:_page
                                                                                pageUrl:nil];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}
- (void)readViewThemeDidChanged{
    LPPReadViewController *readView = _pageViewController.viewControllers.firstObject;
    UIColor *theme = [XDSReadConfig shareInstance].currentTheme?[XDSReadConfig shareInstance].currentTheme:[XDSReadConfig shareInstance].cacheTheme;
    readView.view.backgroundColor = theme;
}
- (void)readViewEffectDidChanged{}
- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page{
    LPPReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:chapter
                                                                                   page:page
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

//TODO: UIGestureRecognizerDelegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:NSStringFromClass([DTAttributedTextContentView class])]) {
        return YES;
    }
    return  NO;
}

//TODO: UIPageViewControllerDelegate, UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController{
    _pageChange = _page;
    _chapterChange = _chapter;
    
    if (_chapterChange + _pageChange == 0) {
        [self showToolMenu];//已经是第一页了，显示菜单准备返回
        return nil;
    }
    if (_pageChange == 0) {
        _chapterChange--;
        LPPChapterModel *chapter = CURRENT_BOOK_MODEL.chapters[_chapterChange];
        _pageChange = chapter.pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [[XDSReadManager sharedManager] readViewWithChapter:_chapterChange
                                                          page:_pageChange
                                                       pageUrl:nil];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController{
    
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
    return [[XDSReadManager sharedManager] readViewWithChapter:_chapterChange
                                                          page:_pageChange
                                                       pageUrl:nil];
}

#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    _chapter = _chapterChange;
    _page = _pageChange;
}
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    if (!completed) {
        LPPReadViewController *readView = previousViewControllers.firstObject;
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
    LPPReadViewController *readView = _pageViewController.viewControllers.firstObject;
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
- (void)readPageViewControllerDataInit{}


@end
