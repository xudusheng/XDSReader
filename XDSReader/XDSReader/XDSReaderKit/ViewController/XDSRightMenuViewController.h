//
//  XDSRightMenuViewController.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDSRightMenuViewController;
@protocol XDSRightMenuViewControllerDelegate <NSObject>
@optional
-(void)rightMenuViewController:(XDSRightMenuViewController *)rightMenuViewController
              didSelectChapter:(NSUInteger)chapter
                          page:(NSUInteger)page;
@end
@interface XDSRightMenuViewController : UIViewController

@property (nonatomic,strong) XDSBookModel *bookModel;
@property (nonatomic,weak) id<XDSRightMenuViewControllerDelegate>catalogDelegate;

- (void)reload;
@end
