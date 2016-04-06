//
//  AppDelegate.swift
//  cxd4iphone
///
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//



import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        
//        startBugTags()
        startBaiduMobStat()
        return true
    }
    
    func startBugTags() {
        
        Bugtags.startWithAppKey("5c42605b4c5631c18028bf6c88c1cb2d", invocationEvent: BTGInvocationEventBubble)
    }
    
    func startBaiduMobStat() {
        
        let statTracker = BaiduMobStat.defaultStat()

        statTracker.shortAppVersion = xx_version()
        statTracker.enableExceptionLog = false
        statTracker.monitorStrategy = BaiduMobStatMonitorStrategyPageView
        statTracker.enableDebugOn = false
        
        statTracker.startWithAppId("cf69ff8877")
    }
    
    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {

    }

    func applicationWillTerminate(application: UIApplication) {

    }


}

