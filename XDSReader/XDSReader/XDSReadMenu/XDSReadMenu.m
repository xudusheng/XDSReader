//
//  XDSReadMenu.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/18.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadMenu.h"
#import "XDSMenuTopView.h"
#import "XDSMenuBottomView.h"
#import "XDSReadSettingView.h"
#import "XDSLightView.h"
#import "XDSCatalogueView.h"
/// 阅读页面动画的时间
CGFloat const kXDSReadMenuAnimateDuration = 0.2f;
/// BottomView 高
CGFloat const kXDSReadMenuBottomViewHeight = 112.f;
/// LightView 高
CGFloat const kXDSReadMenuLightViewHeight = 64.f;
/// LightButton 宽高
CGFloat const kXDSReadMenuLightButtonWH = 84.f;
/// ReadSettingView 高
CGFloat const kXDSReadMenuSettingViewHeight = 218.f;


@interface XDSReadMenu ()<
XDSMenuBottomViewDelegate,
XDSReadSettingViewDelegatge,
XDSCatalogueViewDelegate
>
//@property (weak, nonatomic) id /**<XDSReadMenuDelegate>*/ delegate;/// 代理
@property (assign, nonatomic) BOOL menuShow;// 菜单显示
@property (strong, nonatomic) XDSCatalogueView *leftView;// LeftView
@property (strong, nonatomic) XDSMenuTopView *topView;/// TopView
@property (strong, nonatomic) XDSMenuBottomView *bottomView;/// BottomView
@property (strong, nonatomic) XDSLightView *lightView;/// 亮度
@property (strong, nonatomic) UIView *coverView;/// 遮盖亮度
@property (strong, nonatomic) UIButton *lightButton;/// 亮度按钮
@property (strong, nonatomic) XDSReadSettingView *readSettingView;/// 小说阅读设置

@end

@implementation XDSReadMenu

//MARK: -  override super method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createReadMenu];
    }
    return self;
}


- (void)createReadMenu{
    
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // 允许获取电量信息
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    // 隐藏导航栏
//    vc.fd_prefersNavigationBarHidden = true
    
    // 禁止手势返回
//    vc.fd_interactivePopDisabled = true
    
    // 创建UI
    [self creatUI];
    
    // 初始化数据
    [self dataInit];
}

// 创建UI
- (void)creatUI{
    [self createMenuTopView];
    //Bottom View
    [self createMuenuBottomView];
    //Setting View
    [self createSettingView];
    //Light View
    [self createLightView];
    
    //left view
    [self createLeftView];
}
//TODO: -- Top View
- (void)createMenuTopView{
    CGRect frame = CGRectMake(0, -DEVICE_NAV_BAR_HEIGHT, DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_NAV_BAR_HEIGHT);
    self.topView = [[XDSMenuTopView alloc] initWithFrame:frame];
    self.topView.backgroundColor = READ_BACKGROUND_COLOC;
    [self addSubview:self.topView];
}

//TODO: -- BottomView
- (void)createMuenuBottomView{
    CGRect frame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kXDSReadMenuBottomViewHeight);
    self.bottomView = [[XDSMenuBottomView alloc] initWithFrame:frame];
    self.bottomView.backgroundColor = READ_BACKGROUND_COLOC;
    self.bottomView.bvDelegate = self;
    [self addSubview:self.bottomView];
}

- (void)createSettingView{
    CGRect frame = CGRectMake(0,
                              DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                              DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                              kXDSReadMenuSettingViewHeight);
    self.readSettingView = [[XDSReadSettingView alloc] initWithFrame:frame];
    self.readSettingView.backgroundColor = READ_BACKGROUND_COLOC;
    self.readSettingView.svDelegate = self;
    [self addSubview:self.readSettingView];
}

- (void)createLightView{
    CGRect frame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kXDSReadMenuLightButtonWH);
    self.lightView = [[XDSLightView alloc] initWithFrame:frame];
    self.lightView.backgroundColor = READ_BACKGROUND_COLOC;
    [self addSubview:self.lightView];
}

