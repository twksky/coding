//
//  NSView+Hierarchy.m
//  Fetion
//
//  Created by LuYingming on 13-12-12.
//  Copyright (c) 2013年 TCS. All rights reserved.
//

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

+ (NSString *)hierarchicalDescriptionOfView:(UIView *)view level:(NSUInteger)level
{
    
    // Ready the description string for this level
    NSMutableString * builtHierarchicalString = [NSMutableString string];
    
    // Build the tab string for the current level's indentation
    NSMutableString * tabString = [NSMutableString string];
    for (NSUInteger i = 0; i <= level; i++)
        [tabString appendString:@"\t"];
    
    // Get the view's title string if it has one
    NSString * titleString = ([view respondsToSelector:@selector(title)]) ? [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"\"%@\" ", [(UIButton *)view titleForState:UIControlStateNormal]]] : @"";
    
    // Append our own description at this level
    [builtHierarchicalString appendFormat:@"\n%@<%@: %p> %@(%li subviews)", tabString, NSStringFromClass([view class]), view, titleString, (unsigned long)[[view subviews] count]];
    
    // Recurse for each subview ...
    for (UIView * subview in [view subviews]) {
        [builtHierarchicalString appendString:[UIView hierarchicalDescriptionOfView:subview level:(level + 1)]];
    }
    
    return builtHierarchicalString;
}

+ (NSString *)hierarchicalDescriptionOfLayer:(CALayer *)layer level:(NSUInteger)level
{
    // Ready the description string for this level
    NSMutableString *builtHierarchicalString = [NSMutableString string];
    
    // Build the tab string for the current level's indentation
    NSMutableString * tabString = [NSMutableString string];
    for (NSUInteger i = 0; i <= level; i++)
        [tabString appendString:@"\t"];
    
    // Append our own description at this level
    [builtHierarchicalString appendFormat:@"\n%@<%@: %p> (%li sublayers)", tabString, NSStringFromClass([layer class]), layer, (unsigned long)[[layer sublayers] count]];
    
    // Recurse for each sublayer ...
    for (CALayer *sublayer in [layer sublayers]) {
        [builtHierarchicalString appendString:[UIView hierarchicalDescriptionOfLayer:sublayer level:(level + 1)]];
    }
    
    return builtHierarchicalString;
}

- (void)logViewHierarchy
{
    NSLog(@"%@", [UIView hierarchicalDescriptionOfView:self level:0]);
}

- (void)logLayerHierarchy
{
    NSLog(@"%@", [UIView hierarchicalDescriptionOfLayer:self.layer level:0]);
}
@end
