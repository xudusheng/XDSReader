//
//  LPPReadMenu.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/18.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "LPPReadMenu.h"
#import "LPPMenuBottomView.h"
#import "LPPReadSettingView.h"
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
LPPReadSettingViewDelegatge
>
//@property (weak, nonatomic) id /**<XDSReadMenuDelegate>*/ delegate;/// 代理
@property (assign, nonatomic) BOOL menuShow;// 菜单显示
@property (strong, nonatomic) UIView *leftView;// LeftView
@property (strong, nonatomic) UIView *topView;/// TopView
@property (strong, nonatomic) LPPMenuBottomView *bottomView;/// BottomView
@property (strong, nonatomic) UIView *lightView;/// 亮度
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
    
    //Bottom View
    [self createMuenuBottomView];
    //
    [self createSettingView];
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
//MARK: - ABOUT UI
- (void)createUI{
    
}
//MARK: - DELEGATE METHODS
//TODO: LPPMenuBottomViewDelegate
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedFuctionButton:(UIButton *)button{
    [self showReadSettingView];
}
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedPreviousButton:(UIButton *)previousButton{}
- (void)menuBottomView:(LPPMenuBottomView *)bottomView didSelectedNextButton:(UIButton *)nextButton{}

//TODO: LPPReadSettingViewDelegatge
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedTheme:(UIColor *)theme{}
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedEffect:(UIColor *)effect{}
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedFont:(NSString *)font{}
- (void)readSettingView:(LPPReadSettingView *)readSettingView didSelectedFontSize:(BOOL)plusSize{}

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
- (void)handleTap:(UITapGestureRecognizer *)tap{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hideReadMenu];
}
//MARK: - OTHER PRIVATE METHODS
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
        } completion:nil];
    }];
    
}
- (void)hideReadMenu{
    CGRect bottomViewFrame = CGRectMake(0,
                                        DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                        DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                        kLPPReadMenuBottomViewHeight);
    CGRect settingViewFrame = CGRectMake(0,
                                         DEVICE_MAIN_SCREEN_HEIGHT_XDSR,
                                         DEVICE_MAIN_SCREEN_WIDTH_XDSR,
                                         kLPPReadMenuSettingViewHeight);
    
    if (CGRectGetMaxY(self.readSettingView.frame) > DEVICE_MAIN_SCREEN_HEIGHT_XDSR) {
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.bottomView.frame = bottomViewFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.readSettingView.frame = settingViewFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.superview) {
        CGRect frame = CGRectMake(0, DEVICE_MAIN_SCREEN_HEIGHT_XDSR - kLPPReadMenuBottomViewHeight, DEVICE_MAIN_SCREEN_WIDTH_XDSR, kLPPReadMenuBottomViewHeight);
        [UIView animateWithDuration:kLPPReadMenuAnimateDuration animations:^{
            self.bottomView.frame = frame;
        }];
    }
}

//MARK: - ABOUT MEMERY
- (void)dataInit{
//#warning 添加视图类名称，点击这些控件不需要执行手势
//    self.classArray = @[@"UISlider"];
}


@end
