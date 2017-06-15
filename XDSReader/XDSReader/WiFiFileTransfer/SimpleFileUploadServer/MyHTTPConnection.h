
#import "HTTPConnection.h"
#define kDownloadProcessBodyDataNotificationName  @"downloadProcessBodyDataNotificationName"//下载文件内容是发出通知  许杜生添加 2015.12.22
#define kGetContentLengthNotificationName  @"prepareForBodyWithSizeNotificationName"//捕获到新文件时发出通知  许杜生添加 2015.12.22

@class MultipartFormDataParser;

@interface MyHTTPConnection : HTTPConnection  {
    MultipartFormDataParser*        parser;
	NSFileHandle*					storeFile;
	NSMutableArray*					uploadedFiles;
}



@end
