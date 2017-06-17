//
//  XDSReaderDelegate.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/16.
//  Copyright © 2017年 macos. All rights reserved.
//

#ifndef XDSReaderDelegate_h
#define XDSReaderDelegate_h

@class XDSMenuBottomView;
@class XDSMenuTopView;
@class XDSMenuView;
@protocol XDSMenuViewDelegate <NSObject>
@optional
-(void)menuViewDidHidden:(XDSMenuView *)menu;
-(void)menuViewDidAppear:(XDSMenuView *)menu;
-(void)menuViewInvokeCatalog:(XDSMenuBottomView *)menuBottomView;
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page;
-(void)menuViewFontSize:(XDSMenuBottomView *)menuBottomView;
-(void)menuViewMark:(XDSMenuTopView *)menuTopView;
@end


@class XDSReadViewController;
@protocol XDSReadViewControllerDelegate <NSObject>
-(void)readViewEditeding:(XDSReadViewController *)readViewController;
-(void)readViewEndEdit:(XDSReadViewController *)readViewController;
@end


#endif /* XDSReaderDelegate_h */
