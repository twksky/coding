//
//  TYBaseViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        println(self.description)
        self.creatReLoginNSNotification()
    }
    func creatReLoginNSNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reLogin", name: "ReLogin", object: nil)

    }
    func reLogin(){
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies as! [NSHTTPCookie] {
            cookieJar.deleteCookie(cookie)
        }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController = mainStoryboard.instantiateInitialViewController() as! UIViewController
        self.presentViewController(nextViewController, animated: true, completion: nil)
    }
}
