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

@property (strong, nonatomic) LPPReadView *readView;
@property (strong, nonatomic) DTAttributedTextView *readTextView;
@property (strong, nonatomic) LPPChapterModel *chapterModel;

@end

@implementation LPPReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.chapterModel = [[LPPChapterModel alloc] init];
    
    CGRect frame = CGRectMake(20,
                              20,
                              DEVICE_MAIN_SCREEN_WIDTH_XDSR - 40,
                              DEVICE_MAIN_SCREEN_HEIGHT_XDSR - 40);
    [self.chapterModel paginateEpubWithBounds:frame];
    
    self.readView = [[LPPReadView alloc] initWithFrame:frame readAttributedContent:self.chapterModel.pageAttributeStrings[0]];
    
    [self.view addSubview:self.readView];
    
}


@end
