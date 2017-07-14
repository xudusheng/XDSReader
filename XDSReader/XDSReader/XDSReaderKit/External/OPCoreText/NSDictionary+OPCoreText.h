//
//  NSDictionary+OPCoreText.h
//  OPCoreText
//
//  Created by Brandon Williams on 4/8/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface NSDictionary (OPCoreText)

/**
 Methods to convert CTParagraphStyleRef objects to dictionaries, and back.
 */
-(id) initWithParagraphStyleRef:(CTParagraphStyleRef)paragraphStyleRef;
-(CTParagraphStyleRef) createParagraphStyleRef;

/**
 Methods to convert CTFontRef objects to dictionaries, and back.
 */
-(id) initWithFontRef:(CTFontRef)fontRef;
-(CTFontRef) createFontRef;

@end
