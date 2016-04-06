//
//  UILabel+Category.swift
//  cxd4iphone
//
//  Created by hexy on 11/23/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit


extension UILabel {
    
    convenience init(title: String,
                 fontColor: UIColor? = UIColor.blackColor(),
                   bgColor: UIColor? = UIColor.whiteColor(),
                  fontSize: CGFloat? = 14.0,
              maxWrapWidth: CGFloat? = 0)
    {
        
        self.init()
        
        text = title
        
        if fontColor != nil {
            
            textColor = fontColor
        }

        font = xx_fontOfSize(size: fontSize!)
        
        if bgColor != nil {
            
            backgroundColor = bgColor
        }
        
        if maxWrapWidth > 0 {
            
            numberOfLines = 0
            preferredMaxLayoutWidth = maxWrapWidth!
        }
        sizeToFit()
    }
    
    convenience init(title: String, fontSize: CGFloat) {
        
        self.init(title: title, fontColor: Define.darkFontColor, bgColor: nil, fontSize: fontSize, maxWrapWidth:0)
    }
}


