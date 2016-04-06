//
//  TYDoctorUpdateHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateHandler: TYBaseHandler {
    override init() {
        super.init()
        self.API = TYAPI_DOCTOR_UPDATE
    }
    func executeDoctorUpdateTask(doctor:TYDoctorUpdateEntity,success:((AFHTTPRequestOperation!,AnyObject!) -> Void)!,failed:((AFHTTPRequestOperation!,NSError!) -> Void)!){
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer = AFJSONRequestSerializer()
        var parameter:NSDictionary = ["userId":doctor.userId,"userName":doctor.userName,"birthDate":doctor.birthDate,"sexId":doctor.sexId,"province":doctor.province,"city":doctor.city,"town":doctor.town,"workOrg":doctor.workOrg,"workBigDep":doctor.workBigDep,"workDep":doctor.workDep,"workTitle":doctor.workTitle,"certTip":doctor.certTip,"certImg":doctor.certImg]
        manager.POST(self.requestUrl, parameters: parameter, success: success, failure: failed)
    }
}
