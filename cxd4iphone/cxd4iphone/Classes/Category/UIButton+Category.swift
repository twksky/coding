//
//  UIButton+Category.swift
//  cxd4iphone
//
//  Created by hexy on 11/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

extension UIButton {
    
    
    convenience init(title: String, target: AnyObject?, action: Selector) {
        
        self.init()
        
        backgroundColor = xx_randomColor()
        
        setTitle(title, forState: .Normal)
//        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    convenience init(title: String, titleColor: UIColor, titleSize: CGFloat, bgColor: UIColor) {
        
        self.init()
        
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        backgroundColor = bgColor
        titleLabel?.font = xx_fontOfSize(size: titleSize)
        setTitle(title, forState: .Normal)
        setTitleColor(titleColor, forState: .Normal)
        titleLabel?.sizeToFit()
    }
    
    convenience init(title: String, titleColor: UIColor, titleSize: CGFloat, bgColor: UIColor, normalImage: UIImage?) {
        
        self.init()
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        backgroundColor = bgColor
        titleLabel?.font = xx_fontOfSize(size: titleSize)
        setTitle(title, forState: .Normal)
        setTitleColor(titleColor, forState: .Normal)
        titleLabel?.sizeToFit()
        
        setImage(normalImage, forState: .Normal)
        sizeToFit()
    }
}