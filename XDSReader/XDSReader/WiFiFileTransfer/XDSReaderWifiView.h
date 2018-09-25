//
//  XDSReaderWifiView.h
//  XDSReader
//
//  Created by Hmily on 2018/9/21.
//  Copyright © 2018年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSReaderWifiView : UIView
@property (weak, nonatomic) IBOutlet UILabel *wifiNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ipAndPortLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
