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
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate,
XDSReadViewControllerDelegate
>

{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
}

@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (strong, nonatomic) LPPReadMenu *readMenuView;//菜单
@property (nonatomic,strong) XDSRightMenuViewController *rightMenuVC;   //侧边栏
@property (nonatomic,strong) UIView * rightMenuContent;  //侧边栏背景

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
//    _menuView.frame = self.view.frame;
    _rightMenuContent.frame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_XDSR, 0, 2*DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    _rightMenuVC.view.frame = CGRectMake(0, 0, DEVICE_MAIN_SCREEN_WIDTH_XDSR-100, DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    [_rightMenuVC reload];
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
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    [self addChildViewController:self.rightMenuVC];
    [self.view addSubview:self.rightMenuContent];
    [self.rightMenuContent addSubview:self.rightMenuVC.view];
    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];
}

#pragma mark - init
-(UIPageViewController *)pageViewController{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        [self.view addSubview:_pageViewController.view];
    }
    return _pageViewController;
}

-(XDSRightMenuViewController *)rightMenuVC{
    if (!_rightMenuVC) {
        _rightMenuVC = [[XDSRightMenuViewController alloc] init];
        _rightMenuVC.bookModel = CURRENT_BOOK_MODEL;
        _rightMenuVC.catalogDelegate = self;
    }
    return _rightMenuVC;
}
- (UIView *)rightMenuContent{
    if (!_rightMenuContent) {
        _rightMenuContent = [[UIView alloc] init];
        _rightMenuContent.backgroundColor = [UIColor clearColor];
        _rightMenuContent.hidden = YES;
        [_rightMenuContent addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenRightMenu)];
            tap.delegate = self;
            tap;
        })];
    }
    return _rightMenuContent;
}
//MARK: - DELEGATE METHODS

-(void)menuViewMark:(XDSMenuTopView *)menuTopView{
    NSString * key = [NSString stringWithFormat:@"%zd_%zd",CURRENT_RECORD.currentPage,CURRENT_RECORD.currentPage];
    id isMarkExist = CURRENT_BOOK_MODEL.marksRecord[key];
    if (isMarkExist) {
        //如果存在移除书签信息
        [CURRENT_BOOK_MODEL.marksRecord removeObjectForKey:key];
        [[CURRENT_BOOK_MODEL mutableArrayValueForKey:@"marks"] removeObject:isMarkExist];
    }
    else{
        //记录书签信息
        XDSMarkModel *model = [[XDSMarkModel alloc] init];
        model.date = [NSDate date];
        model.recordModel = [CURRENT_RECORD copy];
        [[CURRENT_BOOK_MODEL mutableArrayValueForKey:@"marks"] addObject:model];
        [CURRENT_BOOK_MODEL.marksRecord setObject:model forKey:key];
    }
}

//TODO: XDSReadManagerDelegate
- (void)readViewDidClickCloseButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)readViewFontDidChanged{

    XDSReadViewController *readVC = [[XDSReadManager sharedManager] readViewWithChapter:CURRENT_RECORD.currentChapter
                                                                                   page:CURRENT_RECORD.currentPage
                                                                               delegate:self];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
}
- (void)readViewFontSizeDidChanged{}
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
    _chapter = CURRENT_RECORD.currentChapter;
    _page = CURRENT_RECORD.currentPage;
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
    
    _pageChange = _page;
    _chapterChange = _chapter;
    
    if (_chapterChange==0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange==0) {
        _chapterChange--;
        _pageChange = CURRENT_BOOK_MODEL.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [[XDSReadManager sharedManager] readViewWithChapter:_chapterChange
                                                          page:_pageChange
                                                      delegate:self];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == CURRENT_BOOK_MODEL.chapters.lastObject.pageCount-1 && _chapterChange == CURRENT_BOOK_MODEL.chapters.count-1) {
        return nil;
    }
    if (_pageChange == CURRENT_BOOK_MODEL.chapters[_chapterChange].pageCount-1) {
        _chapterChange++;
        _pageChange = 0;
    }
    else{
        _pageChange++;
    }
    return [[XDSReadManager sharedManager] readViewWithChapter:_chapterChange page:_pageChange delegate:self];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    if (!completed) {
        XDSReadViewController *readView = previousViewControllers.firstObject;
        _page = readView.recordModel.currentPage;
        _chapter = readView.recordModel.currentChapter;
    }
    else{
        [[XDSReadManager sharedManager] updateReadModelWithChapter:_chapter page:_page];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    _chapter = _chapterChange;
    _page = _pageChange;
}

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
-(void)showToolMenu{
    XDSReadViewController *readView = _pageViewController.viewControllers.firstObject;
    [readView.readView cancelSelected];
    
    [self.view addSubview:self.readMenuView];
//    NSString * key = [NSString stringWithFormat:@"%zd_%zd",CURRENT_RECORD.currentChapter,CURRENT_RECORD.currentPage];
//    id isMarkExist = CURRENT_BOOK_MODEL.marksRecord[key];
//    isMarkExist?
//    (_menuView.menuTopView.isMarkExist=1):
//    (_menuView.menuTopView.isMarkExist=0);
//    [self.menuView showAnimation:YES];
}
- (void)hiddenRightMenu{
    [self showRightMenu:NO];
}
-(void)addNotes:(NSNotification *)notification{
    XDSNoteModel *model = notification.object;
    model.recordModel = [CURRENT_RECORD copy];
    [[CURRENT_BOOK_MODEL mutableArrayValueForKey:@"notes"] addObject:model];    //这样写才能KVO数组变化
    [XDSReaderUtil showAlertWithTitle:nil message:@"保存笔记成功"];
}
//MARK: - OTHER PRIVATE METHODS
-(void)showRightMenu:(BOOL)show{
    show?
    ({
        _rightMenuContent.hidden = !show;
        [UIView animateWithDuration:KAnimationDelay animations:^{
            _rightMenuContent.frame = CGRectMake(0, 0,2*DEVICE_MAIN_SCREEN_HEIGHT_XDSR, DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
            
        } completion:^(BOOL finished) {
            [_rightMenuContent insertSubview:[[UIImageView alloc] initWithImage:[self blurredSnapshot]] atIndex:0];
        }];
    }):
    ({
        if ([_rightMenuContent.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [_rightMenuContent.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:KAnimationDelay animations:^{
            _rightMenuContent.frame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_XDSR, 0, 2*DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
        } completion:^(BOOL finished) {
            _rightMenuContent.hidden = !show;
            
        }];
    });
}

- (UIImage *)blurredSnapshot {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)), NO, 1.0f);
    [self.view drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}

- (LPPReadMenu *)readMenuView{
    if (nil == _readMenuView) {
        _readMenuView = [[LPPReadMenu alloc] initWithFrame:self.view.bounds];
        _readMenuView.backgroundColor = [UIColor clearColor];
    }
    return _readMenuView;
}
//MARK: - ABOUT MEMERY
- (void)readPageViewControllerDataInit{
    
}


@end
