//
//  CloseButton.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/23/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "CloseButton.h"

@implementation CloseButton

- (instancetype)init
{
    if (self = [super init]) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * 0.6;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height * 0.5;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0.0;
    CGFloat imageY = 0.0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * 0.7;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
