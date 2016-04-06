//
//  NavigationController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func pushViewController(viewController: UIViewController, animated: Bool) {
        
        if childViewControllers.count > 0 {
            
            let rootController = childViewControllers[0]
            
            if viewController != rootController {
                
                viewController.hidesBottomBarWhenPushed = true
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
}
