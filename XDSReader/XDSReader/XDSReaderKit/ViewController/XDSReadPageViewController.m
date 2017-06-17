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
@interface XDSReadPageViewController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
XDSMenuViewDelegate,
UIGestureRecognizerDelegate,
XDSRightMenuViewControllerDelegate,
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
@property (nonatomic,strong) XDSMenuView *menuView; //菜单栏
@property (nonatomic,strong) XDSRightMenuViewController *rightMenuVC;   //侧边栏
@property (nonatomic,strong) UIView * rightMenuContent;  //侧边栏背景
@property (nonatomic,strong) XDSReadViewController *readView;   //当前阅读视图


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
    _menuView.frame = self.view.frame;
    _rightMenuContent.frame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_XDSR, 0, 2*DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    _rightMenuVC.view.frame = CGRectMake(0, 0, DEVICE_MAIN_SCREEN_WIDTH_XDSR-100, DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    [_rightMenuVC reload];
}

//MARK: - ABOUT UI
- (void)createReadPageViewControllerUI{
    [self addChildViewController:self.pageViewController];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_bookModel.record.currentChapter page:_bookModel.record.currentPage]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    _chapter = _bookModel.record.currentChapter;
    _page = _bookModel.record.currentPage;
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    [self.view addSubview:self.menuView];
    
    [self addChildViewController:self.rightMenuVC];
    [self.view addSubview:self.rightMenuContent];
    [self.rightMenuContent addSubview:self.rightMenuVC.view];
    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];
}

//MARK: - INIT
- (XDSReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    
    if (_bookModel.record.currentChapter != chapter) {
        [_bookModel.record.chapterModel updateFont];
        [self readChapterContent:chapter];
    }
    _readView = [[XDSReadViewController alloc] init];
    _readView.recordModel = _bookModel.record;
    
    if (_bookModel.bookType == XDSEBookTypeEpub) {
        _readView.bookType = XDSEBookTypeEpub;
        [self readChapterContent:chapter];
        _readView.epubFrameRef = _bookModel.chapters[chapter].epubframeRef[page];
        _readView.imageArray = _bookModel.chapters[chapter].imageArray;
        _readView.content = _bookModel.chapters[chapter].content;
    }
    else{
        _readView.bookType = XDSEBookTypeTxt;
        _readView.content = [_bookModel.chapters[chapter] stringOfPage:page];
    }
    _readView.rvdelegate = self;
    
    return _readView;
}

- (void)readChapterContent:(NSInteger)chapter{
    if (!_bookModel.chapters[chapter].epubframeRef) {
        
        XDSChapterModel *chapterModel = _bookModel.chapters[chapter];
        NSString *chapterFullPath = [APP_SANDBOX_DOCUMENT_PATH stringByAppendingString:chapterModel.chapterpath];
        NSURL *fileURL = [NSURL fileURLWithPath:chapterFullPath];
        NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:fileURL] encoding:NSUTF8StringEncoding];
        
        _bookModel.chapters[chapter].content = [html stringByConvertingHTMLToPlainText];
        [_bookModel.chapters[chapter] parserEpubToDictionary];
    }
    [_bookModel.chapters[chapter] paginateEpubWithBounds:CGRectMake(0,0, DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight, DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom)];

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
-(XDSMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[XDSMenuView alloc] init];
        _menuView.hidden = YES;
        _menuView.mvDelegate = self;
        _menuView.recordModel = _bookModel.record;
    }
    return _menuView;
}

-(XDSRightMenuViewController *)rightMenuVC{
    if (!_rightMenuVC) {
        _rightMenuVC = [[XDSRightMenuViewController alloc] init];
        _rightMenuVC.bookModel = _bookModel;
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
//TODO: XDSMenuViewDelegate
-(void)menuViewDidHidden:(XDSMenuView *)menu{
    _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(XDSMenuView *)menu{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(XDSMenuBottomView *)menuBottomView{
    [_menuView hiddenAnimation:NO];
    [self showRightMenu:YES];
    
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}
-(void)menuViewFontSize:(XDSMenuBottomView *)menuBottomView{
    [_bookModel.record.chapterModel updateFont];
    
    NSInteger page =
    (_bookModel.record.currentPage>_bookModel.record.chapterModel.pageCount-1)?
    _bookModel.record.chapterModel.pageCount-1:
    _bookModel.record.currentPage;
    
    XDSReadViewController *readVC = [self readViewWithChapter:_bookModel.record.currentChapter page:page];
    [_pageViewController setViewControllers:@[readVC]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self updateReadModelWithChapter:_bookModel.record.currentChapter page:page];
}

-(void)menuViewMark:(XDSMenuTopView *)menuTopView{
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_bookModel.record.currentPage,(int)_bookModel.record.currentPage];
    id isMarkExist = _bookModel.marksRecord[key];
    if (isMarkExist) {
        //如果存在移除书签信息
        [_bookModel.marksRecord removeObjectForKey:key];
        [[_bookModel mutableArrayValueForKey:@"marks"] removeObject:isMarkExist];
    }
    else{
        //记录书签信息
        XDSMarkModel *model = [[XDSMarkModel alloc] init];
        model.date = [NSDate date];
        model.recordModel = [_bookModel.record copy];
        [[_bookModel mutableArrayValueForKey:@"marks"] addObject:model];
        [_bookModel.marksRecord setObject:model forKey:key];
    }
    _menuView.menuTopView.isMarkExist = !isMarkExist;
    
    
}

//TODO: XDSRightMenuViewControllerDelegate
- (void)rightMenuViewController:(XDSRightMenuViewController *)rightMenuViewController didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
    [self hiddenRightMenu];
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
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
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
        _pageChange = _bookModel.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _bookModel.chapters.lastObject.pageCount-1 && _chapterChange == _bookModel.chapters.count-1) {
        return nil;
    }
    if (_pageChange == _bookModel.chapters[_chapterChange].pageCount-1) {
        _chapterChange++;
        _pageChange = 0;
    }
    else{
        _pageChange++;
    }
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed{
    
    if (!completed) {
        XDSReadViewController *readView = previousViewControllers.firstObject;
        _readView = readView;
        _page = readView.recordModel.currentPage;
        _chapter = readView.recordModel.currentChapter;
    }
    else{
        [self updateReadModelWithChapter:_chapter page:_page];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    _chapter = _chapterChange;
    _page = _pageChange;
}

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
-(void)showToolMenu{
    [_readView.readView cancelSelected];
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_bookModel.record.currentChapter,(int)_bookModel.record.currentPage];
    
    id isMarkExist = _bookModel.marksRecord[key];
    isMarkExist?
    (_menuView.menuTopView.isMarkExist=1):
    (_menuView.menuTopView.isMarkExist=0);
    
    [self.menuView showAnimation:YES];
}
- (void)hiddenRightMenu{
    [self showRightMenu:NO];
}
-(void)addNotes:(NSNotification *)notification{
    XDSNoteModel *model = notification.object;
    model.recordModel = [_bookModel.record copy];
    [[_bookModel mutableArrayValueForKey:@"notes"] addObject:model];    //这样写才能KVO数组变化
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

-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    _chapter = chapter;
    _page = page;
    _bookModel.record.chapterModel = _bookModel.chapters[chapter];
    _bookModel.record.currentChapter = chapter;
    _bookModel.record.currentPage = page;
    [XDSBookModel updateLocalModel:_bookModel url:_resourceURL];
}
//MARK: - ABOUT MEMERY
- (void)readPageViewControllerDataInit{
    
}


@end
