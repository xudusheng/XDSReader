//
//  XDSReadOperation.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadOperation.h"
#import "ZipArchive.h"
#import "TouchXML.h"

@implementation XDSReadOperation

+ (void)separateChapter:(NSMutableArray **)chapters content:(NSString *)content {

    [*chapters removeAllObjects];
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray* match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    
    if (match.count != 0){
        __block NSRange lastRange = NSMakeRange(0, 0);
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [obj range];
            NSInteger local = range.location;
            if (idx == 0) {
                XDSChapterModel *model = [[XDSChapterModel alloc] init];
                model.title = @"开始";
                NSUInteger len = local;
                model.content = [content substringWithRange:NSMakeRange(0, len)];
                [*chapters addObject:model];
                
            }
            if (idx > 0 ) {
                XDSChapterModel *model = [[XDSChapterModel alloc] init];
                model.title = [content substringWithRange:lastRange];
                NSUInteger len = local-lastRange.location;
                model.content = [content substringWithRange:NSMakeRange(lastRange.location, len)];
                [*chapters addObject:model];
                
            }
            if (idx == match.count-1) {
                XDSChapterModel *model = [[XDSChapterModel alloc] init];
                model.title = [content substringWithRange:range];
                model.content = [content substringWithRange:NSMakeRange(local, content.length-local)];
                [*chapters addObject:model];
            }
            lastRange = range;
        }];
    }else{
        XDSChapterModel *model = [[XDSChapterModel alloc] init];
        model.content = content;
        [*chapters addObject:model];
    }
    
}

+ (UIButton *)commonButtonSEL:(SEL)sel target:(id)target{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - ePub处理
+ (NSMutableArray *)ePubFileHandle:(NSString *)path{
    //解压epub文件并返回解压文件夹的相对路径(根路径为document路径)
    NSString *ePubPath = [self unZip:path];
    if (!ePubPath) {
        return nil;
    }
    
    //获取opf文件的相对路径
    NSString *OPFPath = [self OPFPath:ePubPath];
    return [self parseOPF:OPFPath];
    
}
#pragma mark - 解压文件路径(相对路径)
+ (NSString *)unZip:(NSString *)path{
    ZipArchive *zip = [[ZipArchive alloc] init];
    
    if ([zip UnzipOpenFile:path]) {
        //相对路径
        NSString *zipFile_relativePath = [[path stringByDeletingPathExtension] lastPathComponent];
        zipFile_relativePath = [EPUB_EXTRACTION_FOLDER stringByAppendingString:zipFile_relativePath];
        zipFile_relativePath = [@"/" stringByAppendingString:zipFile_relativePath];
        //完整路径
        NSString *zipPath_fullPath = [APP_SANDBOX_DOCUMENT_PATH stringByAppendingString:zipFile_relativePath];
        NSFileManager *filemanager=[[NSFileManager alloc] init];
        if ([filemanager fileExistsAtPath:zipPath_fullPath]) {
            NSError *error;
            [filemanager removeItemAtPath:zipPath_fullPath error:&error];
        }
        if ([zip UnzipFileTo:[NSString stringWithFormat:@"%@/",zipPath_fullPath] overWrite:YES]) {
            return zipFile_relativePath;
        }
    }
    return nil;
}
#pragma mark - OPF文件路径
+ (NSString *)OPFPath:(NSString *)epubPath{
    NSString *epubExtractionFolderFullPath = [APP_SANDBOX_DOCUMENT_PATH stringByAppendingString:epubPath];
    NSString *containerPath = [epubExtractionFolderFullPath stringByAppendingString:@"/META-INF/container.xml"];
    //container.xml文件路径 通过container.xml获取到opf文件的路径
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:containerPath]) {
        CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:containerPath] options:0 error:nil];
        CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
        // xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
        NSString *path = [NSString stringWithFormat:@"%@/%@",epubPath,[opfPath stringValue]];
        return path;
    } else {
        NSLog(@"ERROR: ePub not Valid");
        return nil;
    }
    
}
#pragma mark - 图片的相对路径
//+(NSString *)ePubImageRelatePath:(NSString *)epubPath
//{
//    NSString *containerPath = [NSString stringWithFormat:@"%@/META-INF/container.xml",epubPath];
//    //container.xml文件路径 通过container.xml获取到opf文件的路径
//    NSFileManager *fileManager = [[NSFileManager alloc] init];
//    if ([fileManager fileExistsAtPath:containerPath]) {
//        CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:containerPath] options:0 error:nil];
//        CXMLNode* opfPath = [document nodeForXPath:@"//@full-path" error:nil];
//        // xml文件中获取full-path属性的节点  full-path的属性值就是opf文件的绝对路径
//        NSString *path = [NSString stringWithFormat:@"%@/%@",epubPath,[opfPath stringValue]];
//        return [path stringByDeletingLastPathComponent];
//    } else {
//        NSLog(@"ERROR: ePub not Valid");
//        return nil;
//    }
//}
#pragma mark - 解析OPF文件
+ (NSMutableArray *)parseOPF:(NSString *)opfRelativePath{
    NSString *opfPath = [APP_SANDBOX_DOCUMENT_PATH stringByAppendingString:opfRelativePath];
    CXMLDocument* document = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opfPath] options:0 error:nil];
    
    
