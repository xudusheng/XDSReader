//
//  NSAttributedString+Opetopic.h
//  NSAttributedString+Opetopic
//
//  Created by Brandon Williams on 4/6/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface NSAttributedString (Encoding)

/**
 Create an NSAttributedString from an NSData object (which must have been created by the `-convertToData` method).
 */
+(id) attributedStringWithData:(NSData*)data;

/**
 Convert an NSAttributedString to an NSData object. I would have loved to just call this method `-data`, but alas
 that may conflict with future methods on this class.
 */
-(NSData*) convertToData;

@end
