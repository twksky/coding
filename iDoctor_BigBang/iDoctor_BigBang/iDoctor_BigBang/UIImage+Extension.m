//
//  UIImage+Extension.m
//  iDoctor
//
//  Created by hexy on 15/7/2.
//  Copyright (c) 2015年 hexy. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)name
{
    // 或者做一些其他的事情
    
    return [UIImage imageNamed:name];
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+(instancetype)getCircleImageWithName:(NSString *)name andBorderWidth:(CGFloat)borderWidth andBorderCorlor:(UIColor *)borderColor
{
    // 1. 加载原图
    UIImage *originImage = [UIImage imageNamed:name];
    
    // 2. 开启图片上下文
    CGFloat imageW = originImage.size.width + 2 * borderWidth;
    CGFloat imageH = originImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3. 取得当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 4. 画大圆
    // 4.1 设置颜色
    [borderColor set];
    
    // 4.2 设置大圆半径
    CGFloat bigRadius = imageW * 0.5;
    
    // 4.3 设置大圆圆心
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    
    // 4.4 画大圆
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    
    // 5. 裁剪小圆
    // 5.1 设置小圆的半径
    CGFloat smallRadius = bigRadius - borderWidth;
    
    // 5.2 裁剪小圆
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    // 6. 画图
    CGRect rect = CGRectMake(borderWidth, borderWidth, originImage.size.width, originImage.size.height);
    [originImage drawInRect:rect];
    
    // 7. 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8. 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 9. 返回新的图片
    return newImage;
}
+ (instancetype)getCircleImageWithImage:(UIImage *)image andBorderWidth:(CGFloat)borderWidth andBorderCorlor:(UIColor *)borderColor
{
    // 1. 加载原图
    UIImage *originImage = image;
    
    // 2. 开启图片上下文
    CGFloat imageW = originImage.size.width + 2 * borderWidth;
    CGFloat imageH = originImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3. 取得当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 4. 画大圆
    // 4.1 设置颜色
    [borderColor set];
    
    // 4.2 设置大圆半径
    CGFloat bigRadius = imageW * 0.5;
    
    // 4.3 设置大圆圆心
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    
    // 4.4 画大圆
    CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(context);
    
    // 5. 裁剪小圆
    // 5.1 设置小圆的半径
    CGFloat smallRadius = bigRadius - borderWidth;
    
    // 5.2 裁剪小圆
    CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(context);
    
    // 6. 画图
    CGRect rect = CGRectMake(borderWidth, borderWidth, originImage.size.width, originImage.size.height);
    [originImage drawInRect:rect];
    
    // 7. 取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8. 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 9. 返回新的图片
    return newImage;

}
+ (UIImage *)createImageWithColor: (UIColor*)color
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

+(UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)resizedImageWithImage: (UIImage *)image
{
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)r
{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@end
