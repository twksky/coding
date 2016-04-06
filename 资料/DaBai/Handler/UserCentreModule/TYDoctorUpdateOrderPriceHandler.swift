//
//  TYDoctorUpdateOrderPriceHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateOrderPriceHandler: TYBaseHandler {
    override init() {
        super.init()
        self.API = TYAPI_DOCTOR_ORDER_PRICE_UPDATE
    }
    func executeDoctorUpdateOrderPriceTask(imgOrderPrice:String!,telOrderPrice:String!,videoOrderPrice:String!,followUpPrice:String!,success:((AFHTTPRequestOperation!,AnyObject!) -> Void)!,failed:((AFHTTPRequestOperation!,NSError!) -> Void)!){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        let parameter:NSDictionary! = ["userId":TYDoctorInformationStorage.doctorInformation().userId,"imgOrderPrice":imgOrderPrice,"telOrderPrice":telOrderPrice,"videoOrderPrice":videoOrderPrice,"followUpPrice":followUpPrice]

        manager.POST(self.requestUrl, parameters: parameter, success: success, failure: failed)
    }
}
