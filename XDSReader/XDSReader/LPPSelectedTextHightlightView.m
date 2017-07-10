//
//  LPPSelectedTextHightlightView.m
//  XDSReader
//
//  Created by dusheng.xu on 07/07/2017.
//  Copyright © 2017 macos. All rights reserved.
//

#import "LPPSelectedTextHightlightView.h"

@implementation LPPSelectedTextHightlightView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGMutablePathRef _path = CGPathCreateMutable();
    [[UIColor cyanColor] setFill];
    for (int i = 0; i < [_pathArray count]; i++) {
        CGRect rect = CGRectFromString([_pathArray objectAtIndex:i]);
        CGPathAddRect(_path, NULL, rect);
//        if (i == 0) {
//            *leftDot = rect;
//            _menuRect = rect;
//        }
//        if (i == [array count]-1) {
//            *rightDot = rect;
//        }
        
    }
    
    //绘制选择区域的背景色
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}


- (void)setPathArray:(NSArray *)pathArray{
    _pathArray = pathArray;
    [self setNeedsDisplay];
}

@end
