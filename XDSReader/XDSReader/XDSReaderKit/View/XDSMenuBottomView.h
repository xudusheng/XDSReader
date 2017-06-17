//
//  XDSMenuBottomView.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDSMenuBottomView : UIView

@property (nonatomic,weak) id<XDSMenuViewDelegate> mvdelegate;
@property (nonatomic,strong) XDSRecordModel *readModel;

@end


@interface XDSThemeView : UIView
@end

@interface XDSReadProgressView : UIView
-(void)title:(NSString *)title progress:(NSString *)progress;
@end
