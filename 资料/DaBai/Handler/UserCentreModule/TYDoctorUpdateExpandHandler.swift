//
//  TYDoctorUpdateExpandHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/2.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateExpandHandler: TYBaseHandler {
    override init() {
        super.init()
        self.API = TYAPI_DOCTOR_INFORMATION_COMPLETE
    }
    func executeDoctorUpdateTask(doctor:TYDoctorUpdateExpandEntity,success:((AFHTTPRequestOperation!,AnyObject!) -> Void)!,failed:((AFHTTPRequestOperation!,NSError!) -> Void)!){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        var parameter:NSDictionary = ["userId":doctor.userId,"headImg":doctor.headImg,"dmotto":doctor.dmotto,"personalSpecialty":doctor.personalSpecialty,"dresume":doctor.dresume]
        manager.POST(self.requestUrl, parameters: parameter, success: success, failure: failed)
    }
}
