//
//  LPPReadViewController.m
//  XDSReader
//
//  Created by dusheng.xu on 07/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "LPPReadViewController.h"
#import "LPPReadView.h"
@interface LPPReadViewController ()

@property (strong, nonatomic) DTAttributedTextView *readTextView;
@property (strong, nonatomic) LPPChapterModel *chapterModel;

@end

@implementation LPPReadViewController
- (instancetype)initWithChapterNumber:(NSInteger)chapterNum pageNumber:(NSInteger)pageNum {
    if (self = [super init]) {
        self.chapterNum = chapterNum;
        self.pageNum = pageNum;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [XDSReadConfig shareInstance].currentTheme?[XDSReadConfig shareInstance].currentTheme:[XDSReadConfig shareInstance].cacheTheme;

    CGRect frame = [XDSReadManager readViewBounds];
    self.readView = [[LPPReadView alloc] initWithFrame:frame chapterNum:self.chapterNum pageNum:self.pageNum];
    self.readView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.readView];
    
}

- (void)dealloc{
    NSLog(@"LPPReadViewController dealloc");
}

@end
