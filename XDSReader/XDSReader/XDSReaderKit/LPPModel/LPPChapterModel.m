//
//  LPPChapterModel.m
//  XDSReader
//
//  Created by dusheng.xu on 06/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "LPPChapterModel.h"

@interface LPPChapterModel ()

@property (nonatomic, copy) NSAttributedString *chapterAttributeContent;//全章的富文本
@property (nonatomic, copy) NSString *chapterContent;//全章的out文本
@property (nonatomic, copy) NSArray *pageAttributeStrings;//每一页的富文本
@property (nonatomic, copy) NSArray *pageStrings;//每一页的普通文本
@property (nonatomic, copy) NSArray *pageLocations;//每一页在章节中的位置

@property (assign, nonatomic) CGRect showBounds;
@end
@implementation LPPChapterModel

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
}

- (void)getFrame:(CTFrameRef)subFrameRef{
    NSArray *lines = (NSArray *)CTFrameGetLines(subFrameRef);
    for (int i = 0; i < lines.count; ++i) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        
        CGRect frame = CTLineGetBoundsWithOptions(line, kCTLineBoundsExcludeTypographicLeading);
        NSLog(@"========%@", NSStringFromCGRect(frame));
    }}

- (NSAttributedString *)attributedStringForSnippet{
    NSString *fileName = @"part0005.html";
//    // Load HTML data
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSLog(@"path = %@", readmePath);
    NSString *html = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:NULL];
    html = [html stringByReplacingOccurrencesOfString:@"../images/" withString:@""];

    
//    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"mdjyml" withExtension:@"txt"];
//    NSString *readmePath = fileURL.absoluteString;
//    NSString *html = [XDSReaderUtil encodeWithURL:fileURL];

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
    
    NSDictionary *dic = @{NSTextSizeMultiplierDocumentOption:[NSNumber numberWithFloat:1.5],
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

@end
