//
//  TYSysConfigStorage.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/26.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import Foundation

class TYSysConfigStorage: NSObject {
    class func saveSysConfig(sysConfig:AnyObject?){
        if sysConfig != nil {
            UserDefaultsUtils.saveValue(sysConfig, key: "SysConfig")
        }
    }
    class func sysConfig() -> TYSysConfigEntity{
        let sysConfig = TYSysConfigEntity()
        if let sysConfigData:[String:AnyObject] = UserDefaultsUtils.valueWithKey("SysConfig") as? [String:AnyObject] {
            sysConfig.setValuesForKeysWithDictionary(sysConfigData)
        }
        return sysConfig
    }
}