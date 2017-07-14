//
//  LPPChapterModel.m
//  XDSReader
//
//  Created by dusheng.xu on 06/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "LPPChapterModel.h"
#import "NSAttributedString+Encoding.h"
@interface LPPChapterModel ()

@property (nonatomic, copy) NSAttributedString *chapterAttributeContent;//全章的富文本
@property (nonatomic, copy) NSString *chapterContent;//全章的纯文本
@property (nonatomic, copy) NSArray *pageAttributeStrings;//每一页的富文本
@property (nonatomic, copy) NSArray *pageStrings;//每一页的普通文本
@property (nonatomic, copy) NSArray *pageLocations;//每一页在章节中的位置
@property (nonatomic, assign) NSInteger pageCount;//章节总页数

@property (nonatomic,copy) NSArray<XDSNoteModel *>*notes;
@property (nonatomic,copy) NSArray<XDSMarkModel *>*marks;


@property (assign, nonatomic) CGRect showBounds;
@end
@implementation LPPChapterModel

NSString *const kLPPChapterModelChapterNameEncodeKey = @"chapterName";
NSString *const kLPPChapterModelChapterSrcEncodeKey = @"chapterSrc";
NSString *const kLPPChapterModelNotesPathEncodeKey = @"notes";
NSString *const kLPPChapterModelMarksEncodeKey = @"marks";


-(void)paginateEpubWithBounds:(CGRect)bounds{
    bounds.size.height = bounds.size.height - 20;
    self.showBounds = bounds;
    // Load HTML data
    NSAttributedString *chapterAttributeContent = [self attributedStringForSnippet];

    NSMutableArray *pageAttributeStrings = [NSMutableArray arrayWithCapacity:0];//每一页的富文本
    NSMutableArray *pageStrings = [NSMutableArray arrayWithCapacity:0];//每一页的普通文本
    NSMutableArray *pageLocations = [NSMutableArray arrayWithCapacity:0];//每一页在章节中的位置
    
    DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:chapterAttributeContent];
    NSRange visibleStringRang;
    DTCoreTextLayoutFrame *visibleframe;
    NSInteger rangeOffset = 0;
    do {
        visibleframe = [layouter layoutFrameWithRect:bounds range:NSMakeRange(rangeOffset, 0)];
        visibleStringRang = [visibleframe visibleStringRange];

        [pageAttributeStrings addObject:[chapterAttributeContent attributedSubstringFromRange:NSMakeRange(visibleStringRang.location, visibleStringRang.length)]];
        [pageStrings addObject:[[chapterAttributeContent string] substringWithRange:NSMakeRange(visibleStringRang.location, visibleStringRang.length)]];
        [pageLocations addObject:@(visibleStringRang.location)];
        rangeOffset += visibleStringRang.length;

    } while (visibleStringRang.location + visibleStringRang.length < chapterAttributeContent.string.length);
    
    visibleframe = nil;
    layouter = nil;

    self.chapterAttributeContent = chapterAttributeContent;
    self.chapterContent = chapterAttributeContent.string;
    self.pageAttributeStrings = pageAttributeStrings;
    self.pageStrings = pageStrings;
    self.pageLocations = pageLocations;
    self.pageCount = self.pageLocations.count;
}


- (NSAttributedString *)attributedStringForSnippet{
    NSString *OEBPSUrl = CURRENT_BOOK_MODEL.bookBasicInfo.OEBPSUrl;
    OEBPSUrl = [APP_SANDBOX_DOCUMENT_PATH stringByAppendingString:OEBPSUrl];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", OEBPSUrl, self.chapterSrc];
//    // Load HTML data
//    NSString *readmePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSString *readmePath = fileName;
    NSLog(@"path = %@", readmePath);
    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *imagePath = [@"img src=\"" stringByAppendingString:OEBPSUrl];
    html = [html stringByReplacingOccurrencesOfString:@"img src=\".." withString:imagePath];
    html = [html stringByReplacingOccurrencesOfString:@"<p></p>" withString:@""];


    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create attributed string from HTML
    CGSize maxImageSize = CGSizeMake(_showBounds.size.width - 20.0, _showBounds.size.height - 20.0);
    
    // example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        
        // the block is being called for an entire paragraph, so we check the individual elements
        
        for (DTHTMLElement *oneChildElement in element.childNodes)
        {
            // if an element is larger than twice the font size put it in it's own block
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }
    };
    
    NSDictionary *dic = @{NSTextSizeMultiplierDocumentOption:@1.2,
                          DTDefaultLineHeightMultiplier:@1.5,
                          DTMaxImageSize:[NSValue valueWithCGSize:maxImageSize],
                          DTDefaultLinkColor:@"purple",
                          DTDefaultLinkHighlightColor:@"red",
                          DTWillFlushBlockCallBack:callBackBlock
                          };
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [options setObject:[NSURL fileURLWithPath:readmePath] forKey:NSBaseURLDocumentOption];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
    
    return string;
}


