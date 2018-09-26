//
//  XDSWIFIFileTransferViewController.h
//  XDSPractice
//
//  Created by zhengda on 15/12/21.
//  Copyright © 2015年 zhengda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSWIFIFileTransferViewControllerDelegate <NSObject>

- (void)didBooksChanged;

@end


@interface XDSWIFIFileTransferViewController : UIViewController

+ (instancetype)newInstance;


@property (nonatomic,weak) id <XDSWIFIFileTransferViewControllerDelegate> wDelegate;

@end
