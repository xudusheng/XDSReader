//
//  XDSMenuView.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSMenuView.h"
@interface XDSMenuView () <XDSMenuViewDelegate>
@end

@implementation XDSMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMenuViewUI];
    }
    return self;
}
-(void)createMenuViewUI{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.menuTopView];
    [self addSubview:self.menuBottomView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)]];
}
-(XDSMenuTopView *)menuTopView{
    if (!_menuTopView) {
        _menuTopView = [[XDSMenuTopView alloc] init];
        _menuTopView.mvdelegate = self;
    }
    return _menuTopView;
}
-(XDSMenuBottomView *)menuBottomView{
    if (!_menuBottomView) {
        _menuBottomView = [[XDSMenuBottomView alloc] init];
        _menuBottomView.mvdelegate = self;
    }
    return _menuBottomView;
}
-(void)setRecordModel:(XDSRecordModel *)recordModel{
    _recordModel = recordModel;
    _menuBottomView.readModel = recordModel;
}
#pragma mark - LSYMenuViewmvdelegate
-(void)menuViewInvokeCatalog:(XDSMenuBottomView *)menuBottomView{
    if ([self.mvDelegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.mvDelegate menuViewInvokeCatalog:menuBottomView];
    }
}
-(void)menuViewJumpChapter:(NSInteger)chapter page:(NSInteger)page{
    if ([self.mvDelegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
        [self.mvDelegate menuViewJumpChapter:chapter page:page];
    }
}
-(void)menuViewFontSize:(XDSMenuBottomView *)menuBottomView{
    if ([self.mvDelegate respondsToSelector:@selector(menuViewFontSize:)]) {
        [self.mvDelegate menuViewFontSize:menuBottomView];
    }
}
-(void)menuViewMark:(XDSMenuTopView *)menuTopView{
    if ([self.mvDelegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.mvDelegate menuViewMark:menuTopView];
    }
}
#pragma mark -
-(void)hiddenSelf{
    [self hiddenAnimation:YES];
}
-(void)showAnimation:(BOOL)animation{
    self.hidden = NO;
    [UIView animateWithDuration:animation?KAnimationDelay:0 animations:^{
        _menuTopView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kMenuTopViewHeight);
        _menuBottomView.frame = CGRectMake(0,
                                           CGRectGetHeight(self.frame)-kMenuBottomViewHeight,
                                           CGRectGetWidth(self.frame),
                                           kMenuBottomViewHeight);
    } completion:^(BOOL finished) {
        
    }];
    if ([self.mvDelegate respondsToSelector:@selector(menuViewDidAppear:)]) {
        [self.mvDelegate menuViewDidAppear:self];
    }
}
-(void)hiddenAnimation:(BOOL)animation{
    [UIView animateWithDuration:animation?KAnimationDelay:0 animations:^{
        _menuTopView.frame = CGRectMake(0,
                                        -kMenuTopViewHeight,
                                        CGRectGetWidth(self.frame),
                                        kMenuTopViewHeight);
        _menuBottomView.frame = CGRectMake(0,
                                           CGRectGetHeight(self.frame),
                                           CGRectGetWidth(self.frame),
                                           kMenuBottomViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    if ([self.mvDelegate respondsToSelector:@selector(menuViewDidHidden:)]) {
        [self.mvDelegate menuViewDidHidden:self];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _menuTopView.frame = CGRectMake(0,
                                    -kMenuTopViewHeight,
                                    CGRectGetWidth(self.frame),
                                    kMenuTopViewHeight);
    _menuBottomView.frame = CGRectMake(0,
                                       CGRectGetHeight(self.frame),
                                       CGRectGetWidth(self.frame),
                                       kMenuBottomViewHeight);
}

@end
