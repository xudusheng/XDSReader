//
//  NSString+HTML_XDSReader.m
//  XDSReader
//
//  Created by dusheng.xu on 26/08/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "NSString+HTML_XDSReader.h"

@implementation NSString (HTML_XDSReader)

// Strip HTML tags
- (NSString *)stringByConvertingHTMLToPlainText {
    
    // Pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Character sets
    NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
    NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"]; /**/
    
    // Scan and find all tags
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    [scanner setCaseSensitive:YES];
    NSString *str = nil, *tagName = nil;
    BOOL dontReplaceTagWithSpace = NO;
    do {
        
        // Scan up to the start of a tag or whitespace
        if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
            [result appendString:str];
            str = nil; // reset
        }
        
        // Check if we've stopped at a tag/comment or whitespace
        if ([scanner scanString:@"<" intoString:NULL]) {
            
            // Stopped at a comment or tag
            if ([scanner scanString:@"!--" intoString:NULL]) {
                
                // Comment
                [scanner scanUpToString:@"-->" intoString:NULL];
                
                [scanner scanString:@"-->" intoString:NULL];
                
            } else {
                
                // Tag - remove and replace with space unless it's
                if ([scanner scanString:@"/p>" intoString:NULL]) {
                    [result appendString:@"\n"];
                    [result appendString:@"  "];
                    
                }
                if ([scanner scanString:@"/h" intoString:NULL]) {
                    [result appendString:@"\n"];
                }
                if ([scanner scanString:@"img" intoString:NULL]) {
                    [scanner scanUpToString:@"src" intoString:NULL];
                    [scanner scanString:@"src" intoString:NULL];
                    [scanner scanString:@"=" intoString:NULL];
                    [scanner scanString:@"\'" intoString:NULL];
                    [scanner scanString:@"\"" intoString:NULL];
                    NSString *imgString;
                    if ([scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"\'"] intoString:&imgString]) {
                        [result appendString:[NSString stringWithFormat:@"\n<img>%@</img>\n",imgString]];
                        imgString = nil; // reset
                    }
                    
                }
                if ([scanner scanString:@"title" intoString:NULL]) {
                    [scanner scanUpToString:@"</title>" intoString:NULL];
                    [scanner scanString:@"</title>" intoString:NULL];
                }
                // a closing inline tag then dont replace with a space
                if ([scanner scanString:@"/" intoString:NULL]) {
                    
                    
                    // Closing tag - replace with space unless it's inline
                    tagName = nil; dontReplaceTagWithSpace = NO;
                    if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
                        tagName = [tagName lowercaseString];
                        dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
                                                   [tagName isEqualToString:@"b"] ||
                                                   [tagName isEqualToString:@"i"] ||
                                                   [tagName isEqualToString:@"q"] ||
                                                   [tagName isEqualToString:@"span"] ||
                                                   [tagName isEqualToString:@"em"] ||
                                                   [tagName isEqualToString:@"strong"] ||
                                                   [tagName isEqualToString:@"cite"] ||
                                                   [tagName isEqualToString:@"abbr"] ||
                                                   [tagName isEqualToString:@"acronym"] ||
                                                   [tagName isEqualToString:@"label"]);
                    }
                    
                    // Replace tag with string unless it was an inline
                    if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                    
                }
                
                // Scan past tag
                [scanner scanUpToString:@">" intoString:NULL];
                
                [scanner scanString:@">" intoString:NULL];
                
            }
            
        } else {
            
            // Stopped at whitespace - replace all whitespace and newlines with a space
            if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
            }
            
        }
        
    } while (![scanner isAtEnd]);
    
    // Cleanup
    [scanner release];
    
    // Decode HTML entities and return
    NSString *retString = [[result stringByDecodingHTMLEntities] retain];
    [result release];
    
    // Drain
    [pool drain];
    
    // Return
    return [retString autorelease];
    
}

@end
