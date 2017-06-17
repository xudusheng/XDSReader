//
//  XDSReadView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSReadViewControllerDelegate;
@interface XDSReadView : UIView
@property (nonatomic,assign) CTFrameRef frameRef;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) id<XDSReadViewControllerDelegate> rvDelegate;
-(void)cancelSelected;
@end
