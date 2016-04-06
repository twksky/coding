//
//  UIView+AutoResize.m
//  ReFanqie
//
//  Created by ABC on 4/3/14.
//  Copyright (c) 2014 com.iHaoyisheng. All rights reserved.
//

#import "UIView+AutoResize.h"

@implementation UIView (AutoResize)
- (void)setAutoresizingBit:(unsigned int)bitMask toValue:(BOOL)set
{
    if (set)
    { [self setAutoresizingMask:([self autoresizingMask] | bitMask)]; }
    else
    { [self setAutoresizingMask:([self autoresizingMask] & ~bitMask)]; }
}

- (void)fixLeftEdge:(BOOL)fixed
{ [self setAutoresizingBit:UIViewAutoresizingFlexibleLeftMargin toValue:!fixed]; }

- (void)fixRightEdge:(BOOL)fixed
{ [self setAutoresizingBit:UIViewAutoresizingFlexibleRightMargin toValue:!fixed]; }

- (void)fixTopEdge:(BOOL)fixed
{ [self setAutoresizingBit:UIViewAutoresizingFlexibleTopMargin toValue:!fixed]; }

- (void)fixBottomEdge:(BOOL)fixed
{ [self setAutoresizingBit:UIViewAutoresizingFlexibleBottomMargin toValue:!fixed]; }

- (void)fixWidth:(BOOL)fixed
{ [self setAutoresizingBit:UIViewAutoresizingFlexibleWidth toValue:!fixed]; }

- (void)fixHeight:(BOOL)fixed
{ [self setAutoresizingBit:UIViewAutoresizingFlexibleHeight toValue:!fixed]; }
@end
