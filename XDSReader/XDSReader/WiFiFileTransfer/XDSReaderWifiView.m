//
//  XDSReaderWifiView.m
//  XDSReader
//
//  Created by Hmily on 2018/9/21.
//  Copyright © 2018年 macos. All rights reserved.
//

#import "XDSReaderWifiView.h"

@implementation XDSReaderWifiView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.closeButton.layer.cornerRadius = 20.f;
    self.closeButton.layer.masksToBounds = YES;
    self.closeButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.closeButton.layer.borderWidth = 1.f;
    [self.closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

@end
