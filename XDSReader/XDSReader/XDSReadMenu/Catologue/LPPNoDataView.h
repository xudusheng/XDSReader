//
//  LPPNoDataView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/23.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPPNoDataView : UIView

+ (instancetype)newInstance;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
