//
//  TYDoctorUpdateOrderStateHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateOrderStateHandler: TYBaseHandler {
    override init() {
        super.init()
        self.API = TYAPI_DOCTOR_ORDER_STATE_UPDATE
    }
    func executeDoctorUpdateOrderStateTask(imgOrderState:String!,telOrderState:String!,videoOrderState:String!, success:((AFHTTPRequestOperation!,AnyObject!) -> Void)!,failed:((AFHTTPRequestOperation!,NSError!) -> Void)!){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        let parameter:NSDictionary! = ["userId":TYDoctorInformationStorage.doctorInformation().userId,"imgOrderState":imgOrderState,"telOrderState":telOrderState,"videoOrderState":videoOrderState]
        manager.POST(self.requestUrl, parameters: parameter, success: success, failure: failed)
    }
}
