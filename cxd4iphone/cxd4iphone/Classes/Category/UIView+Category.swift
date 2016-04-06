//
//  UIView+Category.swift
//  cxd4iphone
//
//  Created by hexy on 11/28/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    convenience init(bgColor: UIColor?) {
        
        self.init()
        if bgColor != nil {
            
            backgroundColor = bgColor
        }
    }
}