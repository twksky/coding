//
//  TYDoctorUpdateAccountHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/26.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateAccountHandler: TYBaseHandler {
    override init() {
        super.init()
        self.API = TYAPI_DOCTOR_UPDATE_ACCOUNT
    }
    func executeDoctorUpdateAccountTask(doctorAccount:TYDoctorAccountEntity,success:((AFHTTPRequestOperation!,AnyObject!) -> Void)!,failed:((AFHTTPRequestOperation!,NSError!) -> Void)!){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        var parameter:NSDictionary = ["userId":doctorAccount.userId,"userName":doctorAccount.userName,"userTel":doctorAccount.userTel,"idCard":doctorAccount.idCard,"account":doctorAccount.account,"accountType":doctorAccount.accountType,"accountName":doctorAccount.accountName]
        manager.POST(self.requestUrl, parameters: parameter, success: success, failure: failed)
    }
}
