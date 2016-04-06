//
//  UIView+Subview.h
//  ReFanqie
//
//  Created by ABC on 4/8/14.
//  Copyright (c) 2014 com.iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Subview)

+ (UIView *)getSubviewInView:(UIView *)view withTag:(NSInteger)tag;

- (UIView *)subviewWithTag:(NSInteger)tag;
- (void)removeAllSubviews;

@end
