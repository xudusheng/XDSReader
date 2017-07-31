//
//  XDSReadConfig.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadConfig.h"

@interface XDSReadConfig ()

@property (nonatomic, assign) CGFloat cachefontSize;
@property (nonatomic, copy) NSString *cacheFontName;
@property (nonatomic) CGFloat cacheLineSpace;
@property (nonatomic,strong) UIColor *cacheTextColor;
@property (nonatomic,strong) UIColor *cacheTheme;

@end
@implementation XDSReadConfig

NSString *const kReadConfigEncodeKey = @"ReadConfig";
NSString *const kReadConfigFontSizeEncodeKey = @"cacheFontSize";
NSString *const kReadConfigFontNameEncodeKey = @"cacheFontName";
NSString *const kReadConfigLineSpaceEncodeKey = @"cacheLineSpace";
NSString *const kReadConfigTextColorEncodeKey = @"cacheTextColor";
NSString *const kReadConfigThemeEncodeKey = @"cacheTheme";


+ (instancetype)shareInstance{
    static XDSReadConfig *readConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        readConfig = [[self alloc] init];
    });
    return readConfig;
}

- (instancetype)init{
    if (self = [super init]) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kReadConfigEncodeKey];
        if (data) {
            NSKeyedUnarchiver *unarchive = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
            XDSReadConfig *config = [unarchive decodeObjectForKey:kReadConfigEncodeKey];
            return config;
        }
        self.cachefontSize = kXDSReadViewDefaultFontSize;
        self.cacheFontName = @"";
        self.cacheLineSpace = 10.0f;
        self.cacheTextColor = [UIColor blackColor];
        self.cacheTheme = [UIColor whiteColor];
        [XDSReadConfig updateLocalConfig:self];
        
    }
    return self;
}
+ (void)updateLocalConfig:(XDSReadConfig *)config{
    NSMutableData *data=[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:config forKey:kReadConfigEncodeKey];
    [archiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kReadConfigEncodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:self.cachefontSize forKey:kReadConfigFontSizeEncodeKey];
    [aCoder encodeObject:self.cacheFontName forKey:kReadConfigFontNameEncodeKey];
    [aCoder encodeDouble:self.cacheLineSpace forKey:kReadConfigLineSpaceEncodeKey];
    [aCoder encodeObject:self.cacheTextColor forKey:kReadConfigTextColorEncodeKey];
    [aCoder encodeObject:self.cacheTheme forKey:kReadConfigThemeEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.cachefontSize = [aDecoder decodeDoubleForKey:kReadConfigFontSizeEncodeKey];
        self.cacheFontName = [aDecoder decodeObjectForKey:kReadConfigFontNameEncodeKey];
        self.cacheLineSpace = [aDecoder decodeDoubleForKey:kReadConfigLineSpaceEncodeKey];
        self.cacheTextColor = [aDecoder decodeObjectForKey:kReadConfigTextColorEncodeKey];
        self.cacheTheme = [aDecoder decodeObjectForKey:kReadConfigThemeEncodeKey];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    XDSReadConfig *config = [[XDSReadConfig alloc] init];
    config.cachefontSize = self.cachefontSize;
    config.cacheFontName = self.cacheFontName;
    config.cacheLineSpace = self.cacheLineSpace;
    config.cacheTextColor = self.cacheTextColor;
    config.cacheTheme = self.cacheTheme;
    
    config.currentFontSize = self.currentFontSize;
    config.currentFontName = self.currentFontName;
    config.currentLineSpace = self.currentLineSpace;
    config.currentTextColor = self.currentTextColor;
    config.currentTheme = self.currentTheme;
    return config;
}

- (void)setCacheFontName:(NSString *)cacheFontName{
    if (cacheFontName.length < 1) {
        _cacheFontName = @"";
        return;
    }
    _cacheFontName = cacheFontName;
}



- (BOOL)isReadConfigChanged {
    BOOL isReadConfigNotChanged = (_cachefontSize == _currentFontSize &&
                                   _cacheFontName == _currentFontName &&
                                   _cacheLineSpace == _currentLineSpace &&
                                   _cacheTextColor == _currentTextColor &&
                                   _cacheTheme == _currentTheme);
    if (!isReadConfigNotChanged) {
        _currentFontSize>0?(_cachefontSize = _currentFontSize):0;
        _currentFontName?(_cacheFontName = _currentFontName):0;
        _currentLineSpace>0?(_cacheLineSpace = _currentLineSpace):0;
        _currentTextColor?(_cacheTextColor = _currentTextColor):0;
        _currentTheme?(_cacheTheme = _currentTheme):0;
        [XDSReadConfig updateLocalConfig:self];
    }
    
    _currentFontSize = _cachefontSize;
    _currentFontName = _cacheFontName;
    _currentLineSpace = _cacheLineSpace;
    _currentTextColor = _cacheTextColor;
    _currentTheme = _cacheTheme;
    
    return !isReadConfigNotChanged;
}




- (BOOL)isEqual:(XDSReadConfig *)config {
    return (self.cachefontSize == config.cachefontSize &&
            self.cacheFontName == config.cacheFontName &&
            self.cacheTextColor == config.cacheTextColor &&
            self.cacheLineSpace == config.cacheLineSpace &&
            self.cacheTheme == config.cacheTheme &&
            
            self.currentFontSize == config.currentFontSize &&
            self.currentFontName == config.currentFontName &&
            self.currentTextColor == config.currentTextColor &&
            self.currentLineSpace == config.currentLineSpace &&
            self.currentTheme == config.currentTheme);
}
@end
