
#import "HTTPConnection.h"
#define kGetProcessStartOfPartWithHeaderNotificationName  @"processStartOfPartWithHeaderNotificationName"//（获取文件头信息，包含文件名称）时发出通知  许杜生添加 2016.06.25
#define kDownloadProcessBodyDataNotificationName  @"downloadProcessBodyDataNotificationName"//下载文件内容是发出通知  许杜生添加 2015.12.22
#define kGetContentLengthNotificationName  @"prepareForBodyWithSizeNotificationName"//捕获到新文件时发出通知  许杜生添加 2015.12.22


@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {
    MultipartFormDataParser*        parser;
	NSFileHandle*					storeFile;
	NSMutableArray*					uploadedFiles;
}



@end
