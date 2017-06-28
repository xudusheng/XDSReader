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
    NSArray* itemsArray = [document nodesForXPath:@"//opf:item" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    //opf文件的命名空间 xmlns="http://www.idpf.org/2007/opf" 需要取到某个节点设置命名空间的键为opf 用opf:节点来获取节点
    NSString *ncxFile;
    NSMutableDictionary* itemDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray){
        [itemDictionary setValue:[[element attributeForName:@"href"] stringValue] forKey:[[element attributeForName:@"id"] stringValue]];
        if([[[element attributeForName:@"media-type"] stringValue] isEqualToString:@"application/x-dtbncx+xml"]){
            ncxFile = [[element attributeForName:@"href"] stringValue]; //获取ncx文件名称 根据ncx获取书的目录
        }
    }
    
    NSString *absolutePath = [opfPath stringByDeletingLastPathComponent];
    CXMLDocument *ncxDoc = [[CXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", absolutePath,ncxFile]] options:0 error:nil];
    NSMutableDictionary* titleDictionary = [[NSMutableDictionary alloc] init];
    for (CXMLElement* element in itemsArray) {
        NSString* href = [[element attributeForName:@"href"] stringValue];
        
        NSString* xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", href];
        //根据opf文件的href获取到ncx文件中的中对应的目录名称
        NSArray* navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
        if ([navPoints count] == 0) {
            NSString *contentpath = @"//ncx:content";
            NSArray *contents = [ncxDoc nodesForXPath:contentpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
            for (CXMLElement *element in contents) {
                NSString *src = [[element attributeForName:@"src"] stringValue];
                if ([src hasPrefix:href]) {
                    xpath = [NSString stringWithFormat:@"//ncx:content[@src='%@']/../ncx:navLabel/ncx:text", src];
                    navPoints = [ncxDoc nodesForXPath:xpath namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.daisy.org/z3986/2005/ncx/" forKey:@"ncx"] error:nil];
                    break;
                }
            }
        }
        
        if([navPoints count]!=0){
            CXMLElement* titleElement = navPoints.firstObject;
            [titleDictionary setValue:[titleElement stringValue] forKey:href];
        }
    }
    
    NSString *chapterRelativeFolder = [opfRelativePath stringByDeletingLastPathComponent];
    NSArray* itemRefsArray = [document nodesForXPath:@"//opf:itemref" namespaceMappings:[NSDictionary dictionaryWithObject:@"http://www.idpf.org/2007/opf" forKey:@"opf"] error:nil];
    NSMutableArray *chapters = [NSMutableArray array];
    for (CXMLElement* element in itemRefsArray){
        NSString* chapHref = [itemDictionary valueForKey:[[element attributeForName:@"idref"] stringValue]];

        XDSChapterModel *model = [XDSChapterModel chapterWithEpub:[NSString stringWithFormat:@"%@/%@",chapterRelativeFolder,chapHref]
                                                            title:[titleDictionary valueForKey:chapHref]
                                                        imagePath:[[[opfRelativePath stringByDeletingLastPathComponent]stringByAppendingPathComponent:chapHref] stringByDeletingLastPathComponent]];
        [chapters addObject:model];
        
    }
    return chapters;
}

@end
