//
//  UIView+Subview.m
//  ReFanqie
//
//  Created by ABC on 4/8/14.
//  Copyright (c) 2014 com.iHaoyisheng. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)

+ (UIView *)getSubviewInView:(UIView *)view withTag:(NSInteger)tag
{
    return [view subviewWithTag:tag];
}

- (UIView *)subviewWithTag:(NSInteger)tag
{
    for (UIView *subview in self.subviews) {
        if(subview.tag == tag) {
            return subview;
        }
    }
    return nil;
}

- (void)removeAllSubviews
{
    for(UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
}

@end
