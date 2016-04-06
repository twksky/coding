//
//  UserDefaultsUtils.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/26.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import Foundation
class UserDefaultsUtils {
    class func saveValue(value:AnyObject?,key:String){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(value, forKey: key)
        userDefaults.synchronize()
    }
    class func valueWithKey(key:String) -> AnyObject? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.objectForKey(key)
    }
        
    class func saveIntValue(value:Int,key:String){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(value, forKey: key)
        userDefaults.synchronize()
    }
    class func intValueWithKey(key:String) -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.integerForKey(key)
    }

}