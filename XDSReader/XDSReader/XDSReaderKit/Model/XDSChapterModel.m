//
//  XDSChapterModel.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSChapterModel.h"
@implementation XDSImageModel
@end


@interface XDSChapterModel()

@property (nonatomic,strong) NSMutableArray *pageArray;

@end

@implementation XDSChapterModel
NSString *const kChapterModelComtentEncodeKey = @"content";
NSString *const kChapterModelTitlEncodeKey = @"title";
NSString *const kChapterModelPageCountEncodeKey = @"pageCount";
NSString *const kChapterModelPageArrayEncodeKey = @"pageArray";
NSString *const kChapterModelBookTypeEncodeKey = @"bookType";
NSString *const kChapterModelEpubImagePathEncodeKey = @"epubImagePath";
NSString *const kChapterModelEpubContentEncodeKey = @"epubContent";
NSString *const kChapterModelChapterpathEncodeKey = @"chapterpath";
NSString *const kChapterModelHtmlEncodeKey = @"html";
NSString *const kChapterModelEpubStringEncodeKey = @"epubString";


- (instancetype)init{
    if (self = [super init]) {
        _pageArray = [NSMutableArray array];
    }
    return self;
}

+(id)chapterWithEpub:(NSString *)chapterpath//章节路径
               title:(NSString *)title//章节标题
           imagePath:(NSString *)path{//图片路径
    XDSChapterModel *model = [[XDSChapterModel alloc] init];
    model.title = title;
    model.epubImagePath = path;
    model.bookType = XDSEBookTypeEpub;
    model.chapterpath = chapterpath;
    NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:chapterpath]] encoding:NSUTF8StringEncoding];
    model.html = html;
    model.content = [html stringByConvertingHTMLToPlainText];
    [model parserEpubToDictionary];
    CGRect rect = CGRectMake(0,
                             0,
                             DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight,
                             DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom);
    [model paginateEpubWithBounds:rect];
    return model;
}

