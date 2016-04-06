//
//  TYDoctorInformationStorage.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/26.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorInformationStorage: NSObject {
    class func saveDoctorInformation(doctorInformation:AnyObject?){
        if doctorInformation != nil {
            UserDefaultsUtils.saveValue(doctorInformation, key: "TYDoctorInformationStorage")
        }
    }
    class func doctorInformation() -> TYDoctorInformationEntity{
        var doctorInformation = TYDoctorInformationEntity()

        if let doctorInformationData:[String:AnyObject] = UserDefaultsUtils.valueWithKey("TYDoctorInformationStorage") as? [String:AnyObject] {
            doctorInformation.setValuesForKeysWithDictionary(doctorInformationData)
        }
        return doctorInformation
    }
    class func refreshInformation(successCallBack:(()->Void)!) {
        let handler = TYBaseHandler(API: TYAPI_GET_LOGIN_DATA)
        handler.executeTaskWithSVProgressHUD(nil, callBackData: { (callBackData) -> Void in
            let data:AnyObject! = callBackData
            if let sysConfigData = data["sysConfig"] as? [NSObject:AnyObject]    {
                TYSysConfigStorage.saveSysConfig(sysConfigData)
            }
            if let doctorData = data["dcDoctor"] as? [NSObject:AnyObject] {
                TYDoctorInformationStorage.saveDoctorInformation(doctorData)
            }
            if successCallBack != nil {
                successCallBack()
            }
        }, failed: nil)
    }
}
