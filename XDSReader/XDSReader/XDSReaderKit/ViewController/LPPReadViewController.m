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

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.chapterModel = CURRENT_BOOK_MODEL.chapters[self.chapterNum];
    NSAttributedString *pageAttributeString = self.chapterModel.pageAttributeStrings[self.pageNum];
    CGRect frame = CGRectMake(20,
                              20,
                              DEVICE_MAIN_SCREEN_WIDTH_XDSR - 40,
                              DEVICE_MAIN_SCREEN_HEIGHT_XDSR - 40);
    
    self.readView = [[LPPReadView alloc] initWithFrame:frame readAttributedContent:pageAttributeString];
    [self.view addSubview:self.readView];
    
}


@end
