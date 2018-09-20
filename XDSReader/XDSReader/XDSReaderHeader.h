//
//  XDSReaderHeader.h
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#ifndef XDSReaderHeader_h
#define XDSReaderHeader_h


/*
 *  添加libz.tbd
 *  other link flag 添加  -lxml2
 *  Header Search Paths 添加  usr/include/libxml2
 *  ZipArchive添加到项目工程以后，如果工程中有.pch文件，也就是预编译文件，command + B以后发现一些不知明的错误，如Could not build module 'Foundation'、Could not build module 'UIKit'
 *  解决：需要在.pch文件添加一句话#ifdef __OBJC__ #endif，然后将所有#import<>/#import ""都要放置到这句话的中间
 */


#import <CoreText/CoreText.h>

#import "XDSReaderGlobleConst.h"
#import "GTMNSString+HTML.h"
#import "NSString+HTML.h"
#import "XDSReaderUtil.h"
#import "XDSReadConfig.h"

#import "XDSNoteModel.h"
#import "XDSMarkModel.h"
#import "XDSChapterModel.h"
#import "XDSRecordModel.h"
#import "XDSBookModel.h"

#import "XDSReadOperation.h"

#import "XDSMagnifierView.h"
#import "XDSReadView.h"
#import "XDSReaderDelegate.h"

#import "XDSReadViewController.h"
#import "XDSReadPageViewController.h"
#import "XDSReadManager.h"

#import "DTCoreText.h"

#endif /* XDSReaderHeader_h */
