//
//  UIViewController+Category.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    convenience init (aTitle: String) {
        
        self.init()
        title = aTitle
    }

    private struct AssociatedKeys {
        static var DescriptiveName = "nsh_DescriptiveName"
    }
    
    var descriptiveName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.DescriptiveName) as? String
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.DescriptiveName,
                    newValue as NSString?,
                    objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    public override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        if self !== UIViewController.self {
            return
        }
        
        dispatch_once(&Static.token) {
            
            let originalSelector = Selector("viewWillAppear:")
            let swizzledSelector = Selector("xx_viewWillAppear:")
            
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                
            } else {
                
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
            
            let originalSelector1 = Selector("viewWillDisappear:")
            let swizzledSelector1 = Selector("xx_viewWillDisappear:")
            
            
            let originalMethod1 = class_getInstanceMethod(self, originalSelector1)
            let swizzledMethod1 = class_getInstanceMethod(self, swizzledSelector1)
            
            let didAddMethod1 = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod1))
            
            if didAddMethod1 {
                
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod1), method_getTypeEncoding(originalMethod1))
                
            } else {
                
                method_exchangeImplementations(originalMethod1, swizzledMethod1);
            }
        }
    }
//
    // MARK: - Method Swizzling
    
    func xx_viewWillAppear(animated: Bool) {
        
        self.xx_viewWillAppear(animated)
        
//        if let name = self.descriptiveName {
//            
//            xx_print("viewWillAppear: \(name)")
//            
//        } else {
//            
//            guard let className = NSString(UTF8String: object_getClassName(self)) else { return }
//            guard let title = self.navigationController?.title else { return }
//            
//            xx_print("viewWillAppear -> \(className):\(title)")
//        }
    }

    func xx_viewWillDisappear(animated: Bool) {
        
        self.xx_viewWillDisappear(animated)
        xx_hideHUD()
    }


}