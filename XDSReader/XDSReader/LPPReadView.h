//
//  LPPReadView.h
//  XDSReader
//
//  Created by dusheng.xu on 07/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSReadViewControllerDelegate;

@interface LPPReadView : UIView

- (instancetype)initWithFrame:(CGRect)frame readAttributedContent:(NSAttributedString *)readAttributedContent;

- (void)setReadAttributedString:(NSAttributedString *)readAttributedString;

-(void)cancelSelected;


@property (nonatomic,strong) id<XDSReadViewControllerDelegate> rvDelegate;


@end
