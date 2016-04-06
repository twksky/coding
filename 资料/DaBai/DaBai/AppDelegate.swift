//
//  AppDelegate.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/22.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var isLogin:Bool? {
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies as! [NSHTTPCookie] {
            let value:String? = cookie.valueForKey("value") as? String
            if value != nil {
                return true
            }
        }
        return false
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let notificationSetting = UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSetting)
        application.registerForRemoteNotifications()
        if isLogin! {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            if let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController") as? UITabBarController {
                nextViewController.selectedIndex = 2
                self.window?.rootViewController = nextViewController
            }
            TYWebSocket.shared.openWebSocket()
        }
        self.setNavigationBar()
        return true
    }
    func applicationDidEnterBackground(application: UIApplication) {
        TYWebSocket.shared.closeWebSocket()
    }
    func applicationWillEnterForeground(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        self.saveDeviceToken(deviceToken)
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println(userInfo)
        let aps: [NSObject : AnyObject]? = userInfo["aps"] as? [NSObject : AnyObject]
        if (aps != nil){
            if application.applicationState == UIApplicationState.Active {
                println("前台正跑着呢")
                NSNotificationCenter.defaultCenter().postNotificationName("showAlertNotification", object: userInfo)
            }else{
                println("用户点击通知框按钮进来的")
                NSNotificationCenter.defaultCenter().postNotificationName("showNewsNotification", object: userInfo)
            }
        }
    }
    private func saveDeviceToken(deviceToken: NSData) {
        let decToken = NSString(format: "%@", deviceToken)
        let arr:NSArray = decToken.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "<> "))
        let tokenStr = arr.componentsJoinedByString("")
        UserDefaultsUtils.saveValue(tokenStr, key: "deviceToken")
    }
    private func setNavigationBar(){
        let bar = UINavigationBar.appearance()
        bar.tintColor = UIColor.whiteColor()
        bar.barTintColor = TYAppUtils.HexRGB(0x41B5E8)
        bar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
}