//    <title>:题名
//    <creator>：责任者
//    <subject>：主题词或关键词
//    <description>：内容描述
//    <contributor>：贡献者或其它次要责任者
//    <date>：日期
//    <type>：类型
//    <format>：格式
//    <identifier>：标识符
//    <source>：来源
//    <language>：语种
//    <relation>：相关信息
//    <coverage>：履盖范围
//    <rights>：权限描述
//    <x-metadata>，即扩展元素。如果有些信息在上述元素中无法描述，则在此元素中进行扩展。

    NSString *title = [self readDCValueFromOPFForKey:@"title" document:document];
    NSString *creator = [self readDCValueFromOPFForKey:@"creator" document:document];
    NSString *subject = [self readDCValueFromOPFForKey:@"subject" document:document];
    NSString *description = [self readDCValueFromOPFForKey:@"description" document:document];
    NSString *date = [self readDCValueFromOPFForKey:@"date" document:document];
    NSString *type = [self readDCValueFromOPFForKey:@"type" document:document];
    NSString *format = [self readDCValueFromOPFForKey:@"format" document:document];
    NSString *identifier = [self readDCValueFromOPFForKey:@"identifier" document:document];
    NSString *source = [self readDCValueFromOPFForKey:@"source" document:document];
    NSString *relation = [self readDCValueFromOPFForKey:@"relation" document:document];
    NSString *coverage = [self readDCValueFromOPFForKey:@"coverage" document:document];
    NSString *rights = [self readDCValueFromOPFForKey:@"rights" document:document];
    
    NSString *cover = [self readCoverImage:document];
    
    
    CXMLElement *element = (CXMLElement *)[document nodeForXPath:@"//opf:item[@media-type='application/x-dtbncx+xml']" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    //opf文件的命名空间 xmlns="http://www.idpf.org/2007/opf" 需要取到某个节点设置命名空间的键为opf 用opf:节点来获取节点
    NSString *ncxFile;
    if (element) {
        ncxFile = [[element attributeForName:@"href"] stringValue];//获取ncx文件名称 根据ncx获取书的目录
    }
    
//    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
//    for (CXMLElement* element in itemsArray){
//        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
//        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
//            ncxFile = [[element attributeForName:@"href"] stringValue]; //获取ncx文件名称 根据ncx获取书的目录
//            break;
//        }
//    }
    
    NSString *absolutePath = [opfPath stringByDeletingLastPathComponent];
    CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", absolutePath,ncxFile]] options:0 error:nil];
    
    NSString *xpath = @"//ncx:content[@src]/../ncx:navLabel/ncx:text";
    xpath = @"//ncx:navPoint";
    //根据opf文件的href获取到ncx文件中的中对应的目录名称
    NSArray *navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
    
    NSMutableArray *chapters = [NSMutableArray arrayWithCapacity:0];
    for (CXMLElement *element in navPoints) {
        NSArray *navLabels = [element elementsForName:@"navLabel"];
        NSArray *contents = [element elementsForName:@"content"];
        if (!navLabels.count || !contents) {
            continue;
        }
        CXMLElement *navLabel = navLabels.firstObject;;
        CXMLElement *content = contents.firstObject;
        
        NSArray *texts = [navLabel elementsForName:@"text"];
        
        if (!texts.count) {
            continue;
        }
        
        CXMLElement *text = texts.firstObject;
        
        NSString *chapterName = text.stringValue;//章节名称
        NSString *chapterSrc = [content attributeForName:@"src"].stringValue;//章节路径
        NSLog(@"%@ = %@", chapterName, chapterSrc);
        
        LPPChapterModel *chapter = [[LPPChapterModel alloc] init];
        chapter.chapterName = chapterName;
        chapter.chapterSrc = chapterSrc;
        
        [chapters addObject:chapter];
    }
//
//        if([navPoints count]!=0){
//            CXMLElement* titleElement = navPoints.firstObject;
//            [titleDictionary setValue:[titleElement stringValue] forKey:href];
//        }
//    }
//
//    NSString *chapterRelativeFolder = [opfRelativePath stringByDeletingLastPathComponent];
//    NSArray* itemRefsArray = [document nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
//    NSMutableArray *chapters = [NSMutableArray array];
//    for (CXMLElement* element in itemRefsArray){
//        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];
//
//        XDSChapterModel *model = [XDSChapterModel chapterWithEpub:[NSString stringWithFormat:@"%@/%@",chapterRelativeFolder,chapHref]
//                                                            title:[titleDictionary valueForKey:chapHref]
//                                                        imagePath:[[[opfRelativePath stringByDeletingLastPathComponent]stringByAppendingPathComponent:chapHref] stringByDeletingLastPathComponent]];
//        [chapters addObject:model];
//        
//    }
    return chapters;
}


+ (NSString *)readDCValueFromOPFForKey:(NSString *)key document:(CXMLDocument *)document{
    NSString *xPath = [NSString stringWithFormat:@"//dc:%@[1]",key];
    CXMLNode *node = [document nodeForXPath:xPath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://purl.org/dc/elements/1.1/" forKey:@"dc"] error:nil];
    return node?node.stringValue:nil;
}

+ (NSString *)readCoverImage:(CXMLDocument *)document{
    CXMLElement *element = (CXMLElement *)[document nodeForXPath:@"//opf:meta[@name='cover']" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    return [element attributeForName:@"content"].stringValue;
}
@end
