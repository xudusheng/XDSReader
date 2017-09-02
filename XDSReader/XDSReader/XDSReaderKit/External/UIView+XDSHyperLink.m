//
//  UIView+XDSHyperLink.m
//  XDSReader
//
//  Created by Hmily on 2017/9/2.
//  Copyright © 2017年 macos. All rights reserved.
//

#import "UIView+XDSHyperLink.h"
#import <objc/runtime.h>
@implementation UIView (XDSHyperLink)

static const void *kXDSHyperLinkURLKey = &kXDSHyperLinkURLKey;

- (void)setHyperLinkURL:(NSURL *)hyperLinkURL {
    objc_setAssociatedObject(self, kXDSHyperLinkURLKey, hyperLinkURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL *)hyperLinkURL {
    return objc_getAssociatedObject(self, kXDSHyperLinkURLKey);
}

@end