-(void)parserEpubToDictionary
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSScanner *scanner = [NSScanner scannerWithString:self.content];
    NSMutableString *newString = [[NSMutableString alloc] init];
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            NSString *imageString = [self.epubImagePath stringByAppendingPathComponent:img];
            UIImage *image = [UIImage imageWithContentsOfFile:imageString];
            CGSize size = CGSizeMake((DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight),
                                     (DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight)/(DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom)*image.size.width);
            if (size.height>(DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom-20)) {
                size.height = DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom-20
                ;
            }
            [array addObject:@{@"type":@"img",@"content":imageString?imageString:@"",@"width":@(size.width),@"height":@(size.height)}];
            //存储图片信息
            XDSImageModel *imageData = [[XDSImageModel alloc] init];
            imageData.url = imageString?imageString:@"";
            imageData.position = newString.length;
            //            imageData.imageRect = CGRectMake(0, 0, size.width, size.height);
            [imageArray addObject:imageData];
            
            //            [newString appendString:@" "];
            [scanner scanString:@"</img>" intoString:NULL];
        }
        else{
            NSString *content;
            if ([scanner scanUpToString:@"<img>" intoString:&content]) {
                [array addObject:@{@"type":@"txt",@"content":content?content:@""}];
                [newString appendString:content?content:@""];
            }
        }
    }
    self.epubContent = [array copy];
    self.imageArray = [imageArray copy];
    //    self.content = [newString copy];
}
-(void)paginateEpubWithBounds:(CGRect)bounds
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dic in _epubContent) {
        if ([dic[@"type"] isEqualToString:@"txt"]) {
            //解析文本
            NSLog(@"--%.2f",[XDSReadConfig shareInstance].fontSize);
            NSDictionary *attr = [XDSReadParser parserAttribute:[XDSReadConfig shareInstance]];
            NSMutableAttributedString *subString = [[NSMutableAttributedString alloc] initWithString:dic[@"content"] attributes:attr];
            [attrString appendAttributedString:subString];
        }
        else if ([dic[@"type"] isEqualToString:@"img"]){
            //解析图片
            NSAttributedString *subString = [XDSReadParser parserEpubImageWithSize:dic config:[XDSReadConfig shareInstance]];
            [attrString appendAttributedString:subString];
            
        }
    }
    CTFramesetterRef setterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, NULL);
    CFRange rang1 = CTFrameGetVisibleStringRange(frameRef);
    CFRange rang2 = CTFrameGetStringRange(frameRef);
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *stringArr = [NSMutableArray array];
    if (rang1.length+rang1.location == rang2.location+rang2.length) {
        CTFrameRef subFrameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(rang1.location,0), pathRef, NULL);
        CFRange range = CTFrameGetVisibleStringRange(subFrameRef);
        rang1 = CFRangeMake(range.location+range.length, 0);
        [array addObject:(__bridge id)subFrameRef];
        [stringArr addObject:[[attrString string] substringWithRange:NSMakeRange(range.location, range.length)]];
        
        CFRelease(subFrameRef);
    }
    else{
        while (rang1.length+rang1.location<rang2.location+rang2.length) {
            CTFrameRef subFrameRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(rang1.location,0), pathRef, NULL);
            CFRange range = CTFrameGetVisibleStringRange(subFrameRef);
            rang1 = CFRangeMake(range.location+range.length, 0);
            [array addObject:(__bridge id)subFrameRef];
            [stringArr addObject:[[attrString string] substringWithRange:NSMakeRange(range.location, range.length)]];
            CFRelease(subFrameRef);
            
        }
    }
    
    CFRelease(setterRef);
    CFRelease(pathRef);
    _epubframeRef = [array copy];
    _epubString = [stringArr copy];
    _pageCount = _epubframeRef.count;
    _content = attrString.string;
}
-(void)setContent:(NSString *)content{
    _content = content;
    if (XDSEBookTypeTxt == _bookType) {
        CGRect rect = CGRectMake(kReadViewMarginLeft,
                                 kReadViewMarginTop,
                                 DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight,
                                 DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom);
        [self paginateWithBounds:rect];
    }
    
}
-(void)updateFont{
    CGRect rect = CGRectMake(kReadViewMarginLeft,
                             kReadViewMarginTop,
                             DEVICE_MAIN_SCREEN_WIDTH_XDSR-kReadViewMarginLeft-kReadViewMarginRight,
                             DEVICE_MAIN_SCREEN_HEIGHT_XDSR-kReadViewMarginTop-kReadViewMarginBottom);
    
    if (XDSEBookTypeEpub == _bookType) {
        rect.origin = (CGPoint){0,0};
    }else{}
    
    [self paginateWithBounds:rect];
}
-(void)paginateWithBounds:(CGRect)bounds
{
    [_pageArray removeAllObjects];
    NSAttributedString *attrString;
    CTFramesetterRef frameSetter;
    CGPathRef path;
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString  alloc] initWithString:self.content];
    NSDictionary *attribute = [XDSReadParser parserAttribute:[XDSReadConfig shareInstance]];
    [attrStr setAttributes:attribute range:NSMakeRange(0, attrString.length)];
    attrString = [attrStr copy];
    frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
    path = CGPathCreateWithRect(bounds, NULL);
    int currentOffset = 0;
    int currentInnerOffset = 0;
    BOOL hasMorePages = YES;
    // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
    int preventDeadLoopSign = currentOffset;
    int samePlaceRepeatCount = 0;
    
    while (hasMorePages) {
        if (preventDeadLoopSign == currentOffset) {
            
            ++samePlaceRepeatCount;
            
        }else {
            
            samePlaceRepeatCount = 0;
        }
        
        if (samePlaceRepeatCount > 1) {
            // 退出循环前检查一下最后一页是否已经加上
            if (_pageArray.count == 0) {
                [_pageArray addObject:@(currentOffset)];
            }
            else {
                
                NSUInteger lastOffset = [[_pageArray lastObject] integerValue];
                
                if (lastOffset != currentOffset) {
                    [_pageArray addObject:@(currentOffset)];
                }
            }
            break;
        }
        
        [_pageArray addObject:@(currentOffset)];
        
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frame);
        
        if ((range.location + range.length) != attrString.length) {
            
            currentOffset += range.length;
            currentInnerOffset += range.length;
            
        } else {
            // 已经分完，提示跳出循环
            hasMorePages = NO;
        }
        if (frame) CFRelease(frame);
    }
    
    CGPathRelease(path);
    CFRelease(frameSetter);
    _pageCount = _pageArray.count;
}
-(NSString *)stringOfPage:(NSUInteger)index{
    NSUInteger local = [_pageArray[index] integerValue];
    NSUInteger length;
    if (index<self.pageCount-1) {
        length=  [_pageArray[index+1] integerValue] - [_pageArray[index] integerValue];
    }
    else{
        length = _content.length - [_pageArray[index] integerValue];
    }
    return [_content substringWithRange:NSMakeRange(local, length)];
}
-(id)copyWithZone:(NSZone *)zone{
    XDSChapterModel *model = [[XDSChapterModel allocWithZone:zone] init];
    model.content = self.content;
    model.title = self.title;
    model.pageCount = self.pageCount;
    model.pageArray = self.pageArray;
    model.epubImagePath = self.epubImagePath;
    model.bookType = self.bookType;
    model.epubString = self.epubString;
    return model;
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.content forKey:kChapterModelComtentEncodeKey];
    [aCoder encodeObject:self.title forKey:kChapterModelTitlEncodeKey];
    [aCoder encodeInteger:self.pageCount forKey:kChapterModelPageCountEncodeKey];
    [aCoder encodeObject:self.pageArray forKey:kChapterModelPageArrayEncodeKey];
    [aCoder encodeObject:self.epubImagePath forKey:kChapterModelEpubImagePathEncodeKey];
    [aCoder encodeObject:@(self.bookType) forKey:kChapterModelBookTypeEncodeKey];
    [aCoder encodeObject:self.epubContent forKey:kChapterModelEpubContentEncodeKey];
    [aCoder encodeObject:self.chapterpath forKey:kChapterModelChapterpathEncodeKey];
    [aCoder encodeObject:self.html forKey:kChapterModelHtmlEncodeKey];
    [aCoder encodeObject:self.epubString forKey:kChapterModelEpubStringEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _content = [aDecoder decodeObjectForKey:kChapterModelComtentEncodeKey];
        self.title = [aDecoder decodeObjectForKey:kChapterModelTitlEncodeKey];
        self.pageCount = [aDecoder decodeIntegerForKey:kChapterModelPageCountEncodeKey];
        self.pageArray = [aDecoder decodeObjectForKey:kChapterModelPageArrayEncodeKey];
        self.epubImagePath = [aDecoder decodeObjectForKey:kChapterModelEpubImagePathEncodeKey];
        self.bookType = [[aDecoder decodeObjectForKey:kChapterModelBookTypeEncodeKey] integerValue];
        self.epubContent = [aDecoder decodeObjectForKey:kChapterModelEpubContentEncodeKey];
        self.chapterpath = [aDecoder decodeObjectForKey:kChapterModelChapterpathEncodeKey];
        self.html = [aDecoder decodeObjectForKey:kChapterModelHtmlEncodeKey];
        self.epubString = [aDecoder decodeObjectForKey:kChapterModelEpubStringEncodeKey];
    }
    return self;
}

@end
