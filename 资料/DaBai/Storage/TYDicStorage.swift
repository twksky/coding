//
//  TYDicStorage.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDicStorage: NSObject {
    class func updateDicList() {
        let handle = TYBaseHandler(API: TYAPI_GET_DIC_LIST)
        handle.executeTask(nil, success: { (callBackData) -> Void in
            if let resultFlag = callBackData["optFlag"] as? Bool{
                if resultFlag {
                    UserDefaultsUtils.saveValue(callBackData, key: "TYDicStorage")
                }
            }
        }, failed: nil)
    }
    class func dicList() -> AnyObject?{
        return UserDefaultsUtils.valueWithKey("TYDicStorage")
    }
}
