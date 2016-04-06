//
//  ImageUtils.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *) createImageWithColor: (UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

@end
