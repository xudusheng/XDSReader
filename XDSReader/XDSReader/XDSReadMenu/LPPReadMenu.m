//
//  LPPReadMenu.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/18.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPReadMenu.h"
#import "LPPMenuTopView.h"
#import "LPPMenuBottomView.h"
#import "LPPReadSettingView.h"
#import "LPPLightView.h"
#import "LPPCatalogueView.h"
/// 阅读页面动画的时间
CGFloat const kLPPReadMenuAnimateDuration = 0.2f;
/// BottomView 高
CGFloat const kLPPReadMenuBottomViewHeight = 112.f;
/// LightView 高
CGFloat const kLPPReadMenuLightViewHeight = 64.f;
/// LightButton 宽高
CGFloat const kLPPReadMenuLightButtonWH = 84.f;
/// ReadSettingView 高
CGFloat const kLPPReadMenuSettingViewHeight = 218.f;


@interface LPPReadMenu ()<
LPPMenuBottomViewDelegate,
LPPReadSettingViewDelegatge,
LPPCatalogueViewDelegate
>
//@property (weak, nonatomic) id /**<XDSReadMenuDelegate>*/ delegate;/// 代理
@property (assign, nonatomic) BOOL menuShow;// 菜单显示
@property (strong, nonatomic) LPPCatalogueView *leftView;// LeftView
@property (strong, nonatomic) LPPMenuTopView *topView;/// TopView
@property (strong, nonatomic) LPPMenuBottomView *bottomView;/// BottomView
@property (strong, nonatomic) LPPLightView *lightView;/// 亮度
@property (strong, nonatomic) UIView *coverView;/// 遮盖亮度
@property (strong, nonatomic) UIButton *lightButton;/// 亮度按钮
@property (strong, nonatomic) LPPReadSettingView *readSettingView;/// 小说阅读设置

@end

@implementation LPPReadMenu

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
    CGRect frame = CGRectMake(0, -kNavgationBarHeight, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kNavgationBarHeight);
    self.topView = [[LPPMenuTopView alloc] initWithFrame:frame];
    self.topView.backgroundColor = READ_BACKGROUND_COLOC;
    [self addSubview:self.topView];
}

//TODO: -- BottomView
- (void)createMuenuBottomView{
    CGRect frame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kLPPReadMenuBottomViewHeight);
    self.bottomView = [[LPPMenuBottomView alloc] initWithFrame:frame];
    self.bottomView.backgroundColor = READ_BACKGROUND_COLOC;
    self.bottomView.bvDelegate = self;
    [self addSubview:self.bottomView];
}

- (void)createSettingView{
    CGRect frame = CGRectMake(0,
                              DEVICE_MAIN_SCREEN_HEIGHT_LPPR,
                              DEVICE_MAIN_SCREEN_WIDTH_LPPR,
                              kLPPReadMenuSettingViewHeight);
    self.readSettingView = [[LPPReadSettingView alloc] initWithFrame:frame];
    self.readSettingView.backgroundColor = READ_BACKGROUND_COLOC;
    self.readSettingView.svDelegate = self;
    [self addSubview:self.readSettingView];
}

- (void)createLightView{
    CGRect frame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kLPPReadMenuLightButtonWH);
    self.lightView = [[LPPLightView alloc] initWithFrame:frame];
    self.lightView.backgroundColor = READ_BACKGROUND_COLOC;
    [self addSubview:self.lightView];
}

- (void)createLeftView{
    CGRect frame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_LPPR*3/4,
                              0,
                              DEVICE_MAIN_SCREEN_WIDTH_LPPR*3/4,
                              DEVICE_MAIN_SCREEN_HEIGHT_LPPR);
    self.leftView = [[LPPCatalogueView alloc] initWithFrame:frame];
    self.leftView.backgroundColor = READ_BACKGROUND_COLOC;
    self.leftView.cvDelegate = self;
    [self addSubview:self.leftView];
}
//MARK: - ABOUT UI
- (void)createUI{
    
}
//MARK: - DELEGATE METHODS
//TODO: LPPMenuBottomViewDelegate
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedFuctionButton:(UIButton *)button{
    if (button.tag == 0) {
        [self showCatalogueView];
    }else if (button.tag == 1){
        [self showLightView];
    }else if (button.tag == 2){
        [self showReadSettingView];
    }
}
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedPreviousButton:(UIButton *)previousButton{
    NSInteger currentChapter = CURRENT_RECORD.currentChapter;
    currentChapter -= 1;
    [[XDSReadManager sharedManager] readViewJumpToChapter:currentChapter page:0];
    CGFloat program = CURRENT_RECORD.currentPage/((float)(CURRENT_RECORD.chapterModel.pageCount-1))*100;
    [bottomView setReadProgram:program];
}
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedNextButton:(UIButton *)nextButton{
    NSInteger currentChapter = CURRENT_RECORD.currentChapter;
    if (currentChapter < CURRENT_RECORD.totalChapters - 1) {
        currentChapter += 1;
    }

    [[XDSReadManager sharedManager] readViewJumpToChapter:currentChapter page:0];
    CGFloat program = CURRENT_RECORD.currentPage/((float)(CURRENT_RECORD.chapterModel.pageCount-1))*100;
    [bottomView setReadProgram:program];
}
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedSliderValueChanged:(UISlider *)slider{
    
    NSUInteger page =ceil((CURRENT_RECORD.chapterModel.pageCount-1)*slider.value);
    [[XDSReadManager sharedManager] readViewJumpToChapter:CURRENT_RECORD.currentChapter page:page];
}