//TODO:insert a book note into chapter 向该章节中插入一条笔记
- (void)addNote:(XDSNoteModel *)noteModel{
    NSMutableArray *notes = [NSMutableArray arrayWithCapacity:0];
    if (self.notes) {
        [notes addObjectsFromArray:self.notes];
    }
    [notes addObject:noteModel];
    self.notes = notes;
}

//TODO: insert a bookmark into chapter 向该章节中插入一条书签
- (void)addOrDeleteABookmark:(XDSMarkModel *)markModel {
    NSMutableArray *marks = [NSMutableArray arrayWithCapacity:0];
    if (self.marks) {
        [marks addObjectsFromArray:self.marks];
    }
    
    if ([self isMarkAtPage:markModel.page]) { //contains mark 如果存在，移除书签信息
        for (XDSMarkModel *mark in marks) {
            if (mark.page == markModel.page) {
                [marks removeObject:mark];
            }
        }
    }else{// doesn't contain mark 记录书签信息
        [marks addObject:markModel];
    }
    self.marks = marks;
}

/*
 *  update font and get new page number from old page
 */
- (void)updateFontAndGetNewPageFromOldPage:(NSInteger *)oldPage{
    if (nil == self.chapterAttributeContent) {//如果阅读记录中的chapterModel没有内容，则先加载内容
        [self paginateEpubWithBounds:[XDSReadManager readViewBounds]];
        *oldPage = 0;
        return;
    }
    
    
}

/*
 *  does this page contains a bookMark?
 */
- (BOOL)isMarkAtPage:(NSInteger)page{
    if (page >= self.pageCount) {
        return NO;
    }
    for (XDSMarkModel *mark in self.marks) {
        if (mark.page == page) {
            return YES;
        }
    }
    return NO;
}


-(id)copyWithZone:(NSZone *)zone{
    LPPChapterModel *model = [[LPPChapterModel allocWithZone:zone] init];
    model.chapterName = self.chapterName;
    model.chapterSrc = self.chapterSrc;
    model.chapterAttributeContent = self.chapterAttributeContent;
    model.chapterContent = self.chapterContent;
    model.pageAttributeStrings = self.pageAttributeStrings;
    model.pageStrings = self.pageStrings;
    model.pageLocations = self.pageLocations;
    model.pageCount = self.pageCount;
    model.notes = self.notes;
    model.marks = self.marks;
    return model;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.chapterName forKey:kLPPChapterModelChapterNameEncodeKey];
    [aCoder encodeObject:self.chapterSrc forKey:kLPPChapterModelChapterSrcEncodeKey];
    [aCoder encodeObject:self.notes forKey:kLPPChapterModelNotesPathEncodeKey];
    [aCoder encodeObject:self.marks forKey:kLPPChapterModelMarksEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.chapterName = [aDecoder decodeObjectForKey:kLPPChapterModelChapterNameEncodeKey];
        self.chapterSrc = [aDecoder decodeObjectForKey:kLPPChapterModelChapterSrcEncodeKey];
        self.notes = [aDecoder decodeObjectForKey:kLPPChapterModelNotesPathEncodeKey];
        self.marks = [aDecoder decodeObjectForKey:kLPPChapterModelMarksEncodeKey];

    }
    return self;
}

@end
