//
//  NSDictionary+OPCoreText.m
//  OPCoreText
//
//  Created by Brandon Williams on 4/8/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "NSDictionary+OPCoreText.h"

@implementation NSDictionary (OPCoreText)

-(id) initWithParagraphStyleRef:(CTParagraphStyleRef)paragraphStyleRef {
    
    NSMutableDictionary *paragraphDictionary = [NSMutableDictionary new];
    
#define SPECIFIER_VALUE(datatype, specifier, container) {\
datatype container; \
CTParagraphStyleGetValueForSpecifier(paragraphStyleRef, specifier, sizeof(datatype), &container); \
[paragraphDictionary setObject:sizeof(datatype)==sizeof(CGFloat) ? [NSNumber numberWithFloat:container] : [NSNumber numberWithInt:container] forKey:[NSNumber numberWithInt:specifier]]; \
}
    SPECIFIER_VALUE(uint8_t, kCTParagraphStyleSpecifierAlignment, alignment);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierFirstLineHeadIndent, firstLineHeadIndent);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierHeadIndent, headIndent);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierTailIndent, tailIndent);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierDefaultTabInterval, defaultTabInterval);
    SPECIFIER_VALUE(uint8_t, kCTParagraphStyleSpecifierLineBreakMode, linebreakMode);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierLineHeightMultiple, lineHeightMultiple);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierMaximumLineHeight, maximumLineHeight);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierMinimumLineHeight, minimumLineHeight);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierLineSpacing, lineSpacing);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierParagraphSpacing, paragraphSpacing);
    SPECIFIER_VALUE(CGFloat, kCTParagraphStyleSpecifierParagraphSpacingBefore, paragraphSpacingBefore);
    SPECIFIER_VALUE(int8_t,  kCTParagraphStyleSpecifierBaseWritingDirection, baseWritingDirection);
    
    return [self initWithDictionary:paragraphDictionary];
}

-(CTParagraphStyleRef) createParagraphStyleRef {
    
    CTParagraphStyleSetting settings[[self count]];
    int settingIndex = 0;
    
#define PARAGRAPH_SETTING(datatype, specifier, container) \
datatype container; \
if ([self objectForKey:[NSNumber numberWithInt:specifier]]) { \
    container = sizeof(datatype) == sizeof(CGFloat) ? [[self objectForKey:[NSNumber numberWithInt:specifier]] floatValue] : [[self objectForKey:[NSNumber numberWithInt:specifier]] intValue]; \
    settings[settingIndex].spec = specifier; \
    settings[settingIndex].valueSize = sizeof(datatype); \
    settings[settingIndex].value = &container; \
    settingIndex++; \
} \

    PARAGRAPH_SETTING(uint8_t, kCTParagraphStyleSpecifierAlignment, alignment);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierFirstLineHeadIndent, firstLineHeadIndent);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierHeadIndent, headIndent);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierTailIndent, tailIndent);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierDefaultTabInterval, defaultTabInterval);
    PARAGRAPH_SETTING(uint8_t, kCTParagraphStyleSpecifierLineBreakMode, linebreakMode);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierLineHeightMultiple, lineHeightMultiple);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierMaximumLineHeight, maximumLineHeight);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierMinimumLineHeight, minimumLineHeight);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierLineSpacing, lineSpacing);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierParagraphSpacing, paragraphSpacing);
    PARAGRAPH_SETTING(CGFloat, kCTParagraphStyleSpecifierParagraphSpacingBefore, paragraphSpacingBefore);
    PARAGRAPH_SETTING(int8_t,  kCTParagraphStyleSpecifierBaseWritingDirection, baseWritingDirection);
    
    CTParagraphStyleRef paragraphStyleRef = CTParagraphStyleCreate(settings, [self count]);
    
    return paragraphStyleRef;
}

-(id) initWithFontRef:(CTFontRef)fontRef {
    
    NSDictionary *fontDictionary = nil;
    CTFontDescriptorRef descriptorRef = CTFontCopyFontDescriptor(fontRef);
    CFDictionaryRef attributesRef = CTFontDescriptorCopyAttributes(descriptorRef);
    fontDictionary = (__bridge_transfer NSDictionary*)attributesRef;
    CFRelease(descriptorRef);
    
    return [self initWithDictionary:fontDictionary];
}

-(CTFontRef) createFontRef {
    
    CTFontRef retVal = NULL;
    CTFontDescriptorRef descriptorRef = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)self);
    retVal = CTFontCreateWithFontDescriptor(descriptorRef, 0.0f, NULL);
    CFRelease(descriptorRef);
    return retVal;
}

@end
