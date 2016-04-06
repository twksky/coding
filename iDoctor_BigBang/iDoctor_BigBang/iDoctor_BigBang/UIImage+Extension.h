//
//  UIImage+Extension.h
//  iDoctor
//
//  Created by hexy on 15/7/2.
//  Copyright (c) 2015年 hexy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  通过图片的名称返回图片对象
 *
 *  @param name 图片名
 *
 *  @return 图片对象
 */
+ (UIImage *)imageWithName: (NSString *)name;

/**
 *  返回一张自由拉伸的图片
 *
 *  @param name 图片名
 *
 *  @return 自由拉伸的图片对象
 */
+ (UIImage *)resizedImageWithName: (NSString *)name;

/**
 *  取得圆形图片
 *
 *  @param name        原图片名
 *  @param borderWidth 需要的边框宽度
 *  @param borderColor 需要的变宽颜色
 *
 *  @return 圆形的图片
 */
+ (instancetype)getCircleImageWithName:(NSString *)name
                        andBorderWidth:(CGFloat)borderWidth
                       andBorderCorlor:(UIColor *)borderColor;
/**
 *  取得圆形图片
 *
 *  @param image       原图片
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 *
 *  @return
 */
+ (instancetype)getCircleImageWithImage:(UIImage *)image
                         andBorderWidth:(CGFloat)borderWidth
                        andBorderCorlor:(UIColor *)borderColor;
/**
 *  取得纯色图片
 *
 *  @param color 颜色
 *
 *  @return
 */
+ (UIImage *)createImageWithColor: (UIColor*)color;

/**
 *  取得纯色指定大小的图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return
 */
+ (UIImage *)createImageWithColor: (UIColor*)color
                          andSize:(CGSize)size;

/**
 *  返回一张自由拉伸的图片
 *
 *  @param image 原图片
 *
 *  @return
 */
+ (UIImage *)resizedImageWithImage: (UIImage *)image;

/**
 *  返回圆角图片
 *
 *  @param image <#image description#>
 *  @param size  <#size description#>
 *  @param r     <#r description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
