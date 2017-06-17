//
//  XDSReadViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadViewController.h"

@interface XDSReadViewController ()<XDSReadViewControllerDelegate>

@end

@implementation XDSReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readViewControllerDataInit];
    [self createReadViewControllerUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readViewThemeChanged:) name:LSYThemeNotification object:nil];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
//MARK: - ABOUT UI
- (void)createReadViewControllerUI{
    [self.view setBackgroundColor:[XDSReadConfig shareInstance].theme];
    [self.view addSubview:self.readView];
}
//MARK: - DELEGATE METHODS
//TODO: XDSReadViewControllerDelegate
-(void)readViewEditeding:(XDSReadViewController *)readViewController{
    if ([self.rvdelegate respondsToSelector:@selector(readViewEditeding:)]) {
        [self.rvdelegate readViewEditeding:self];
    }
}
-(void)readViewEndEdit:(XDSReadViewController *)readViewController{
    if ([self.rvdelegate respondsToSelector:@selector(readViewEndEdit:)]) {
        [self.rvdelegate readViewEndEdit:self];
    }
}

//MARK: - ABOUT REQUEST

//MARK: - ABOUT EVENTS
- (void)readViewThemeChanged:(NSNotification *)notification{
    [XDSReadConfig shareInstance].theme = notification.object;
    [self.view setBackgroundColor:[XDSReadConfig shareInstance].theme];
}
//MARK: - OTHER PRIVATE METHODS
//TODO: GETTER
- (XDSReadView *)readView{
    if (!_readView) {
        _readView = [[XDSReadView alloc] initWithFrame:({
            CGRect frame = CGRectMake(kReadViewMarginLeft,
                                      kReadViewMarginTop,
                                      DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight,
                                      DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom);
            frame;
        })];
        XDSReadConfig *config = [XDSReadConfig shareInstance];
        if (_bookType == XDSEBookTypeEpub) {
            _readView.frameRef = (__bridge CTFrameRef)_epubFrameRef;
            _readView.imageArray = _imageArray;
        }
        else{
            _readView.frameRef = [XDSReadParser parserContent:_content config:config bouds:CGRectMake(0,0, CGRectGetWidth(_readView.frame), CGRectGetHeight(_readView.frame))];
        }
        _readView.content = _content;
        _readView.rvDelegate = self;
    }
    return _readView;
}

//MARK: - ABOUT MEMERY
- (void)readViewControllerDataInit{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
