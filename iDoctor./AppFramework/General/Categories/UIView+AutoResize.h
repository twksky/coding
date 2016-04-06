//
//  UIView+AutoResize.h
//  ReFanqie
//
//  Created by ABC on 4/3/14.
//  Copyright (c) 2014 com.iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoResize)
- (void)fixLeftEdge:(BOOL)fixed;
- (void)fixRightEdge:(BOOL)fixed;
- (void)fixTopEdge:(BOOL)fixed;
- (void)fixBottomEdge:(BOOL)fixed;
- (void)fixWidth:(BOOL)fixed;
- (void)fixHeight:(BOOL)fixed;
@end
