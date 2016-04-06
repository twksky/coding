//
//  TYConsultTableViewCell.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/11.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYConsultTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberLable: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientAgeLabel: UILabel!
    @IBOutlet weak var consultStateLabel: UILabel!
    var model:TYConsultInfoEntity! {
        didSet{
            if model != nil {
                orderNumberLable.text = "\(model.orderNumber)"
                patientNameLabel.text = model.patientName
                consultStateLabel.text = consultStateText(model.consultState)
                if model.patientBirthDate != nil {
                    patientAgeLabel.text = "\(TYAppUtils.ageWithDateOfBirthString(model.patientBirthDate))"
                }
            }
        }
    }
    
    private func consultStateText(consultState:String)->String {
        switch consultState {
        case "1":
            return "未咨询"
        case "2":
            return "发起/待确认"
        case "3":
            return "接受/待支付"
        case "5":
            return "进行中/支付完成"
        case "6":
            return "拒绝"
        case "7":
            return "结束"
        case "8":
            return "取消"
        default :
            return "未定义"
        }
    }
}
