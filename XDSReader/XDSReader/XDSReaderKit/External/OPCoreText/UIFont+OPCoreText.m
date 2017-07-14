//
//  UIFont+OPCoreText.m
//  OPCoreText
//
//  Created by Brandon Williams on 4/8/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "UIFont+OPCoreText.h"

@implementation UIFont (OPCoreText)

+(id) fontWithFontRef:(CTFontRef)fontRef {
    
    CFStringRef fontName = CTFontCopyFullName(fontRef);
    CGFloat fontSize = CTFontGetSize(fontRef);
    UIFont *retVal = [UIFont fontWithName:(__bridge NSString*)fontName size:fontSize];
    CFRelease(fontName);
    return retVal;
}

-(CTFontRef) createFontRef {
    return CTFontCreateWithName((__bridge CFStringRef)[self fontName], [self pointSize], NULL);
}

@end
