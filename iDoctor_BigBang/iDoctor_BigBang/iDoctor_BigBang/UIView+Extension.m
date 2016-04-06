//
//  UIView+Extension.m
//  GoodDoctor
//
//  Created by hexy on 15/7/4.
//  Copyright (c) 2015年 hexy. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setFX:(CGFloat)fX
{
    CGRect frame = self.frame;
    frame.origin.x = fX;
    self.frame = frame;
}

- (CGFloat)fX
{
    return self.frame.origin.x;
}

- (void)setFY:(CGFloat)fY
{
    CGRect frame = self.frame;
    frame.origin.y = fY;
    self.frame = frame;
}

- (CGFloat)fY
{
    return self.frame.origin.y;
}
- (void)setFWidth:(CGFloat)fWidth
{
    CGRect frame = self.frame;
    frame.size.width = fWidth;
    self.frame = frame;

}

- (CGFloat)fWidth
{
    return self.frame.size.width;
}
- (void)setFHeight:(CGFloat)fHeight
{
    CGRect frame = self.frame;
    frame.size.height = fHeight;
    self.frame = frame;

}

- (CGFloat)fHeight
{
    return self.frame.size.height;
}

- (void)setFSize:(CGSize)fSize
{
    CGRect frame = self.frame;
    frame.size = fSize;
    self.frame = frame;
}

- (CGSize)fSize
{
    return self.frame.size;
}
- (void)setFOrigin:(CGPoint)fOrigin
{
    CGRect frame = self.frame;
    frame.origin = fOrigin;
    self.frame = frame;

}
- (CGPoint)fOrigin
{
    return self.frame.origin;
}

-(void)setFCenter:(CGPoint)fCenter{
    CGPoint center = self.center;
    center = fCenter;
    self.center = center;
}

- (CGPoint)fCenter
{
    return self.center;
}

@end
