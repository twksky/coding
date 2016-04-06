//
//  MenuButton.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/2/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MenuButton.h"

@implementation MenuButton

- (void)setHighlighted:(BOOL)highlighted
{
    
}
- (instancetype)init
{
    if (self = [super init]) {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width * 0.6;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = contentRect.size.width * 0.6 + 5;
    CGFloat imageY = (contentRect.size.height - 4) / 2;
    CGFloat imageW = 8;
    CGFloat imageH = 4;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
