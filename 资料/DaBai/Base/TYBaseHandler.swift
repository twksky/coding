//
//  TYBaseHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYBaseHandler: NSObject {
    var API:String!
    var requestUrl:String! {
        return TYSERVER_HOST + "/" + API
    }

    func executeTask(parameter:AnyObject?,success:((AnyObject!)->Void)!,failed:(()->Void)!){
        let manager = AFHTTPRequestOperationManager()
        if self.API != TYAPI_LOGIN {
            manager.requestSerializer = AFJSONRequestSerializer()
        }
        manager.POST(self.requestUrl, parameters: parameter, success: { (operation, responseObject) -> Void in
            if success != nil {
                success(responseObject)
            }
            }) { (operation, error) -> Void in
                if failed != nil {
                    failed()
                }
        }
    }
}
extension TYBaseHandler {
    convenience init(API:String) {
        self.init()
        self.API = API
    }
    func executeTaskWithSVProgressHUD(parameter:AnyObject?,callBackData:((AnyObject!)->Void)!,failed:(()->Void)!){
        self.executeTask(parameter, success: { (responseObject) -> Void in
            if let resultFlag = responseObject["optFlag"] as? Bool {
                if !resultFlag {
                    let message = responseObject["message"] as? String
                    if message == "登录过期,请重新登录!" || message == "请登录后再操作!" {
                        NSNotificationCenter.defaultCenter().postNotificationName("ReLogin", object: nil)
                    }
                    SVProgressHUD.showErrorWithStatus(message)
                }else {
                    let data:AnyObject! = responseObject.objectForKey("data")
                    callBackData(data)
                }
            }else {
                SVProgressHUD.showErrorWithStatus("数据解析失败")
            }
        }) { () -> Void in
            SVProgressHUD.showErrorWithStatus("服务器连接失败")
            if failed != nil {
                failed()
            }
        }
    }
}
