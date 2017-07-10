//
//  LPPChapterModel.h
//  XDSReader
//
//  Created by dusheng.xu on 06/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPChapterModel : NSObject

@property (nonatomic, readonly) NSAttributedString *chapterAttributeContent;//全章的富文本
@property (nonatomic, readonly) NSString *chapterContent;//全章的out文本
@property (nonatomic, readonly) NSArray *pageAttributeStrings;//每一页的富文本
@property (nonatomic, readonly) NSArray *pageStrings;//每一页的普通文本
@property (nonatomic, readonly) NSArray *pageLocations;//每一页在章节中的位置

-(void)paginateEpubWithBounds:(CGRect)bounds;

@end
