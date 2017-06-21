//
//  XDSReadPageViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadPageViewController.h"

#import "XDSRightMenuViewController.h"
#import "XDSReadViewController.h"
#import "UIImage+ImageEffects.h"

#import "LPPReadMenu.h"
@interface XDSReadPageViewController ()
<UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate,
XDSReadViewControllerDelegate>
{
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isPaging;//是否正在翻页
}

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (strong, nonatomic) LPPReadMenu *readMenuView;//菜单

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
    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:CURRENT_RECORD.currentChapter
                                                                                  page:CURRENT_RECORD.currentPage
                                                                               delegate:self];
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
    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:CURRENT_RECORD.currentChapter
                                                                                   page:CURRENT_RECORD.currentPage
                                                                               delegate:self];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}
- (void)readViewThemeDidChanged{
    XDSReadViewController *readView = _pageViewController.viewControllers.firstObject;
    readView.view.backgroundColor = [XDSReadConfig shareInstance].theme;
}
- (void)readViewEffectDidChanged{}
- (void)readViewJumpToChapter:(NSInteger)chapter page:(NSInteger)page{
    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:chapter
                                                                                   page:page
                                                                               delegate:self];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
}
- (void)readViewDidUpdateReadRecord{
    [self.readMenuView updateReadRecord];
}

//TODO: XDSReadViewControllerDelegate
- (void)readViewEditeding:(XDSReadViewController *)readViewController{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
- (void)readViewEndEdit:(XDSReadViewController *)readViewController{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}


//TODO: UIGestureRecognizerDelegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:NSStringFromClass([XDSReadView class])]) {
        return YES;
    }
    return  NO;
}

//TODO: UIPageViewControllerDelegate, UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
               viewControllerBeforeViewController:(UIViewController *)viewController{
    if (_isPaging) {
        return nil;
    }
    _isPaging = YES;

    _pageChange = CURRENT_RECORD.currentPage;
    _chapterChange = CURRENT_RECORD.currentChapter;
    
    if (_chapterChange + _pageChange == 0) {
        _isPaging = NO;
        return nil;
    }
    
    if (_pageChange == 0) {
        _chapterChange -= 1;
        _pageChange = CURRENT_BOOK_MODEL.chapters[_chapterChange].pageCount-1;
    }else{
        _chapterChange -= 1;
    }
    return [[XDSReadManager sharedManager] readViewWithChapter:_chapterChange
                                                          page:_pageChange
                                                      delegate:self];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController
                viewControllerAfterViewController:(UIViewController *)viewController{
    if (_isPaging) {
        return nil;
    }
    _isPaging = YES;
    _pageChange = CURRENT_RECORD.currentPage;
    _chapterChange = CURRENT_RECORD.currentChapter;
    
    if (_pageChange == CURRENT_BOOK_MODEL.chapters.lastObject.pageCount-1 && _chapterChange == CURRENT_BOOK_MODEL.chapters.count-1) {
        _isPaging = NO;
        return nil;
    }
    
    if (_pageChange == CURRENT_RECORD.chapterModel.pageCount-1) {
        _chapterChange += 1;
        _pageChange = 0;
    }else{
        _pageChange += 1;
    }
    return [[XDSReadManager sharedManager] readViewWithChapter:_chapterChange
                                                          page:_pageChange
                                                      delegate:self];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    _isPaging = NO;
    if (!completed) {
        XDSReadViewController *readView = previousViewControllers.firstObject;
        _pageChange = readView.recordModel.currentPage;
        _chapterChange = readView.recordModel.currentChapter;
    }
    else{
        [[XDSReadManager sharedManager] updateReadModelWithChapter:_chapterChange page:_pageChange];
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
- (LPPReadMenu *)readMenuView{
    if (nil == _readMenuView) {
        _readMenuView = [[LPPReadMenu alloc] initWithFrame:self.view.bounds];
        _readMenuView.backgroundColor = [UIColor clearColor];
    }
    return _readMenuView;
}
//MARK: - ABOUT MEMERY
- (void)readPageViewControllerDataInit{}


@end
