//
//  UIClickableView.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/15.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "UIClickableView.h"

@implementation UIClickableView


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if (self.hightlightStateBackGroundColor) {
        
        self.backgroundColor = self.hightlightStateBackGroundColor;
    }
    
    NSLog(@"touchesBegan");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.normalStateBackGroundColor) {
        
        self.backgroundColor = self.normalStateBackGroundColor;
    }
    else {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    NSLog(@"touchesEnded");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.normalStateBackGroundColor) {
        
        self.backgroundColor = self.normalStateBackGroundColor;
    }
    else {
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    NSLog(@"touchesCancelled");
}

#pragma mark - properties

- (void)setNormalStateBackGroundColor:(UIColor *)normalStateBackGroundColor {
    
    self.backgroundColor = normalStateBackGroundColor;
    _normalStateBackGroundColor = normalStateBackGroundColor;
}

@end