//TODO: LPPReadSettingViewDelegatge
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedTheme:(UIColor *)theme{
    [[XDSReadManager sharedManager] configReadTheme:theme];
}
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedEffect:(UIColor *)effect{

}
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedFont:(NSString *)font{
    [[XDSReadManager sharedManager] configReadFontName:font];
}
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedFontSize:(BOOL)plusSize{
    [[XDSReadManager sharedManager] configReadFontSize:plusSize];
//    _fontLabel.text = @([XDSReadConfig shareInstance].fontSize).stringValue;
}

//TODO:LPPCatalogueViewDelegate
- (void)catalogueViewDidSelectedChapter:(XDSChapterModel *)chapterModel{
    NSInteger selectedChapter = [CURRENT_BOOK_MODEL.chapters indexOfObject:chapterModel];
    NSInteger page = 0;
    [[XDSReadManager sharedManager] readViewJumpToChapter:&selectedChapter page:&page];
    [self hideReadMenu];
}

- (void)catalogueViewDidSelectedNote:(XDSNoteModel *)noteModel{
//    [noteModel.recordModel.chapterModel updateFont];
    NSInteger chapter = noteModel.chapter;
    NSInteger page = noteModel.page;
    [[XDSReadManager sharedManager] readViewJumpToChapter:&chapter page:&page];
    [self hideReadMenu];
}
- (void)catalogueViewDidSelectedMark:(XDSMarkModel *)markModel{}

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
- (void)handleTap:(UITapGestureRecognizer *)tap{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideReadMenu];
}
//MARK: - OTHER PRIVATE METHODS
- (void)showCatalogueView{
    CGRect topFrame = CGRectMake(0, -kNavgationBarHeight, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kNavgationBarHeight);
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kLPPReadMenuBottomViewHeight);
    CGRect catalogueViewFrame = self.leftView.frame;
    catalogueViewFrame.origin.x = 0;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
        self.topView.frame = topFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.leftView.frame = catalogueViewFrame;
        } completion:nil];
    }];
}
- (void)showLightView{
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kLPPReadMenuBottomViewHeight);
    CGRect lightViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kLPPReadMenuLightButtonWH,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kLPPReadMenuLightButtonWH);
    [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.lightView.frame = lightViewFrame;
        } completion:nil];
    }];
}
- (void)showReadSettingView{
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kLPPReadMenuBottomViewHeight);
    CGRect settingViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kLPPReadMenuSettingViewHeight,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kLPPReadMenuSettingViewHeight);
    
    [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
        self.bottomView.frame = bottomViewFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.readSettingView.frame = settingViewFrame;
        } completion:^(BOOL finished) {
            [self.readSettingView startHaloAnimate];
        }];
    }];
    
}
- (void)hideReadMenu{
    CGRect topFrame = CGRectMake(0, -kNavgationBarHeight, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kNavgationBarHeight);
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kLPPReadMenuBottomViewHeight);
    CGRect settingViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kLPPReadMenuSettingViewHeight);
    CGRect lightViewFrame = CGRectMake(0,
                                       DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                       DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                       kLPPReadMenuLightButtonWH);
    CGRect leftViewFrame = CGRectMake(-DEVICE_MAIN_SCREEN_WIDTH_LPPR*3/4,
                              0,
                              DEVICE_MAIN_SCREEN_WIDTH_LPPR*3/4,
                              DEVICE_MAIN_SCREEN_HEIGHT_LPPR);
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    if (CGRectGetMinY(self.readSettingView.frame) < DEVICE_MAIN_SCREEN_HEIGHT_XDSR) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.readSettingView.frame = settingViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if (CGRectGetMinY(self.lightView.frame) < DEVICE_MAIN_SCREEN_HEIGHT_XDSR) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.lightView.frame = lightViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if (CGRectGetMaxX(self.leftView.frame) > 0) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.leftView.frame = leftViewFrame;
            self.topView.frame = topFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
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
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        CGRect bottomFrame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kLPPReadMenuBottomViewHeight, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kLPPReadMenuBottomViewHeight);
        CGRect topFrame = CGRectMake(0, 0, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kNavgationBarHeight);
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
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
