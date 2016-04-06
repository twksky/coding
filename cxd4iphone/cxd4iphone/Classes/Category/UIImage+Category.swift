//
//  UIImage+Category.swift
//  cxd4iphone
//
//  Created by hexy on 11/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

extension UIImage {

    // 类方法 class func 
    // 对象方法 func

    // 通过图片的名称返回图片对象
    class func imageWithName(name:String) -> UIImage {
        
        return UIImage(named: name)!
    }
    
    
    // 返回一个调整好图片大小的Image
    class  func resizedImageWithName(name:String) -> UIImage {
    
        let image:UIImage = UIImage.imageWithName(name)
        
        let imageWidth:CGFloat = image.size.width * 0.5
        
        let imageHeight:CGFloat = image.size.height * 0.5
        
        return image.stretchableImageWithLeftCapWidth(Int(imageWidth), topCapHeight:Int(imageHeight))
    
    }
    
    
    // 得到一张带有圆角的图片  通过图片的名称：name 圆角的大小：boardWidth 圆角的颜色：boardColor 
    class func getCirCleImgae(name:String, boardWidth width:CGFloat, boardColor color:UIColor) -> UIImage {
        
        // 1 加载图片
        let image:UIImage = UIImage.imageWithName(name)
        
        // 2 开启图形上下文
        let imageW:CGFloat = image.size.width + 2 * width
        let imageH:CGFloat = image.size.height + 2 * width
        let imageSize:CGSize = CGSizeMake(imageW, imageH)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
        
        // 3 取得当前上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 4 画大图
        // 4.1 设置颜色
        color.set()
        
        // 4.2 设置大圆的半径
        let bigRadius:CGFloat = imageW * 0.5
        
        // 4.3 设置大圆圆心
        let centerX:CGFloat = bigRadius
        let centerY:CGFloat = bigRadius
        
        // 4.4 画大圆
        CGContextAddArc(context, centerX, centerY, bigRadius, 0, CGFloat(M_PI * 2), 0);
        CGContextFillPath(context)
        
        // 5 裁剪小圆
        // 5.1 设置小圆的半径
        let smallRadius:CGFloat = bigRadius - width;
        
        // 5.2 裁剪小圆
        CGContextAddArc(context, centerX, centerY, smallRadius, 0, CGFloat(M_PI * 2), 0);
        CGContextClip(context);
        
        // 6 画圆
        let rect:CGRect = CGRectMake(width, width, image.size.width, image.size.height);
        image.drawInRect(rect)
    
        
        // 7 取图
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 8 关闭图形上下文
        UIGraphicsEndImageContext()
        
        // 9 返回新的图片
        return newImage
    }
    
    // 通过颜色创造一张纯色的图片
    class func createImgaeWithColor(color:UIColor) -> UIImage{
        
        let rect:CGRect = CGRectMake(0, 0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillRect(context, rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    // 创建一张带有大小的图片
    class func creatImageWithColorAndSize(color:UIColor, Size size:CGSize) -> UIImage {
        
        let rect:CGRect = CGRectMake(0, 0, size.width, size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    
    }
    
    // 裁剪一张图片
    class func resizedImage(image:UIImage) -> UIImage {

        return image.stretchableImageWithLeftCapWidth(Int(image.size.width * 0.5), topCapHeight: Int(image.size.height * 0.5))
    }
    
    // 创建一张带圆角的图
    class func createRoundRectImage(image:UIImage, Size size:CGSize, Radius radius:Int) -> UIImage{
        
        let w:Int = Int(size.width)
        let h:Int = Int(size.height)
        
        var newImage:UIImage = image
        
        let colorSpace:CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        let context:CGContextRef = CGBitmapContextCreate(nil, w, h, 8, 4 * w, colorSpace, 2)!
       
        let rect:CGRect = CGRectMake(0, 0, CGFloat(w), CGFloat(h))
        
        CGContextBeginPath(context)
        
        newImage.addRoundRectTopath(context, rect, CGFloat(radius), CGFloat(radius))
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(w), CGFloat(h)), newImage.CGImage);
        let imageMasked:CGImageRef  = CGBitmapContextCreateImage(context)!
        newImage = UIImage.init(CGImage: imageMasked)
        
       
        return newImage;
 
    }

    func addRoundRectTopath(context:CGContextRef, _ rect:CGRect, _ ovalWidth:CGFloat, _ ovalHeight:CGFloat) {
    
        let fw:CGFloat?,fh:CGFloat?
        if (ovalHeight == 0 || ovalWidth == 0) {
        
            CGContextAddRect(context, rect)
        
            return
        }
        
        
        // 保存现有状态
        CGContextSaveGState(context)
        
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        
        CGContextScaleCTM(context, ovalWidth, ovalHeight)
        
        fw = CGRectGetWidth(rect) / ovalWidth
        fh = CGRectGetHeight(rect) / ovalHeight
    
        CGContextMoveToPoint(context, fw!, fh!/2);
        CGContextAddArcToPoint(context, fw!, fh!, fw!/2, fh!, 1);
        CGContextAddArcToPoint(context, 0, fh!, 0, fh!/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw!/2, 0, 1);
        CGContextAddArcToPoint(context, fw!, 0, fw!, fh!/2, 1);
        
        CGContextClosePath(context);
        CGContextRestoreGState(context);
 
    }
  
    
    
}


