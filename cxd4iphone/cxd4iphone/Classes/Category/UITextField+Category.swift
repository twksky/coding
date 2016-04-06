//
//  UITextField+Category.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    convenience init(placeholder: String, leftImage: UIImage, keyboardType: UIKeyboardType) {
        
        self.init()
        
        backgroundColor = UIColor.whiteColor()
        
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = Define.textFieldColor
        
        self.placeholder = placeholder
//        borderStyle = .RoundedRect
        leftViewMode = .Always
        clearButtonMode = .WhileEditing
        self.keyboardType = keyboardType
        let leftBtn = UIButton(frame: CGRectMake(0, 0, 28, xx_height(38)))
        leftBtn.userInteractionEnabled = false
        leftBtn.setImage(leftImage, forState: .Normal)
        leftBtn.contentHorizontalAlignment = .Right
        leftViewMode = .Always
        leftView = leftBtn
    }
    
    convenience init(placeholder: String?, textAlignment: NSTextAlignment, keyboardType: UIKeyboardType) {
        
        self.init()
        
        backgroundColor = UIColor.whiteColor()
        
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1
        self.layer.borderColor = Define.textFieldColor
        
        self.leftView = UIView(frame: CGRectMake(0, 0, 10, xx_height(20)))
        self.leftViewMode = .Always
        self.placeholder = placeholder
        //        borderStyle = .RoundedRect
        self.textAlignment = textAlignment
        clearButtonMode = .WhileEditing
        self.keyboardType = keyboardType
    }

}
