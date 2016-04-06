//
//  MainViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let alr:UIAlertView = UIAlertView.init(title: "何XX", message: "这个分支devel是什么意思？为什么master上面什么都没有？", delegate: nil, cancelButtonTitle: "何XX")
//        alr.show()
        setAppearance()
        
        addChildViewControllers()
        
//        xx_print(view)
//        xx_print(view)
//        xx_print("hahaha")
    }
    
    
    private func setAppearance() {
        
        // 1 > 设置NavigationBar的外观
        let appearance = UINavigationBar.appearance()
        
        appearance.translucent = false
        appearance.barTintColor = xx_colorWithHex(hexValue: 0x3e64b5)
//        appearance.barTintColor = xx_colorWithHex(hexValue: 0x054ce4)
        appearance.tintColor = UIColor.whiteColor()
        appearance.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: xx_fontOfSize(size: 18)];
        
        // 2 > 设置tabBar外观
        tabBar.tintColor = xx_colorWithHex(hexValue: 0x3d64b4)
        
    }
    
    ///  添加所有的子控制器
    private func addChildViewControllers() {
        
        addChildViewController(ChoiceViewController(), title: "精选", norImage: UIImage(named: "tabBar_choice_normal"), selectedImage: UIImage(named: "tabBar_choice_selected"))
        
        addChildViewController(InvestViewController(), title: "投资", norImage: UIImage(named: "tabBar_invest_normal"), selectedImage: UIImage(named: "tabBar_invest_selected"))
        
        addChildViewController(ServiceViewController(), title: "服务", norImage: UIImage(named: "tabBar_service_normal"), selectedImage: UIImage(named: "tabBar_service_selected"))
        
        addChildViewController(MeViewController(), title: "我", norImage: UIImage(named: "tabBar_me_normal"), selectedImage: UIImage(named: "tabBar_me_selected"))
        
    }
    
    ///  添加一个子控制器
    private func addChildViewController(vc: UIViewController, title: String, norImage: UIImage?,selectedImage: UIImage?) {
        
        vc.title = title
        vc.tabBarItem.image = norImage
        vc.tabBarItem.selectedImage = selectedImage
        
        let nav = NavigationController(rootViewController: vc)
        
        addChildViewController(nav)
    }
    
}
