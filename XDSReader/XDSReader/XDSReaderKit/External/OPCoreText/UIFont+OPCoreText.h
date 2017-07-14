//
//  UIFont+OPCoreText.h
//  OPCoreText
//
//  Created by Brandon Williams on 4/8/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (OPCoreText)

+(id) fontWithFontRef:(CTFontRef)fontRef;
-(CTFontRef) createFontRef;

@end
