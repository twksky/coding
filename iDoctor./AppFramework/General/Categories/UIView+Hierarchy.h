//
//  NSView+Hierarchy.h
//  Fetion
//
//  Created by 新媒传信 on 13-12-12.
//  Copyright (c) 2013年 TCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Hierarchy)

+ (NSString *)hierarchicalDescriptionOfView:(UIView *)view level:(NSUInteger)level;
+ (NSString *)hierarchicalDescriptionOfLayer:(CALayer *)layer level:(NSUInteger)level;
- (void)logViewHierarchy;
- (void)logLayerHierarchy;

@end
