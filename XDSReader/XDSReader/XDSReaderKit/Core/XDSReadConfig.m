//
//  XDSReadConfig.m
//  XDSReader
//
//  Created by dusheng.xu on 2017/6/15.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "XDSReadConfig.h"

@implementation XDSReadConfig

NSString *const kReadConfigEncodeKey = @"ReadConfig";
NSString *const kReadConfigFontSizeEncodeKey = @"fontSize";
NSString *const kReadConfigFontNameEncodeKey = @"fontName";
NSString *const kReadConfigLineSpaceEncodeKey = @"lineSpace";
NSString *const kReadConfigTextColorEncodeKey = @"textColor";
NSString *const kReadConfigThemeEncodeKey = @"theme";



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
            [config addObserver:config forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"fontName" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:NULL];
            [config addObserver:config forKeyPath:@"theme" options:NSKeyValueObservingOptionNew context:NULL];
            return config;
        }
        _lineSpace = 10.0f;
        _fontSize = 14.0f;
        _fontName = @"";
        _textColor = [UIColor blackColor];
        _theme = [UIColor whiteColor];
        [self addObserver:self forKeyPath:@"fontSize" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"fontName" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"lineSpace" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"theme" options:NSKeyValueObservingOptionNew context:NULL];
        [XDSReadConfig updateLocalConfig:self];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    [XDSReadConfig updateLocalConfig:self];
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
    [aCoder encodeDouble:self.fontSize forKey:kReadConfigFontSizeEncodeKey];
    [aCoder encodeObject:self.fontName forKey:kReadConfigFontNameEncodeKey];
    [aCoder encodeDouble:self.lineSpace forKey:kReadConfigLineSpaceEncodeKey];
    [aCoder encodeObject:self.textColor forKey:kReadConfigTextColorEncodeKey];
    [aCoder encodeObject:self.theme forKey:kReadConfigThemeEncodeKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.fontSize = [aDecoder decodeDoubleForKey:kReadConfigFontSizeEncodeKey];
        self.fontName = [aDecoder decodeObjectForKey:kReadConfigFontNameEncodeKey];
        self.lineSpace = [aDecoder decodeDoubleForKey:kReadConfigLineSpaceEncodeKey];
        self.textColor = [aDecoder decodeObjectForKey:kReadConfigTextColorEncodeKey];
        self.theme = [aDecoder decodeObjectForKey:kReadConfigThemeEncodeKey];
    }
    return self;
}

- (void)setFontName:(NSString *)fontName{
    if (fontName.length < 1) {
        _fontName = @"";
        return;
    }
    _fontName = fontName;
}

@end
