//
//  NSAttributedString+Opetopic.m
//  NSAttributedString+Opetopic
//
//  Created by Brandon Williams on 4/6/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import "NSAttributedString+Encoding.h"
#import "NSDictionary+OPCoreText.h"

const struct NSAttributedStringArchiveKeys {
    __unsafe_unretained NSString *rootString;
    __unsafe_unretained NSString *attributes;
    __unsafe_unretained NSString *attributeDictionary;
    __unsafe_unretained NSString *attributeRange;
} NSAttributedStringArchiveKeys;

const struct NSAttributedStringArchiveKeys NSAttributedStringArchiveKeys = {
    .rootString = @"rootString",
    .attributes = @"attributes",
    .attributeDictionary = @"attributeDictionary",
    .attributeRange = @"attributeRange",
};

@interface NSAttributedString (Encoding_Private)
-(NSDictionary*) dictionaryRepresentation;
+(id) attributedStringWithDictionaryRepresentation:(NSDictionary*)dictionary;
@end

@implementation NSAttributedString (Encoding)

+(id) attributedStringWithData:(NSData*)data {
    return [self attributedStringWithDictionaryRepresentation:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

-(NSData*) convertToData {
    return [NSKeyedArchiver archivedDataWithRootObject:[self dictionaryRepresentation]];
}

@end


@implementation NSAttributedString (Encoding_Private)

+(id) attributedStringWithDictionaryRepresentation:(NSDictionary*)dictionary {
    
    NSString *string = [dictionary objectForKey:NSAttributedStringArchiveKeys.rootString];
    NSMutableAttributedString *retVal = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSArray *attributes = [dictionary objectForKey:NSAttributedStringArchiveKeys.attributes];
    [attributes enumerateObjectsUsingBlock:^(NSDictionary *attribute, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *attributeDictionary = [attribute objectForKey:NSAttributedStringArchiveKeys.attributeDictionary];
        NSRange range = NSRangeFromString([attribute objectForKey:NSAttributedStringArchiveKeys.attributeRange]);
        
        [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id attr, BOOL *stop) {
            
            if ([key isEqual:(NSString*)kCTFontAttributeName])
            {
                CTFontRef fontRef = [attr createFontRef];
                [retVal addAttribute:key value:(__bridge_transfer id)fontRef range:range];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorFromContextAttributeName] ||
                    [key isEqualToString:(NSString*)kCTKernAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeWidthAttributeName] ||
                    [key isEqualToString:(NSString*)kCTLigatureAttributeName] ||
                    [key isEqualToString:(NSString*)kCTSuperscriptAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineStyleAttributeName] ||
                    [key isEqualToString:(NSString*)kCTCharacterShapeAttributeName] ||
                    [key isEqualToString:(NSString*)kCTVerticalFormsAttributeName])
            {
                [retVal addAttribute:key value:attr range:range];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineColorAttributeName])
            {
                [retVal addAttribute:key value:(id)[attr CGColor] range:range];
            }
            else if([key isEqualToString:(NSString*)kCTParagraphStyleAttributeName])
            {
                CTParagraphStyleRef paragraphStyleRef = [attr createParagraphStyleRef];
                [retVal addAttribute:key value:(__bridge_transfer id)paragraphStyleRef range:range];
            }
            else if([key isEqualToString:(NSString*)kCTGlyphInfoAttributeName])
            {
                // TODO
            }
            else if([key isEqualToString:(NSString*)kCTRunDelegateAttributeName])
            {
                // TODO
            }
        }];
        
    }];
    
    return retVal;
}

-(NSDictionary*) dictionaryRepresentation {
    
    NSMutableDictionary *retVal = [NSMutableDictionary new];
    
    [retVal setObject:[self string] forKey:NSAttributedStringArchiveKeys.rootString];
    
    NSMutableArray *attributes = [NSMutableArray new];
    [retVal setObject:attributes forKey:NSAttributedStringArchiveKeys.attributes];
    
    [self enumerateAttributesInRange:NSMakeRange(0, [self length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        NSMutableDictionary *attribute = [NSMutableDictionary new];
        [attributes addObject:attribute];
        
        [attribute setObject:NSStringFromRange(range) forKey:NSAttributedStringArchiveKeys.attributeRange];
        NSMutableDictionary *attributeDictionary = [NSMutableDictionary new];
        [attribute setObject:attributeDictionary forKey:NSAttributedStringArchiveKeys.attributeDictionary];
        
        [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id attr, BOOL *stop) {
            
            if ([key isEqual:(NSString*)kCTFontAttributeName])
            {
                [attributeDictionary setObject:[[NSDictionary alloc] initWithFontRef:(__bridge CTFontRef)attr] forKey:key];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorFromContextAttributeName] ||
                    [key isEqualToString:(NSString*)kCTKernAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeWidthAttributeName] ||
                    [key isEqualToString:(NSString*)kCTLigatureAttributeName] ||
                    [key isEqualToString:(NSString*)kCTSuperscriptAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineStyleAttributeName] ||
                    [key isEqualToString:(NSString*)kCTCharacterShapeAttributeName] ||
                    [key isEqualToString:(NSString*)kCTVerticalFormsAttributeName])
            {
                [attributeDictionary setObject:attr forKey:key];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineColorAttributeName])
            {
                [attributeDictionary setObject:[UIColor colorWithCGColor:(CGColorRef)attr] forKey:key];
            }
            else if([key isEqualToString:(NSString*)kCTParagraphStyleAttributeName])
            {
                [attributeDictionary setObject:[[NSDictionary alloc] initWithParagraphStyleRef:(__bridge CTParagraphStyleRef)attr] forKey:key];
            }
            else if([key isEqualToString:(NSString*)kCTGlyphInfoAttributeName])
            {
                // TODO
            }
            else if([key isEqualToString:(NSString*)kCTRunDelegateAttributeName])
            {
                // TODO
            }
        }];
    }];
    
    return retVal;
}

@end
