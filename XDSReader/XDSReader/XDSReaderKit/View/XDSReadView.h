//
//  XDSReadView.h
//  XDSReader
//
//  Created by dusheng.xu on 07/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSReadViewControllerDelegate;

@interface XDSReadView : UIView

- (instancetype)initWithFrame:(CGRect)frame chapterNum:(NSInteger)chapterNum pageNum:(NSInteger)pageNum;

- (void)cancelSelected;

@property (nonatomic,strong) id<XDSReadViewControllerDelegate> rvDelegate;


@end