- (void)createLeftView{
    CGRect frame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_XDSR*3/4,
                              0,
                              DEVICE_MAIN_SCREEN_WIDTH_XDSR*3/4,
                              DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    self.leftView = [[XDSCatalogueView alloc] initWithFrame:frame];
    self.leftView.backgroundColor = READ_BACKGROUND_COLOC;
    self.leftView.cvDelegate = self;
    [self addSubview:self.leftView];
}
//MARK: - ABOUT UI
- (void)createUI{
    
}
//MARK: - DELEGATE METHODS
//TODO: XDSMenuBottomViewDelegate
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedFuctionButton:(UIButton *)button{
    if (button.tag == 0) {
        [self showCatalogueView];
    }else if (button.tag == 1){
        [self showLightView];
    }else if (button.tag == 2){
        [self showReadSettingView];
    }
}
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedPreviousButton:(UIButton *)previousButton{
    NSInteger currentChapter = CURRENT_RECORD.currentChapter;
    currentChapter -= 1;
    NSInteger page = 0;
    [[XDSReadManager sharedManager] readViewJumpToChapter:currentChapter page:page];
    CGFloat program = CURRENT_RECORD.currentPage/((float)(CURRENT_RECORD.chapterModel.pageCount-1))*100;
    [bottomView setReadProgram:program];
}
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedNextButton:(UIButton *)nextButton{
    NSInteger currentChapter = CURRENT_RECORD.currentChapter;
    if (currentChapter < CURRENT_RECORD.totalChapters - 1) {
        currentChapter += 1;
    }
    NSInteger page = 0;
    [[XDSReadManager sharedManager] readViewJumpToChapter:currentChapter page:page];
    CGFloat program = CURRENT_RECORD.currentPage/((float)(CURRENT_RECORD.chapterModel.pageCount-1))*100;
    [bottomView setReadProgram:program];
}
- (void)menuBottomView:(XDSMenuBottomView *)bottomView didSelectedSliderValueChanged:(UISlider *)slider{
    
    NSInteger page =ceil((CURRENT_RECORD.chapterModel.pageCount-1)*slider.value);
    NSInteger chapter = CURRENT_RECORD.currentChapter;
    [[XDSReadManager sharedManager] readViewJumpToChapter:chapter page:page];
}

//TODO: XDSReadSettingViewDelegatge
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedTheme:(UIColor *)theme{
    [[XDSReadManager sharedManager] configReadTheme:theme];
}
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedEffect:(UIColor *)effect{

}
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedFont:(NSString *)font{
    [[XDSReadManager sharedManager] configReadFontName:font];
}
- (void)readSettingView:(XDSReadSettingView *)readSettingView didSelectedFontSize:(BOOL)plusSize{
    [[XDSReadManager sharedManager] configReadFontSize:plusSize];
//    _fontLabel.text = @([XDSReadConfig shareInstance].fontSize).stringValue;
}

//TODO:XDSCatalogueViewDelegate
- (void)catalogueViewDidSelecteCatalogue:(XDSCatalogueModel *)catalogueModel {
    
    NSInteger selectedChapterNum = catalogueModel.chapter;
    XDSChapterModel *chapterModel = CURRENT_BOOK_MODEL.chapters[selectedChapterNum];
    
    if (chapterModel.locationWithPageIdMapping == nil) {
        [CURRENT_BOOK_MODEL loadContentInChapter:chapterModel];
    }
    NSString *locationKey = [NSString stringWithFormat:@"${id=%@}", catalogueModel.catalogueId];
    NSInteger locationInChapter = [chapterModel.locationWithPageIdMapping[locationKey] integerValue];
    NSInteger page = [chapterModel getPageWithLocationInChapter:locationInChapter];
    [[XDSReadManager sharedManager] readViewJumpToChapter:selectedChapterNum page:page];
    [self hideReadMenu];
}

