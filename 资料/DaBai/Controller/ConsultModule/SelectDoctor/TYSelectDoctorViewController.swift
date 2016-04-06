//
//  TYSelectDoctorViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/16.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYSelectDoctorViewController: TYBaseViewController {
    /// 医生ID
    var doctorId:Int = 0
    @IBAction func submit(sender: UIButton) {
        let handler = TYBaseHandler(API: TYAPI_ADD_CONSULT)
        var parameter = []
        handler.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            
        }, failed: nil)
    }
    func downLoadData(){
        let handler = TYBaseHandler(API: TYAPI_DOCTOR_INFO)
        var parameter = ["userId":self.doctorId]
        handler.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            println(callBackData)
        }, failed: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downLoadData()
    }
}