- (void)catalogueViewDidSelectedNote:(XDSNoteModel *)noteModel{
    [[XDSReadManager sharedManager] readViewJumpToNote:noteModel];
    [self hideReadMenu];
}
- (void)catalogueViewDidSelectedMark:(XDSMarkModel *)markModel{
    [[XDSReadManager sharedManager] readViewJumpToMark:markModel];
    [self hideReadMenu];
}

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
- (void)handleTap:(UITapGestureRecognizer *)tap{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideReadMenu];
}
//MARK: - OTHER PRIVATE METHODS
- (void)showCatalogueView{
    CGRect topFrame = CGRectMake(0, -DEVICE_NAV_BAR_HEIGHT, DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_NAV_BAR_HEIGHT);
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kXDSReadMenuBottomViewHeight);
    CGRect catalogueViewFrame = self.leftView.frame;
    catalogueViewFrame.origin.x = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
        self.topView.frame = topFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.leftView.frame = catalogueViewFrame;
        } completion:nil];
    }];
}
- (void)showLightView{
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kXDSReadMenuBottomViewHeight);
    CGRect lightViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kXDSReadMenuLightButtonWH,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kXDSReadMenuLightButtonWH);
    [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.lightView.frame = lightViewFrame;
        } completion:nil];
    }];
}
- (void)showReadSettingView{
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kXDSReadMenuBottomViewHeight);
    CGRect settingViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kXDSReadMenuSettingViewHeight,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kXDSReadMenuSettingViewHeight);
    
    [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.readSettingView.frame = settingViewFrame;
        } completion:^(BOOL finished) {
            [self.readSettingView startHaloAnimate];
        }];
    }];
    
}
- (void)hideReadMenu{
    CGRect topFrame = CGRectMake(0, -DEVICE_NAV_BAR_HEIGHT, DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_NAV_BAR_HEIGHT);
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kXDSReadMenuBottomViewHeight);
    CGRect settingViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kXDSReadMenuSettingViewHeight);
    CGRect lightViewFrame = CGRectMake(0,
                                       DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                       DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                       kXDSReadMenuLightButtonWH);
    CGRect leftViewFrame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_XDSR*3/4,
                              0,
                              DEVICE_MAIN_SCREEN_WIDTH_XDSR*3/4,
                              DEVICE_MAIN_SCREEN_HEIGHT_XDSR);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    if (CGRectGetMinY(self.readSettingView.frame) < DEVICE_MAIN_SCREEN_HEIGHT_XDSR) {
        //设置页面隐藏时，刷新一遍全文章节
        if ([[XDSReadConfig shareInstance] isReadConfigChanged]) {
            [CURRENT_BOOK_MODEL loadContentForAllChapters];
        }
        
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.readSettingView.frame = settingViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if (CGRectGetMinY(self.lightView.frame) < DEVICE_MAIN_SCREEN_HEIGHT_XDSR) {
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.lightView.frame = lightViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if (CGRectGetMaxX(self.leftView.frame) > 0) {
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.leftView.frame = leftViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.bottomView.frame = bottomViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)updateReadRecord{//更新进度
    CGFloat programe = (CURRENT_RECORD.currentPage + 1)*1.0f/CURRENT_RECORD.chapterModel.pageCount;
    [self.bottomView setReadProgram:programe];
    [self.topView updateMarkButtonState];
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        CGRect bottomFrame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kXDSReadMenuBottomViewHeight, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kXDSReadMenuBottomViewHeight);
        CGRect topFrame = CGRectMake(0, 0, DEVICE_MAIN_SCREEN_WIDTH_XDSR, DEVICE_NAV_BAR_HEIGHT);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:kXDSReadMenuAnimateDuration animations:^{
            self.bottomView.frame = bottomFrame;
            self.topView.frame = topFrame;
        }];
    }
}

//MARK: - ABOUT MEMERY
- (void)dataInit{
//#warning 添加视图类名称，点击这些控件不需要执行手势
//    self.classArray = @[@"UISlider"];
}


@end
